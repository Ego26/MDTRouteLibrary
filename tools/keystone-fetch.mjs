// Holt Routen von der keystone.guru-API.
//
// Die API verlangt einen Schluessel: ohne Authentifizierung antwortet jeder
// Endpunkt mit 401. Der Schluessel kommt aus der Umgebungsvariablen
// KEYSTONE_API_KEY und darf niemals im Repository landen.
//
// Rechtlicher Hinweis: ein Schluessel erlaubt das Lesen, nicht automatisch das
// Weiterverteilen der Routen in einem Addon. Vor dem ersten Release muss die
// Erlaubnis dafuer schriftlich vorliegen. Siehe docs/02-Datenquellen.md.
//
// Aufruf:
//   KEYSTONE_API_KEY=... node tools/keystone-fetch.mjs --dungeon altar-of-fangs --count 5

import { writeFileSync, mkdirSync } from 'node:fs'
import { join } from 'node:path'
import { pathToFileURL } from 'node:url'

const BASE = 'https://keystone.guru/api/v1'

/**
 * Ruft einen Endpunkt auf.
 *
 * @param {string} path Pfad ab /api/v1
 * @param {string} apiKey
 * @returns {Promise<object>}
 */
async function call(path, apiKey) {
  const res = await fetch(`${BASE}${path}`, {
    headers: {
      Accept: 'application/json',
      Authorization: `Bearer ${apiKey}`,
      'User-Agent': 'MDTRouteLibrary (+https://github.com/Ego26/MDTRouteLibrary)',
    },
  })

  if (res.status === 401) {
    throw new Error('401 Unauthenticated - Schluessel fehlt oder ist ungueltig')
  }
  if (!res.ok) {
    throw new Error(`${res.status} ${res.statusText} bei ${path}`)
  }
  return res.json()
}

/**
 * Beliebte Routen eines Dungeons.
 *
 * @param {string} dungeonSlug z. B. "altar-of-fangs"
 * @param {object} [options]
 * @returns {Promise<object[]>} Zusammenfassungen (DungeonRouteSummary)
 */
export async function fetchPopular(dungeonSlug, options = {}) {
  const { apiKey = process.env.KEYSTONE_API_KEY, gameVersion = 'retail', count = 10, offset = 0 } = options
  if (!apiKey) throw new Error('KEYSTONE_API_KEY ist nicht gesetzt')

  const query = `?count=${count}&offset=${offset}`
  const data = await call(`/route/${gameVersion}/${dungeonSlug}/popular${query}`, apiKey)
  return data.data ?? []
}

/**
 * Vollstaendige Route inklusive Pulls.
 *
 * @param {string} publicKey
 * @param {object} [options]
 * @returns {Promise<object>} DungeonRoute
 */
export async function fetchRoute(publicKey, options = {}) {
  const { apiKey = process.env.KEYSTONE_API_KEY } = options
  if (!apiKey) throw new Error('KEYSTONE_API_KEY ist nicht gesetzt')

  const data = await call(`/route/${publicKey}`, apiKey)
  return data.data ?? data
}

/**
 * Dungeonliste der API.
 *
 * @param {object} [options]
 * @returns {Promise<object[]>}
 */
export async function fetchDungeons(options = {}) {
  const { apiKey = process.env.KEYSTONE_API_KEY } = options
  if (!apiKey) throw new Error('KEYSTONE_API_KEY ist nicht gesetzt')

  const data = await call('/dungeon', apiKey)
  return data.data ?? []
}

// ---------------------------------------------------------------- CLI

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

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  const args = parseArgs(process.argv.slice(2))
  const outDir = args.out ?? 'data/cache'

  try {
    if (args.dungeons) {
      const dungeons = await fetchDungeons()
      console.log(`${dungeons.length} Dungeons`)
      mkdirSync(outDir, { recursive: true })
      writeFileSync(join(outDir, 'ks-dungeons.json'), JSON.stringify(dungeons, null, 2))
      process.exit(0)
    }

    if (!args.dungeon) {
      console.error('Aufruf: node tools/keystone-fetch.mjs --dungeon <slug> [--count 10] [--out ordner]')
      console.error('        node tools/keystone-fetch.mjs --dungeons')
      process.exit(1)
    }

    const summaries = await fetchPopular(args.dungeon, { count: Number(args.count ?? 10) })
    console.log(`${summaries.length} Routen fuer ${args.dungeon}`)

    mkdirSync(outDir, { recursive: true })
    const routes = []
    for (const summary of summaries) {
      const route = await fetchRoute(summary.publicKey)
      routes.push(route)
      console.log(`  ${summary.publicKey}  "${summary.title}"  ${summary.pullCount} Pulls`)
    }

    const file = join(outDir, `ks-${args.dungeon}.json`)
    writeFileSync(file, JSON.stringify(routes, null, 2))
    console.log(`geschrieben: ${file}`)
  } catch (err) {
    console.error(`Fehler: ${err.message}`)
    process.exit(1)
  }
}
