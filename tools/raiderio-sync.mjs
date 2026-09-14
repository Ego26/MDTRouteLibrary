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
      role: c.spec?.role ?? null,
    }
  })
}

/**
 * Holt die Top-Laeufe eines Dungeons und macht Routen daraus.
 *
 * @param {object} options
 * @returns {Promise<object[]>}
 */
export async function fetchDungeonRuns({ season, dungeonSlug, dungeon, minLevel, wanted, region = 'world' }) {
  const out = []
  const seen = new Set()

  for (let page = 0; page < 5 && out.length < wanted; page += 1) {
    const list = await api('/runs', { season, region, dungeon: dungeonSlug, page })
    const rankings = list.rankings ?? []
    if (rankings.length === 0) break

    for (const entry of rankings) {
      if (out.length >= wanted) break

      const run = entry.run ?? {}
      const id = run.keystone_run_id
      if (!id || seen.has(id)) continue
      if ((run.mythic_level ?? 0) < minLevel) continue
      seen.add(id)

      const details = await api('/run-details', { season, id })
      const logged = details.logged_details ?? {}

      // Der Spieler hat widersprochen - dann endet es hier.
      if (logged.showing_route_authorized !== true) {
        console.log(`   - ${id}: Route nicht freigegeben, übersprungen`)
        continue
      }
      if (!Array.isArray(logged.enemies) || logged.enemies.length === 0) {
        console.log(`   - ${id}: keine Gegnerdaten`)
        continue
      }

      const { pulls, unknown } = mapToMdt(groupIntoPulls(onlyPlaced(logged.enemies, dungeon)), dungeon)
      if (pulls.length === 0) {
        console.log(`   - ${id}: keine Gegner zuzuordnen`)
        continue
      }
      if (unknown.length > 0) {
        console.log(`     (${unknown.length} unbekannte Namen: ${unknown.slice(0, 3).join(', ')})`)
      }

      out.push({
        id: `rio-${id}`,
        source: 'raider.io',
        // Bedingung ihrer Nutzungsbedingungen, und das Mindeste: jede Route
        // zeigt, wo sie herkommt.
        url: `https://raider.io/mythic-plus-runs/${season}/${id}-${details.mythic_level}-${details.dungeon.slug}`,
        // Aus unseren eigenen Daten, nicht aus der Antwort: Raider.IO nennt
        // die Kennung anders, und MDTs Katalog ist hier ohnehin massgeblich.
        challengeModeId: dungeon.challengeModeId,
        dungeonEnglishName: dungeon.englishName,
        mdtDungeonIdx: dungeon.mdtIndex,
        // Der Weltrang steht in der Rangliste, nicht in den Laufdetails.
        rank: typeof entry.rank === 'number' ? entry.rank : undefined,
        keyLevel: details.mythic_level,
        clearSeconds: Math.round((details.clear_time_ms ?? 0) / 1000),
        onTime: (details.num_chests ?? 0) > 0,
        completedAt: details.completed_at ?? null,
        roster: roster(details),
        enemyForcesRequired: logged.total_enemy_forces ?? dungeon.totalCount,
        pulls,
      })

      console.log(`   + ${id} +${details.mythic_level} ${Math.round(details.clear_time_ms / 1000)}s, ${pulls.length} Pulls`)
    }
  }

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

  const minLevel = Number(args['min-level'] ?? 15)
  const wanted = Number(args.runs ?? 20)
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

  console.log(`Season ${season}, ab +${minLevel}, bis zu ${wanted} Läufe je Dungeon`)
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
