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

import { readdirSync, readFileSync, writeFileSync, existsSync } from 'node:fs'
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
      for (const clone of entry.clones ?? []) {
        if (clone < 1 || clone > enemy.clones) issues.push(`Klon ${entry.enemy}/${clone} unbekannt`)
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
      entry.npc = enemy.id
      usedNpcs.add(enemy.id)

      const n = (entry.clones ?? []).length
      forces += enemy.count * n
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

    if (dungeon) {
      enrichRoute(route, dungeon, ensureDungeon(dungeon)._npcs)
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
      enemies[enemy.index] = { npc: enemy.id, count: enemy.count, clones: enemy.clones }
    }

    return { ...meta, npcs: names, enemies }
  }).sort((a, b) => a.englishName.localeCompare(b.englishName))

  console.log('5) Lua erzeugen')
  const build = new Date().toISOString().slice(0, 10)
  const { files, hash, stats } = buildDataAddon(accepted, {
    build,
    season: args.season ?? null,
    mdtVersion,
    sources: [...new Set(accepted.map((r) => r.source).filter(Boolean))],
    dungeons: dungeonMeta,
  })
  console.log(`   ${stats.routes} Routen, ${stats.dungeons} Dungeons, Hash ${hash}`)

  const previous = existsSync(STATE_FILE) ? JSON.parse(readFileSync(STATE_FILE, 'utf8')) : {}
  const changed = previous.hash !== hash

  writeDataAddon(join(ROOT, 'MDTRouteLibrary_Data'), files)
  writeFileSync(STATE_FILE, `${JSON.stringify({ hash, build, routes: stats.routes, mdtVersion }, null, 2)}\n`)

  if (!changed && !args.force) {
    console.log(`\nInhalt unveraendert (Hash ${hash}) - kein Release noetig.`)
    return EXIT_UNCHANGED
  }

  console.log(`\nInhalt geaendert: ${previous.hash ?? 'neu'} -> ${hash}`)
  console.log(`Version fuer das Release: ${build}-${hash}`)
  return EXIT_CHANGED
}

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    process.exit(await main())
  } catch (err) {
    console.error(`Fehler: ${err.stack ?? err.message}`)
    process.exit(EXIT_ERROR)
  }
}
