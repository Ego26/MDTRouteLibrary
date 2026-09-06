// Holt die beliebtesten Routen aller Dungeons der aktuellen Season von
// keystone.guru und legt die Rohantworten in data/cache/ ab.
//
// Bewusst getrennt vom Bauen: so laesst sich der Build jederzeit ohne Netz und
// ohne API-Schluessel wiederholen, und die Rohdaten bleiben zum Nachsehen da.
//
// WICHTIG: Ein API-Schluessel erlaubt das Lesen. Ob die Routen im Addon
// weiterverteilt werden duerfen, ist eine zweite, getrennte Frage - siehe
// docs/02-Datenquellen.md. Ohne diese Freigabe darf dieses Skript nicht in ein
// Release einfliessen.
//
// Aufruf:
//   KEYSTONE_API_KEY=... node tools/keystone-sync.mjs --out data/cache [--count 5]

import { writeFileSync, mkdirSync } from 'node:fs'
import { join } from 'node:path'
import { pathToFileURL } from 'node:url'
import { fetchDungeons, fetchPopular, fetchRoute } from './keystone-fetch.mjs'

/** Kleine Pause zwischen Anfragen - wir sind Gast auf fremden Servern. */
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms))

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

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const args = parseArgs(process.argv.slice(2))
  const outDir = args.out ?? 'data/cache'
  const perDungeon = Number(args.count ?? 5)
  const gameVersion = args.gameVersion ?? 'retail'

  if (!process.env.KEYSTONE_API_KEY) {
    console.error('KEYSTONE_API_KEY ist nicht gesetzt - übersprungen.')
    process.exit(0)
  }

  mkdirSync(outDir, { recursive: true })

  const dungeons = await fetchDungeons()
  // Nur Dungeons der laufenden Season: alles andere waere unnoetige Last.
  const active = dungeons.filter((d) => !args.expansion || d.expansion === args.expansion)
  console.log(`${active.length} Dungeons, je bis zu ${perDungeon} Routen`)

  let total = 0
  for (const dungeon of active) {
    const slug = dungeon.slug
    if (!slug) continue

    try {
      const summaries = await fetchPopular(slug, { gameVersion, count: perDungeon })
      const routes = []
      for (const summary of summaries) {
        routes.push(await fetchRoute(summary.publicKey))
        await sleep(250)
      }

      if (routes.length > 0) {
        writeFileSync(join(outDir, `ks-${slug}.json`), JSON.stringify(routes, null, 2))
        total += routes.length
      }
      console.log(`  ${slug.padEnd(30)} ${routes.length} Routen`)
    } catch (err) {
      console.warn(`  ! ${slug}: ${err.message}`)
    }

    await sleep(500)
  }

  console.log(`${total} Routen zwischengespeichert.`)
}
