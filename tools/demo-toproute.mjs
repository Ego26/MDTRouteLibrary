// Vorfuehrung, nicht zum Einchecken: eine echte keystone.guru-Route als
// Top-Route einsetzen.
//
// Der Reiter "Top Routes" zeigt heute Verweise, weil die Routen fehlen - nicht
// weil das Addon sie nicht darstellen koennte. Dieses Werkzeug belegt das: es
// nimmt einen echten MDT-String, wie ihn keystone.guru ueber "Copy MDT"
// herausgibt, und schreibt ihn als Top-Route in die Daten. Danach ist im Spiel
// zu sehen, wie ein Eintrag aussaehe, wenn der Zugang da waere - mit Karte,
// Pull-Liste und Import, genau wie eine Community-Route.
//
// Die Route gehoert ihrem Autor. Nichts davon geht in ein Release, solange er
// nicht gefragt wurde - deshalb schreibt dieses Werkzeug nach data/routes und
// nicht in ein Paket, und deshalb steht es hier und nicht im Build.
//
// Aufruf:
//   node tools/demo-toproute.mjs --mdt <MDT-Pfad> --string "!~MDT2~..." \
//        [--url https://raider.io/...] [--keystone https://keystone.guru/...] \
//        [--level 21] [--time 1715] [--rank 1] [--out data/routes]

import { writeFileSync, mkdirSync } from 'node:fs'
import { join } from 'node:path'
import { readDungeons, buildLookup } from './mdt-dungeons.mjs'
import { decodeSubmission, toRoute } from './parse-submission.mjs'

function parseArgs(argv) {
  const args = {}
  for (let i = 0; i < argv.length; i += 1) {
    if (!argv[i].startsWith('--')) continue
    const next = argv[i + 1]
    args[argv[i].slice(2)] = next === undefined || next.startsWith('--') ? true : argv[++i]
  }
  return args
}

const args = parseArgs(process.argv.slice(2))
if (!args.mdt || !args.string) {
  console.error('Aufruf: node tools/demo-toproute.mjs --mdt <MDT-Pfad> --string "!~MDT2~..."')
  process.exit(1)
}

const { dungeons } = readDungeons(args.mdt)
const lookup = buildLookup(dungeons)

const decoded = decodeSubmission(String(args.string), lookup, 'en')
const { route, warnings } = toRoute(decoded, lookup, 'en')

for (const warnung of warnings ?? []) console.warn('   ! ' + warnung)

const dungeon = lookup.byChallengeMode.get(route.challengeModeId)
const sekunden = Number(args.time ?? 0)
const minuten = Math.floor(sekunden / 60)
const rest = String(sekunden % 60).padStart(2, '0')
const level = Number(args.level ?? 0)

// Das Entscheidende: source "raider.io" setzt den Eintrag in den Reiter
// "Top Routes" - und weil "reference" fehlt und Pulls da sind, wird er dort
// als vollwertige Route gezeichnet statt als Verweis.
const eintrag = {
  id: 'demo-' + route.challengeModeId,
  source: 'raider.io',
  title: level && sekunden ? `+${level} · ${minuten}:${rest}` : (route.title ?? 'Demo'),
  author: args.author ? String(args.author) : null,
  url: args.url ? String(args.url) : undefined,
  keystoneUrl: args.keystone ? String(args.keystone) : undefined,
  challengeModeId: route.challengeModeId,
  dungeonEnglishName: dungeon?.englishName,
  mdtDungeonIdx: dungeon?.mdtIndex,
  keyLevelMin: level || undefined,
  keyLevel: level || undefined,
  clearSeconds: sekunden || undefined,
  onTime: true,
  rank: args.rank ? Number(args.rank) : undefined,
  region: 'world',
  bracket: 'high',
  tier: 'fast',
  pulls: route.pulls,
  enemyForcesRequired: dungeon?.totalCount,
}

const outDir = String(args.out ?? 'data/routes')
mkdirSync(outDir, { recursive: true })
const datei = join(outDir, 'demo-toproute.json')
// Eine Datei, eine Route: der Build liest jede Datei als ein Objekt, nicht
// als Liste.
writeFileSync(datei, JSON.stringify(eintrag, null, 2) + '\n')

console.log('Dungeon:  ' + dungeon?.englishName)
console.log('Pulls:    ' + route.pulls.length)
console.log('Gegner:   ' + route.pulls.reduce((n, p) =>
  n + p.enemies.reduce((m, e) => m + e.clones.length, 0), 0))
console.log('Kraefte:  ' + (route.enemyForces ?? '?') + ' von ' + (dungeon?.totalCount ?? '?'))
console.log('-> ' + datei)
