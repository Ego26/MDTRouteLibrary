// Baut das Datenaddon aus allen Quellen.
//
// Ablauf:
//   1. MDTs Dungeonkatalog einlesen (Quelle der Wahrheit fuer Indizes und
//      Gegnertabellen).
//   2. Kuratierte und eingereichte Routen aus data/routes/ laden.
//   3. Optional keystone.guru-Routen aus data/cache/ konvertieren.
//   4. Alles pruefen, nach Dungeon buendeln, Lua erzeugen.
//   5. Inhaltshash mit dem letzten Build vergleichen.
//
// Schritt 5 ist der Grund, warum ein taegliches Release niemanden nervt: aendert
// sich nichts, gibt es kein Release. Der Exitcode sagt es der CI:
//   0 = Inhalt hat sich geaendert, veroeffentlichen
//   9 = unveraendert, nichts zu tun
//   1 = Fehler
//
// Aufruf:
//   node tools/build.mjs --mdt "<MDT-Pfad>" [--season midnight-s1] [--force]
//
// --out schreibt das Datenaddon woandershin und laesst data/build-state.json
// in Ruhe. Damit baut man Testdaten direkt in den WoW-Ordner, ohne dass das
// Repository davon etwas mitbekommt - die erzeugten Routendateien sehen
// naemlich genauso aus wie echte und landeten sonst irgendwann in einem
// Commit.

import { createHash } from 'node:crypto'
import { readdirSync, readFileSync, writeFileSync, existsSync, statSync } from 'node:fs'
import { join, dirname } from 'node:path'
import { fileURLToPath, pathToFileURL } from 'node:url'
import { readDungeons, buildLookup, readSeasons } from './mdt-dungeons.mjs'
import { convertRoute, validateRoute } from './keystone-convert.mjs'
import { buildDataAddon, writeDataAddon } from './generate-lua.mjs'

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..')
const STATE_FILE = join(ROOT, 'data', 'build-state.json')

const EXIT_CHANGED = 0
const EXIT_UNCHANGED = 9
const EXIT_ERROR = 1

/**
 * Hasht alles, was mit ausgeliefert wird - nicht nur die Routen.
 *
 * Der Inhaltshash entscheidet, ob es ein Release gibt. Deckte er nur die
 * Routendaten ab, blieben Fehlerbehebungen im Addon selbst liegen: die
 * planmaessigen Laeufe faenden "unveraendert" und veroeffentlichten nichts,
 * obwohl sich fuer den Nutzer sehr wohl etwas geaendert hat.
 *
 * @param {import('node:crypto').Hash} hash
 */
function hashAddonSources(hash) {
  const walk = (dir) => {
    if (!existsSync(dir)) return
    for (const name of readdirSync(dir).sort()) {
      const full = join(dir, name)
      if (statSync(full).isDirectory()) {
        walk(full)
      } else {
        hash.update(full.slice(ROOT.length).replace(/\\/g, '/'))
        hash.update(readFileSync(full))
      }
    }
  }

  // Genau das, was im Paket landet: Code, Sprachen, Grafiken, TOC.
  for (const dir of ['Core', 'Locales', 'Media']) walk(join(ROOT, dir))
  const toc = join(ROOT, 'MDTRouteLibrary.toc')
  if (existsSync(toc)) {
    hash.update('MDTRouteLibrary.toc')
    hash.update(readFileSync(toc))
  }
}

/** Liest alle JSON-Routen eines Ordners. */
function readRouteFiles(dir) {
  if (!existsSync(dir)) return []
  return readdirSync(dir)
    .filter((f) => f.endsWith('.json'))
    .sort()
    .map((f) => JSON.parse(readFileSync(join(dir, f), 'utf8')))
}

/**
 * Prueft eine fertige Route gegen MDTs Daten.
 *
 * @param {object} route
 * @param {object} lookup
 * @returns {string[]} Beanstandungen
 */
function checkRoute(route, lookup) {
  const issues = []

  const dungeon =
    lookup.byChallengeMode.get(route.challengeModeId) ??
    lookup.byName.get((route.dungeonEnglishName ?? '').toLowerCase())

  if (!dungeon) {
    issues.push(`Dungeon nicht in MDT: ${route.dungeonEnglishName ?? route.challengeModeId}`)
    return issues
  }

  // Der eingebackene Index ist nur ein Tipp fuers Spiel, muss aber stimmen.
  if (route.mdtDungeonIdx !== dungeon.mdtIndex) {
    issues.push(`mdtDungeonIdx ${route.mdtDungeonIdx} != ${dungeon.mdtIndex} (korrigiert)`)
    route.mdtDungeonIdx = dungeon.mdtIndex
  }

  const byIndex = new Map(dungeon.enemies.map((e) => [e.index, e]))
  for (const pull of route.pulls ?? []) {
    for (const entry of pull.enemies ?? []) {
      const enemy = byIndex.get(entry.enemy)
      if (!enemy) {
        issues.push(`Gegnerindex ${entry.enemy} unbekannt`)
        continue
      }
      if (entry.npc != null && enemy.id !== entry.npc) {
        issues.push(`Gegner ${entry.enemy} ist NPC ${enemy.id}, Route erwartet ${entry.npc}`)
      }
      // Gegen die echten Schluessel pruefen, nicht gegen 1..Anzahl: MDTs
      // Klontabellen haben Luecken.
      const keys = new Set(enemy.cloneKeys ?? [])
      for (const clone of entry.clones ?? []) {
        if (!keys.has(clone)) issues.push(`Klon ${entry.enemy}/${clone} unbekannt`)
      }
    }
  }

  return issues
}

/**
 * Ergaenzt eine Route um alles, was die Oberflaeche braucht:
 * NPC-Id je Gegner, Gegnerkraefte je Pull und die Boss-Markierung.
 *
 * Das passiert beim Bauen, nicht im Spiel: MDT gibt seine Gegnertabelle nicht
 * nach aussen, und im Addon waere die Rechnerei bei jedem Anzeigen unnoetig.
 *
 * @param {object} route
 * @param {object} dungeon
 * @param {Set<number>} usedNpcs Sammelt die tatsaechlich benutzten NPC-Ids
 */
function enrichRoute(route, dungeon, usedNpcs) {
  const byIndex = new Map(dungeon.enemies.map((e) => [e.index, e]))
  let running = 0

  for (const pull of route.pulls ?? []) {
    let forces = 0
    let boss = false
    const counts = new Map()

    for (const entry of pull.enemies ?? []) {
      const enemy = byIndex.get(entry.enemy)
      if (!enemy) continue

      // Die NPC-Kennung steht schon in den Dungeon-Stammdaten, unter demselben
      // Gegnerindex. Sie hier zu wiederholen kostete bei zweihundert Laeufen
      // mit je dreissig Pulls ein Viertel des Datenpakets fuer nichts. Das
      // Addon schlaegt sie ueber ns.NpcOf() nach; aeltere Pakete, die sie noch
      // mitbringen, funktionieren unveraendert weiter.
      delete entry.npc
      usedNpcs.add(enemy.id)

      const n = (entry.clones ?? []).length
      // Klone duerfen einen eigenen Kraeftewert tragen, siehe mdt-dungeons.mjs.
      for (const clone of entry.clones ?? []) {
        forces += enemy.clonePos?.[clone]?.count ?? enemy.count
      }
      if (enemy.isBoss) boss = true
      counts.set(enemy.id, (counts.get(enemy.id) ?? 0) + n)
    }

    running += forces
    pull.forces = forces
    // Laufender Anteil nach diesem Pull - genau die Spalte, die
    // keystone.guru neben der Pull-Liste zeigt.
    pull.cumulative = running
    if (boss) pull.boss = true
  }

  // Eingereichte Routen bringen ihre Summe mit, weil MDTs Exportstring sie
  // nennt. Rekonstruierte Laeufe tun das nicht - fuer sie ist die Summe
  // genau das, was hier gerade zusammengekommen ist. Ohne sie zeigte die
  // Prozentspalte in der Liste nur ein Fragezeichen.
  if (route.enemyForces == null) route.enemyForces = running
}

function parseArgs(argv) {
  const args = {}
  for (let i = 0; i < argv.length; i += 1) {
    if (!argv[i].startsWith('--')) continue
    // Ein Flag ohne Wert (am Ende oder vor dem naechsten --) ist ein true.
    const next = argv[i + 1]
    args[argv[i].slice(2)] = next === undefined || next.startsWith('--') ? true : argv[++i]
  }
  return args
}

async function main() {
  const args = parseArgs(process.argv.slice(2))
  if (!args.mdt) {
    console.error('Aufruf: node tools/build.mjs --mdt "<Pfad zu MythicDungeonTools>" [--season ...] [--force]')
    return EXIT_ERROR
  }

  console.log('1) MDT-Dungeonkatalog lesen')
  const { mdtVersion, dungeons } = readDungeons(args.mdt)
  const lookup = buildLookup(dungeons)
  console.log(`   MDT ${mdtVersion ?? '?'}, ${dungeons.length} Dungeons`)

  // Die Dungeons der laufenden Season kommen immer mit, auch wenn es zu ihnen
  // noch keine Routen gibt. Sonst waere das Addon ohne Community-Routen leer -
  // ohne Dungeonleiste, ohne eigene Routen aus MDT, ohne Uebersicht.
  const seasons = readSeasons(args.mdt)
  const season = seasons.find((entry) => entry.name === args.season) ?? seasons[0]
  const seasonDungeons = season
    ? season.dungeonIndices
        .map((index) => dungeons.find((entry) => entry.mdtIndex === index))
        .filter(Boolean)
    : []
  console.log(`   Season "${season?.name ?? '?'}": ${seasonDungeons.length} Dungeons`)

  console.log('2) Routen aus data/routes/ laden')
  const routes = readRouteFiles(join(ROOT, 'data', 'routes'))
  console.log(`   ${routes.length} Routen`)

  console.log('3) keystone.guru-Rohdaten konvertieren')
  const cacheDir = join(ROOT, 'data', 'cache')
  let converted = 0
  if (existsSync(cacheDir)) {
    for (const file of readdirSync(cacheDir).filter((f) => f.startsWith('ks-') && f.endsWith('.json'))) {
      if (file === 'ks-dungeons.json') continue
      const raw = JSON.parse(readFileSync(join(cacheDir, file), 'utf8'))
      for (const ksRoute of Array.isArray(raw) ? raw : [raw]) {
        const dungeon = lookup.byChallengeMode.get(ksRoute.dungeonId) ?? null
        if (!dungeon) {
          console.warn(`   ! ${file}: Dungeon ${ksRoute.dungeonId} nicht in MDT`)
          continue
        }
        const { route, report } = convertRoute(ksRoute, dungeon, { interpretation: args.interpretation ?? 'clone' })
        const check = validateRoute(route, report)
        if (!check.ok) {
          console.warn(`   ! ${route.id}: ${check.issues.join('; ')}`)
          if (!args.force) continue
        }
        routes.push(route)
        converted += 1
      }
    }
  }
  console.log(`   ${converted} konvertiert`)

  console.log('3b) Top-Laeufe von Raider.IO')
  //
  // Zwei Sorten, je nachdem, ob der Lauf sich rekonstruieren liess.
  //
  // Raider.IO protokolliert, welche Gegner wann gefallen sind - nicht,
  // welcher der neun gleichnamigen es war und wo die Grenze zwischen zwei
  // Pulls lag. Daraus allein laesst sich keine Route bauen, nur eine erraten,
  // und eine Route, die ungefaehr stimmt, ist fuer ihren Zweck wertlos: wer
  // ihr folgt, pullt an der falschen Stelle.
  //
  // Warcraftlogs weiss beides. Wo tools/wcl-toproutes.mjs den Bericht des
  // Laufs gefunden hat, stehen die Pulls im Eintrag, und der Lauf kommt als
  // vollwertige Route ins Addon - mit Karte, Pull-Liste und Import, wie jede
  // andere. Wo nicht, bleibt es beim Verweis auf keystone.guru.
  const rioDir = join(ROOT, 'data', 'raiderio')
  let rioCount = 0
  let rioSkipped = 0

  if (existsSync(rioDir)) {
    for (const file of readdirSync(rioDir).filter((f) => f.endsWith('.json'))) {
      for (const run of JSON.parse(readFileSync(join(rioDir, file), 'utf8'))) {
        const dungeon = lookup.byChallengeMode.get(run.challengeModeId)
        if (!dungeon) {
          console.warn(`   ! ${run.id}: Dungeon ${run.challengeModeId} nicht in MDT`)
          continue
        }

        // Ein Lauf ausser der Zeit gehoert nicht hierher, und ohne Route
        // und ohne Adresse waere der Eintrag eine Sackgasse.
        if (!run.onTime || (!run.keystoneUrl && !run.pulls)) {
          rioSkipped += 1
          continue
        }

        const tank = (run.roster ?? []).find((member) => member.role === 'tank')
        const minutes = Math.floor((run.clearSeconds ?? 0) / 60)
        const seconds = String((run.clearSeconds ?? 0) - minutes * 60).padStart(2, '0')

        routes.push({
          id: run.id,
          source: 'raider.io',
          // Ohne Pulls kein Weg zur Karte und kein Import - ein solcher
          // Eintrag behauptet gar nicht, eine Route zu sein.
          reference: run.pulls ? undefined : true,
          pulls: run.pulls,
          enemyForces: run.enemyForces,
          // Woher die Pulls stammen. Wer nachsehen will, ob die Route wirklich
          // so gelaufen wurde, findet dort die Wiederholung.
          wclReport: run.wclReport,
          wclFight: run.wclFight,
          title: `+${run.keyLevel} · ${minutes}:${seconds}`,
          author: tank && tank.spec ? `${tank.spec} ${tank.class}` : null,
          url: run.url,
          keystoneUrl: run.keystoneUrl,
          challengeModeId: run.challengeModeId,
          dungeonEnglishName: run.dungeonEnglishName,
          mdtDungeonIdx: run.mdtDungeonIdx,
          keyLevelMin: run.keyLevel,
          keyLevel: run.keyLevel,
          clearSeconds: run.clearSeconds,
          onTime: true,
          rank: run.rank,
          region: run.region,
          bracket: run.bracket,
          tier: run.tier,
          // Ohne Realm und Region: die dienen nur dazu, den Bericht des Laufs
          // auf Warcraftlogs zu finden, und das passiert lange vor dem Paket.
          // Im Addon steht nur, was dort auch angezeigt wird.
          roster: run.roster && run.roster.length > 0
            ? run.roster.map(({ realm, realmRegion, ...rest }) => rest)
            : undefined,
          enemyForcesRequired: run.enemyForcesRequired,
        })
        rioCount += 1
      }
    }
  }

  const rioEcht = routes.filter((r) => r.source === 'raider.io' && r.pulls).length
  console.log(`   ${rioCount} Top-Laeufe: ${rioEcht} mit Route, ${rioCount - rioEcht} als Verweis` +
    (rioSkipped > 0 ? `, ${rioSkipped} uebersprungen` : ''))
  console.log('4) Routen gegen MDT pruefen und anreichern')
  const accepted = []
  const usedDungeons = new Map()

  /** Legt den Eintrag fuer einen Dungeon an, falls es ihn noch nicht gibt. */
  const ensureDungeon = (dungeon) => {
    let meta = usedDungeons.get(dungeon.challengeModeId)
    if (!meta) {
      meta = {
        challengeModeId: dungeon.challengeModeId,
        englishName: dungeon.englishName,
        shortName: dungeon.shortName,
        mdtDungeonIdx: dungeon.mdtIndex,
        totalCount: dungeon.totalCount,
        _npcs: new Set(),
      }
      usedDungeons.set(dungeon.challengeModeId, meta)
    }
    return meta
  }

  for (const dungeon of seasonDungeons) ensureDungeon(dungeon)

  for (const route of routes) {
    const issues = checkRoute(route, lookup)
    const fatal = issues.filter((i) => !i.includes('korrigiert'))
    if (fatal.length > 0) {
      console.warn(`   ! ${route.id}: ${fatal.join('; ')}`)
      if (!args.force) continue
    }

    const dungeon =
      lookup.byChallengeMode.get(route.challengeModeId) ??
      lookup.byName.get((route.dungeonEnglishName ?? '').toLowerCase())

    if (dungeon && !route.reference) {
      enrichRoute(route, dungeon, ensureDungeon(dungeon)._npcs)
    } else if (dungeon) {
      // Der Dungeon muss trotzdem ins Paket, sonst fehlen Kurzname und
      // Gegnertabelle fuer seine Verweise.
      ensureDungeon(dungeon)
    }

    accepted.push(route)
  }
  console.log(`   ${accepted.length} von ${routes.length} akzeptiert`)


  // Alle Gegner des Dungeons ausliefern, nicht nur die in unseren Routen:
  // die eigenen Routen des Nutzers koennen jeden davon enthalten.
  const dungeonMeta = [...usedDungeons.values()].map((meta) => {
    const dungeon = lookup.byChallengeMode.get(meta.challengeModeId)
    const names = {}
    for (const enemy of dungeon.enemies) {
      if (!enemy.name) continue
      // Alles, was die Vorschau beim Ueberfahren braucht - einmal pro NPC,
      // nicht pro Vorkommen in einer Route.
      names[enemy.id] = {
        name: enemy.name,
        displayId: enemy.displayId,
        creatureType: enemy.creatureType,
        level: enemy.level,
        health: enemy.health,
        count: enemy.count,
        isBoss: enemy.isBoss || undefined,
        // Hoechstens acht Zauber - mehr passt ohnehin nicht in die Vorschau
        // und blaeht das Datenpaket nur auf.
        spells: enemy.spells && enemy.spells.length > 0 ? enemy.spells.slice(0, 8) : undefined,
      }
    }
    delete meta._npcs

    // Zuordnung MDT-Gegnerindex -> NPC und Gegnerkraefte. Damit kann das Addon
    // auch Presets bewerten, die nicht von uns stammen - etwa die eigenen
    // Routen des Nutzers, die schon in MDT liegen. Zur Laufzeit ginge das
    // nicht: MDT gibt seine Gegnertabelle nicht nach aussen.
    const enemies = {}
    for (const enemy of dungeon.enemies) {
      if (enemy.id == null) continue
      // pos: Klonschluessel -> { x, y, Unterebene }. Damit zeichnet die
      // Kartenvorschau eine Route, ohne MDTs Karte zu oeffnen. Die Zahlen
      // liegen in MDTs eigenem Kartenraum (840 x 555).
      const pos = {}
      // Abweichende Kraeftewerte einzelner Klone. Nur die Ausnahmen, nicht
      // jeder Klon - in einem Dungeon sind das eine Handvoll Eintraege.
      const counts = {}
      for (const [key, clone] of Object.entries(enemy.clonePos ?? {})) {
        pos[key] = [clone.x, clone.y, clone.sublevel]
        if (typeof clone.count === 'number' && clone.count !== enemy.count) {
          counts[key] = clone.count
        }
      }
      enemies[enemy.index] = {
        npc: enemy.id,
        count: enemy.count,
        clones: enemy.clones,
        pos: Object.keys(pos).length > 0 ? pos : undefined,
        counts: Object.keys(counts).length > 0 ? counts : undefined,
      }
    }

    // Kachelpfade der Dungeonkarte. Die Vorschau zeigt damit MDTs eigene
    // Grafiken - eigene Karten mitzuliefern waere ein Vielfaches der
    // Paketgroesse, und aktuell waeren sie sowieso dieselben.
    const maps = {}
    for (const [sublevel, map] of Object.entries(dungeon.maps ?? {})) {
      maps[sublevel] = { path: map.path, name: map.name ?? undefined }
    }

    return {
      ...meta,
      npcs: names,
      enemies,
      maps: Object.keys(maps).length > 0 ? maps : undefined,
    }
  }).sort((a, b) => a.englishName.localeCompare(b.englishName))

  console.log('5) Lua erzeugen')

  const build = new Date().toISOString().slice(0, 10)
  const { files, hash: dataHash, stats } = buildDataAddon(accepted, {
    build,
    season: args.season ?? null,
    mdtVersion,
    sources: [...new Set(accepted.map((r) => r.source).filter(Boolean))],
    dungeons: dungeonMeta,
  })
  // Der Gesamthash aus Routendaten und Addonquellen. Aendert sich eines von
  // beiden, gibt es ein Release - und sonst nicht.
  const combined = createHash('sha256')
  combined.update(dataHash)
  hashAddonSources(combined)
  const hash = combined.digest('hex').slice(0, 12)

  console.log(`   ${stats.routes} Routen, ${stats.dungeons} Dungeons, Hash ${hash}`)

  // Mit --out ist der Buildstand nicht der des Repositorys, also darf er
  // ihn auch nicht ueberschreiben.
  const target = args.out ? String(args.out) : join(ROOT, 'MDTRouteLibrary_Data')
  writeDataAddon(target, files)

  if (args.out) {
    console.log(`\nGeschrieben nach ${target} (Buildstand unberuehrt).`)
    return EXIT_CHANGED
  }

  const previous = existsSync(STATE_FILE) ? JSON.parse(readFileSync(STATE_FILE, 'utf8')) : {}
  const changed = previous.hash !== hash

  writeFileSync(STATE_FILE, `${JSON.stringify({ hash, build, routes: stats.routes, mdtVersion }, null, 2)}\n`)

  if (!changed && !args.force) {
    console.log(`\nInhalt unveraendert (Hash ${hash}) - kein Release noetig.`)
    return EXIT_UNCHANGED
  }

  console.log(`\nInhalt geaendert: ${previous.hash ?? 'neu'} -> ${hash}`)
  console.log(`Version fuer das Release: ${build}-${hash}`)
  return EXIT_CHANGED
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    process.exit(await main())
  } catch (err) {
    console.error(`Fehler: ${err.stack ?? err.message}`)
    process.exit(EXIT_ERROR)
  }
}
