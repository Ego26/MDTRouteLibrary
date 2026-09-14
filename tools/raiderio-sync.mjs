// Holt Top-Laeufe von Raider.IO und macht Routen daraus.
//
// Warum das erlaubt ist, und unter welchen Bedingungen: die API-Beschreibung
// (https://raider.io/swagger.json, info.description) sagt es selbst.
//
//   "This API is provided for community and personal use. You may not use it
//    to build competing services, resell data, or engage in any activity that
//    harms the Raider.IO platform or its users. Automated scraping beyond the
//    published endpoints is prohibited."
//
//   "Public-facing applications that use data from this API must include a
//    link back to raider.io."
//
// Daraus folgen vier Regeln, die dieses Werkzeug einhaelt:
//
//   1. Nur die veroeffentlichten Endpunkte - mythic-plus/runs und
//      mythic-plus/run-details. Nichts an der API vorbei.
//   2. Jede uebernommene Route traegt die Adresse ihres Laufs auf raider.io.
//      Das Addon zeigt sie; der Rueckverlink ist Bedingung, nicht Hoeflichkeit.
//   3. Retry-After wird beachtet, nicht in festem Takt nachgehakt.
//   4. Laeufe mit showing_route_authorized != true bleiben draussen. Die API
//      liefert ihre Gegnerliste trotzdem mit - sie zu zeigen waere gegen den
//      ausdruecklichen Willen des Spielers, und damit gegen "harms its users".
//
// Der Schluessel kommt aus RAIDERIO_API_KEY. Ohne ihn laeuft es auch, nur
// langsamer: unangemeldete Anfragen sind staerker begrenzt.
//
// Aufruf:
//   node tools/raiderio-sync.mjs --mdt <MDT-Pfad> [--season season-mn-2] \
//        [--dungeon temple-of-sethraliss] [--min-level 15] [--runs 20] --out data/raiderio
//
// Ohne --season sucht das Werkzeug die laufende selbst, siehe currentSeason().

import { mkdirSync, writeFileSync } from 'node:fs'
import { join } from 'node:path'
import { pathToFileURL } from 'node:url'
import { readDungeons, readSeasons } from './mdt-dungeons.mjs'

const BASE = 'https://raider.io/api/v1/mythic-plus'

/** Ohne Kennung ruft niemand gern etwas ab. */
const USER_AGENT = 'MDTRouteLibrary (https://github.com/Ego26/MDTRouteLibrary)'

/**
 * Ab dieser Luecke zwischen zwei Toden faengt ein neuer Pull an.
 *
 * Acht Sekunden treffen es gut: innerhalb eines Pulls sterben die Gegner in
 * schneller Folge, zwischen zwei Pulls liegt der Weg dorthin. Zu klein
 * zerfaellt ein Pull in Einzelteile, zu gross verschmelzen zwei zu einem.
 */
const PULL_GAP_MS = 8000

/**
 * Ruft die API und beachtet dabei die Ratenbegrenzung.
 *
 * @param {string} path
 * @param {Record<string,string|number>} params
 * @returns {Promise<any>}
 */
async function api(path, params) {
  const url = new URL(BASE + path)
  for (const [key, value] of Object.entries(params)) {
    if (value !== undefined && value !== null) url.searchParams.set(key, String(value))
  }
  if (process.env.RAIDERIO_API_KEY) {
    url.searchParams.set('access_key', process.env.RAIDERIO_API_KEY)
  }

  for (let attempt = 1; attempt <= 4; attempt += 1) {
    const response = await fetch(url, { headers: { 'User-Agent': USER_AGENT } })

    if (response.status === 429) {
      // Warten, was sie sagen - nicht, was uns passt.
      const wait = Number(response.headers.get('retry-after')) || attempt * 5
      console.warn(`   Ratenbegrenzung, warte ${wait}s`)
      await new Promise((done) => setTimeout(done, wait * 1000))
      continue
    }

    if (!response.ok) throw new Error(`${response.status} ${response.statusText} für ${path}`)
    return response.json()
  }

  throw new Error(`Ratenbegrenzung bei ${path} auch nach vier Versuchen`)
}

/**
 * Findet die laufende Season.
 *
 * "season=current" nimmt die API nicht an (500), und ein eingetragenes
 * "season-mn-2" waere beim naechsten Wechsel still falsch: die Abfrage liefe
 * weiter, nur eben mit den Laeufen der vorigen Season.
 *
 * static-data verlangt eine expansion_id und kennt keine in der Zukunft, also
 * tasten wir uns von der bekannten aufwaerts, bis eine nicht mehr existiert.
 * Im Normalfall sind das zwei Anfragen.
 *
 * Nebensaisons wie "season-mn-1-break-the-meta" laufen parallel zur
 * eigentlichen und haetten dieselbe Pruefung bestanden - deshalb nur Slugs der
 * Form "season-<kuerzel>-<nummer>".
 *
 * @param {number} known Zuletzt bekannte Erweiterung
 * @returns {Promise<string|null>}
 */
export async function currentSeason(known = 11) {
  const now = Date.now()
  let best = null

  for (let expansion = known; expansion < known + 10; expansion += 1) {
    let data
    try {
      data = await api('/static-data', { expansion_id: expansion })
    } catch {
      break // Diese Erweiterung gibt es noch nicht - damit sind wir durch.
    }

    for (const season of data.seasons ?? []) {
      if (!/^season-[a-z]+-\d+$/.test(season.slug ?? '')) continue

      const starts = Date.parse(season.starts?.us ?? '')
      const ends = Date.parse(season.ends?.us ?? '')
      if (!Number.isFinite(starts) || starts > now) continue
      if (Number.isFinite(ends) && ends <= now) continue

      if (!best || starts > best.starts) best = { slug: season.slug, starts }
    }
  }

  return best?.slug ?? null
}

/**
 * Sondert aus, was nicht auf der Karte steht.
 *
 * Von 157 Todesmeldungen eines Laufs haben typischerweise 89 keinen
 * Kraeftewert. Das sind die Beschworenen: 21 "Faithless Tormentor", 14
 * "Swarming Krolusk", 13 "Snake". Sie entstehen erst im Kampf, haben in MDT
 * keinen Klon und gehoeren in keine Route - wer sie mitzaehlt, sucht
 * Standorte fuer Gegner, die keine haben, und verbraucht dabei die Klone der
 * echten.
 *
 * Der Kraeftewert allein reicht als Merkmal nicht: Bosse stehen ebenfalls auf
 * null und gehoeren sehr wohl dazu.
 *
 * @param {object[]} enemies
 * @param {object} dungeon
 * @returns {object[]}
 */
function onlyPlaced(enemies, dungeon) {
  const bosses = new Set(dungeon.enemies.filter((e) => e.isBoss && e.name).map((e) => e.name))
  return enemies.filter((enemy) => (enemy.enemy_forces_value ?? 0) > 0 || bosses.has(enemy.name))
}

/**
 * Gruppiert die Todesmeldungen eines Laufs zu Pulls.
 *
 * Die API liefert je Gegner Name, Kraeftewert und Zeitpunkt - keine
 * Koordinaten und keine Klonnummern. Mehr als "was gehoerte zusammen" laesst
 * sich daraus nicht gewinnen, und genau das rechnen wir hier aus.
 *
 * @param {object[]} enemies
 * @returns {Array<{ at: number, enemies: Array<{ name: string, count: number }> }>}
 */
export function groupIntoPulls(enemies) {
  const sorted = [...enemies]
    .filter((e) => typeof e.approximate_relative_ended_at === 'number')
    .sort((a, b) => a.approximate_relative_ended_at - b.approximate_relative_ended_at)

  const pulls = []
  let current = null
  let lastAt = null

  for (const enemy of sorted) {
    const at = enemy.approximate_relative_ended_at

    if (!current || at - lastAt > PULL_GAP_MS) {
      current = { at, counts: new Map() }
      pulls.push(current)
    }
    lastAt = at
    current.counts.set(enemy.name, (current.counts.get(enemy.name) ?? 0) + 1)
  }

  return pulls.map((pull) => ({
    at: Math.round(pull.at / 1000),
    enemies: [...pull.counts.entries()]
      .map(([name, count]) => ({ name, count }))
      .sort((a, b) => b.count - a.count || a.name.localeCompare(b.name)),
  }))
}

/**
 * Bildet die Gegnernamen eines Laufs auf MDTs Gegnertabelle ab.
 *
 * @param {object[]} pulls
 * @param {object} dungeon Dungeon aus mdt-dungeons.mjs
 * @returns {{ pulls: object[], unknown: string[] }}
 */
export function mapToMdt(pulls, dungeon) {
  // Ein Name kann mehrere Eintraege haben (MDT trennt Gegner nach Position).
  // Fuer die Ansicht genuegt der erste; welcher Klon gemeint war, steht in den
  // Daten ohnehin nicht.
  const byName = new Map()
  for (const enemy of dungeon.enemies) {
    if (enemy.name && !byName.has(enemy.name)) byName.set(enemy.name, enemy)
  }

  const unknown = new Set()
  const mapped = pulls.map((pull) => ({
    at: pull.at,
    enemies: pull.enemies.map((entry) => {
      const enemy = byName.get(entry.name)
      if (!enemy) {
        unknown.add(entry.name)
        return null
      }
      return { enemy: enemy.index, npc: enemy.id, count: entry.count }
    }).filter(Boolean),
  })).filter((pull) => pull.enemies.length > 0)

  return { pulls: mapped, unknown: [...unknown] }
}

/** Kurzform der Gruppe: Spezialisierung und Klasse je Mitglied. */
function roster(run) {
  return (run.roster ?? []).map((member) => {
    const c = member.character ?? {}
    return {
      class: c.class?.name ?? null,
      spec: c.spec?.name ?? null,
      // Zwei Stellen, weil zwei Antwortformen: die Rangliste legt die Rolle
      // neben den Charakter, die Laufdetails in die Spezialisierung. Wer nur
      // die zweite liest, haelt in der Rangliste jede Gruppe fuer tanklos.
      role: member.role ?? c.spec?.role ?? null,
    }
  })
}

/**
 * Holt die Top-Laeufe eines Dungeons und macht Routen daraus.
 *
 * @param {object} options
 * @returns {Promise<object[]>}
 */
/** Tank-Spezialisierung einer Gruppe, als Schluessel. */
function tankKey(members) {
  const tank = members.find((member) => member.role === 'tank')
  return tank && tank.spec ? tank.spec + ' ' + tank.class : '?'
}

/**
 * Blaettert die Rangliste eines Dungeons und merkt sich, was schon geholt ist.
 *
 * Die Rangliste ist nach Wertung geordnet, und die Wertung haengt zuerst an
 * der Schluesselstufe. Gleiche Stufen liegen deshalb als zusammenhaengender
 * Block beieinander, und die Stufe faellt mit dem Rang monoton. Genau das
 * macht die Binaersuche weiter unten moeglich.
 *
 * @param {object} options
 * @returns {{ page: (n:number)=>Promise<object[]|null>, count: ()=>number }}
 */
function rankingReader({ season, region, dungeonSlug }) {
  const cache = new Map()
  let calls = 0

  return {
    async page(n) {
      if (cache.has(n)) return cache.get(n)

      let rankings = null
      try {
        calls += 1
        const list = await api('/runs', { season, region, dungeon: dungeonSlug, page: n })
        rankings = list.rankings ?? []
      } catch {
        // Jenseits des Seitenlimits antwortet die API mit 400. Ohne
        // Zugangsschluessel ist bei Seite 100 Schluss, mit einem geht es
        // weiter - wie weit, sagt sie nicht, also tasten wir uns heran.
        rankings = null
      }

      cache.set(n, rankings)
      return rankings
    },
    count() {
      return calls
    },
  }
}

/** Hoechste Stufe auf einer Seite, oder null wenn es die Seite nicht gibt. */
async function topLevelOf(reader, page) {
  const rankings = await reader.page(page)
  if (!rankings || rankings.length === 0) return null
  return Math.max(...rankings.map((entry) => entry.run?.mythic_level ?? 0))
}

/**
 * Sucht die erste Seite, auf der eine Schluesselstufe auftaucht.
 *
 * Der Block einer Stufe kann sehr weit hinten liegen - die +18er eines
 * Dungeons fangen bei Rang 1050 an, die +2er stehen bei Rang 1,5 Millionen.
 * Sich dorthin durchzublaettern waere sinnlos; weil die Stufe mit dem Rang
 * monoton faellt, genuegt eine Binaersuche mit rund einem Dutzend Abfragen.
 *
 * @param {object} reader
 * @param {number} level
 * @param {number} maxPage
 * @returns {Promise<number|null>}
 */
async function findLevelStart(reader, level, maxPage) {
  // Erst eine Obergrenze finden: verdoppeln, bis die Seite unter die gesuchte
  // Stufe faellt oder es sie nicht mehr gibt.
  let hi = 1
  while (hi <= maxPage) {
    const top = await topLevelOf(reader, hi)
    if (top === null) break
    if (top <= level) break
    hi *= 2
  }
  hi = Math.min(hi, maxPage)

  let lo = 0
  let found = null

  while (lo <= hi) {
    const mid = Math.floor((lo + hi) / 2)
    const top = await topLevelOf(reader, mid)

    if (top === null) {
      // Seite jenseits des Limits - nach vorn ausweichen.
      hi = mid - 1
      continue
    }

    if (top <= level) {
      found = mid
      hi = mid - 1
    } else {
      lo = mid + 1
    }
  }

  return found
}

/**
 * In welchen Bereich faellt eine Schluesselstufe?
 *
 * Zwei, nicht zwoelf. Gemessen an Altar of Fangs aendert eine Stufe Abstand
 * an der Route nichts - +18 bis +21 liegen bei 30 Pulls und 3,2 Mobs je Pull,
 * und die Streuung innerhalb einer Stufe ist groesser als die zwischen
 * zweien. Der Abstand zwischen oben und unten dagegen ist deutlich: ein
 * Weltrang-1-Lauf faengt mit vier Mobs an, ein +12er mit elf, und ist dabei
 * sieben Minuten schneller. Wer unten spielt, laeuft eine andere Route -
 * wer zwei Stufen darueber spielt, nicht.
 *
 * @param {number} level
 * @param {number} highest
 * @param {number} lowTop Obergrenze des unteren Bereichs
 * @returns {string|null}
 */
function bracketOf(level, highest, lowTop) {
  if (level > lowTop) return level >= highest - 3 ? 'high' : null
  return 'low'
}

/**
 * Sammelt Kandidaten: die Spitze der Rangliste und den Anfang jeder Stufe,
 * die in einen der beiden Bereiche faellt.
 *
 * @param {object} options
 * @returns {Promise<{ candidates: object[], reader: object, highest: number }>}
 */
async function collectCandidates({ season, region, dungeonSlug, minLevel, maxPage, topPages, lowTop }) {
  const reader = rankingReader({ season, region, dungeonSlug })
  const byId = new Map()

  const add = (entry) => {
    const run = entry.run ?? {}
    const id = run.keystone_run_id
    if (!id || byId.has(id)) return
    if ((run.mythic_level ?? 0) < minLevel) return

    byId.set(id, {
      id,
      rank: typeof entry.rank === 'number' ? entry.rank : undefined,
      level: run.mythic_level,
      // Schon in der Rangliste enthalten - die Auswahl kostet deshalb keine
      // einzige zusaetzliche Abfrage.
      roster: roster(run),
    })
  }

  // Die Spitze der Rangliste, und zwar grosszuegig. Nicht nur wegen der
  // schnellsten Zeiten: die seltenen Tank-Spezialisierungen tauchen erst
  // hier auf. In Altar of Fangs steht der erste Waechter-Druide auf Rang 28,
  // der erste Schutz-Krieger auf 107.
  for (let page = 0; page < topPages; page += 1) {
    const rankings = await reader.page(page)
    if (!rankings || rankings.length === 0) break
    for (const entry of rankings) add(entry)
  }

  const highest = await topLevelOf(reader, 0)
  if (highest === null) return { candidates: [], reader, highest: 0 }

  // Stufe fuer Stufe an ihren Anfang springen. Ohne Zugangsschluessel endet
  // die API bei Seite 100; dann liefert findLevelStart null und der untere
  // Bereich bleibt eben leer, statt den Lauf scheitern zu lassen.
  for (let level = highest - 1; level >= minLevel; level -= 1) {
    if (!bracketOf(level, highest, lowTop)) continue

    const startPage = await findLevelStart(reader, level, maxPage)
    if (startPage === null) continue

    let seenHere = 0
    for (let page = startPage; page < startPage + 4; page += 1) {
      const rankings = await reader.page(page)
      if (!rankings || rankings.length === 0) break

      for (const entry of rankings) {
        if ((entry.run?.mythic_level ?? 0) !== level) continue
        add(entry)
        seenHere += 1
      }
      if (seenHere >= 60) break
    }
  }

  const candidates = [...byId.values()].sort((a, b) => (a.rank ?? 0) - (b.rank ?? 0))
  return { candidates, reader, highest }
}
/**
 * Holt die Laeufe eines Dungeons und macht Routen daraus.
 *
 * Die Auswahl folgt der Frage, die jemand tatsaechlich stellt: "Welche Route
 * laeuft eine Gruppe wie meine auf einem Schluessel wie meinem?" Also eine
 * Quote je Kombination aus Bereich und Tank-Spezialisierung, dazu die
 * schnellsten Laeufe ueberhaupt.
 *
 * Getrennte Quoten fuer Bereich und Tank waeren zu wenig: sie koennten von
 * derselben Handvoll Laeufe erfuellt werden und liessen den Waechter-Druiden
 * auf +12 trotzdem aus.
 *
 * Eine Detailabfrage faellt erst an, wenn ein Lauf eine Quote fuellt - die
 * Auswahl selbst laeuft auf den Ranglistenseiten, die Gruppe und Stufe schon
 * mitbringen.
 *
 * @param {object} options
 * @returns {Promise<object[]>}
 */
export async function fetchDungeonRuns({
  season,
  dungeonSlug,
  dungeon,
  minLevel,
  wanted,
  perCell = 2,
  lowTop = 14,
  maxRuns = 28,
  topPages = 15,
  maxPage = 4096,
  maxDetails = 150,
  region = 'world',
}) {
  const { candidates, reader, highest } = await collectCandidates({
    season,
    region,
    dungeonSlug,
    minLevel,
    maxPage,
    topPages,
    lowTop,
  })

  if (candidates.length === 0) return []

  const levelsSeen = candidates.map((c) => c.level)
  console.log(
    '   ' + candidates.length + ' Kandidaten bis Rang ' +
      (candidates[candidates.length - 1].rank ?? 0) +
      ', Stufen +' + Math.min(...levelsSeen) + ' bis +' + Math.max(...levelsSeen) +
      ' (' + reader.count() + ' Ranglistenabfragen)'
  )

  // Die Quote zaehlt erst, wenn ein Lauf wirklich uebernommen wurde. Faellt
  // einer wegen fehlender Freigabe aus, rueckt der naechste nach, statt eine
  // Luecke zu hinterlassen.
  const out = []
  const cells = new Map()
  let calls = 0

  for (const candidate of candidates) {
    if (calls >= maxDetails || out.length >= maxRuns) break

    const bracket = bracketOf(candidate.level, highest, lowTop)
    const cell = bracket ? bracket + ':' + tankKey(candidate.roster) : null
    const used = cell ? cells.get(cell) ?? 0 : Infinity

    if (out.length >= wanted && used >= perCell) continue

    calls += 1
    const details = await api('/run-details', { season, id: candidate.id })
    const logged = details.logged_details ?? {}

    // Der Spieler hat widersprochen - dann endet es hier.
    if (logged.showing_route_authorized !== true) continue
    if (!Array.isArray(logged.enemies) || logged.enemies.length === 0) continue

    const { pulls, unknown } = mapToMdt(groupIntoPulls(onlyPlaced(logged.enemies, dungeon)), dungeon)
    if (pulls.length === 0) continue
    if (unknown.length > 0) {
      console.log('     (' + unknown.length + ' unbekannte Namen: ' + unknown.slice(0, 3).join(', ') + ')')
    }

    out.push({
      id: 'rio-' + candidate.id,
      source: 'raider.io',
      // Bedingung ihrer Nutzungsbedingungen, und das Mindeste: jede Route
      // zeigt, wo sie herkommt.
      url:
        'https://raider.io/mythic-plus-runs/' +
        season + '/' + candidate.id + '-' + details.mythic_level + '-' + details.dungeon.slug,
      // Aus unseren eigenen Daten, nicht aus der Antwort: Raider.IO nennt die
      // Kennung anders, und MDTs Katalog ist hier ohnehin massgeblich.
      challengeModeId: dungeon.challengeModeId,
      dungeonEnglishName: dungeon.englishName,
      mdtDungeonIdx: dungeon.mdtIndex,
      // Der Weltrang steht in der Rangliste, nicht in den Laufdetails.
      rank: candidate.rank,
      keyLevel: details.mythic_level,
      clearSeconds: Math.round((details.clear_time_ms ?? 0) / 1000),
      onTime: (details.num_chests ?? 0) > 0,
      roster: roster(details),
      enemyForcesRequired: logged.total_enemy_forces ?? dungeon.totalCount,
      pulls,
    })

    if (cell) cells.set(cell, (cells.get(cell) ?? 0) + 1)
  }

  const levels = new Map()
  for (const run of out) levels.set(run.keyLevel, (levels.get(run.keyLevel) ?? 0) + 1)

  console.log('   ' + out.length + ' Laeufe aus ' + calls + ' Detailabfragen')
  console.log(
    '     Stufen: ' +
      [...levels.entries()]
        .sort((a, b) => b[0] - a[0])
        .map(([level, n]) => n + 'x +' + level)
        .join(', ')
  )
  console.log(
    '     Felder: ' +
      [...cells.entries()]
        .sort()
        .map(([cell, n]) => cell + ' (' + n + ')')
        .join(', ')
  )

  return out
}

// ---------------------------------------------------------------- CLI

function parseArgs(argv) {
  const args = {}
  for (let i = 0; i < argv.length; i += 1) {
    if (!argv[i].startsWith('--')) continue
    const next = argv[i + 1]
    args[argv[i].slice(2)] = next === undefined || next.startsWith('--') ? true : argv[++i]
  }
  return args
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const args = parseArgs(process.argv.slice(2))
  if (!args.mdt) {
    console.error('Aufruf: node tools/raiderio-sync.mjs --mdt <MDT-Pfad> [--season season-mn-2] [--dungeon slug] [--min-level 15] [--runs 20] [--out data/raiderio]')
    process.exit(1)
  }

  // Ohne Angabe die laufende Season - so haelt der taegliche Lauf auch ueber
  // einen Seasonwechsel hinweg.
  const season = typeof args.season === 'string' ? args.season : await currentSeason()
  if (!season) {
    console.error('Keine laufende Season gefunden.')
    process.exit(1)
  }

  const minLevel = Number(args['min-level'] ?? 10)
  const wanted = Number(args.runs ?? 10)
  const perCell = Number(args['per-cell'] ?? 2)
  const lowTop = Number(args['low-top'] ?? 14)
  const maxRuns = Number(args['max-runs'] ?? 28)
  // Die Weltrangliste ist die richtige Quelle. --region dient dem Pruefen:
  // kleinere Regionen haben kuerzere Listen, dort liegen niedrige Stufen
  // auch ohne Zugangsschluessel in Reichweite.
  const region = typeof args.region === 'string' ? args.region : 'world'
  const outDir = args.out ?? 'data/raiderio'

  const { dungeons } = readDungeons(args.mdt)

  // Welche Dungeons? Entweder der genannte, oder alle der Season.
  const seasons = readSeasons(args.mdt)
  const chosen = seasons[0]
  const seasonDungeons = chosen
    ? chosen.dungeonIndices.map((i) => dungeons.find((d) => d.mdtIndex === i)).filter(Boolean)
    : []

  const slug = (name) => name.toLowerCase().replace(/['’]/g, '').replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')

  const targets = args.dungeon
    ? seasonDungeons.filter((d) => slug(d.englishName) === args.dungeon).map((d) => ({ dungeon: d, slug: args.dungeon }))
    : seasonDungeons.map((d) => ({ dungeon: d, slug: slug(d.englishName) }))

  if (targets.length === 0) {
    console.error('Kein passender Dungeon in der Season gefunden.')
    process.exit(1)
  }

  console.log(`Season ${season}: je Dungeon die besten ${wanted}, dazu ${perCell} je Tank-Spezialisierung` +
    ` in jedem der beiden Bereiche (High Keys, +${minLevel} bis +${lowTop}), höchstens ${maxRuns}`)
  if (!process.env.RAIDERIO_API_KEY) {
    console.log('Ohne RAIDERIO_API_KEY - unangemeldet, also stärker begrenzt.')
  }

  mkdirSync(outDir, { recursive: true })
  let total = 0

  for (const target of targets) {
    console.log(`\n${target.dungeon.englishName} (${target.slug})`)
    try {
      const runs = await fetchDungeonRuns({
        season,
        dungeonSlug: target.slug,
        dungeon: target.dungeon,
        minLevel,
        wanted,
        perCell,
        lowTop,
        maxRuns,
        region,
      })

      if (runs.length > 0) {
        const file = join(outDir, `${target.slug}.json`)
        writeFileSync(file, `${JSON.stringify(runs, null, 2)}\n`)
        console.log(`   ${runs.length} Läufe -> ${file}`)
        total += runs.length
      }
    } catch (err) {
      console.warn(`   ! ${err.message}`)
    }
  }

  console.log(`\n${total} Läufe insgesamt.`)
}
