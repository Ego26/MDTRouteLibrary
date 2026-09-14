// Nimmt beliebig viele MDT-Strings und macht daraus Top-Routen.
//
// Der Reiter "Top Routes" zeigt Verweise, weil die Routen fehlen - nicht weil
// das Addon sie nicht darstellen koennte. Ein Eintrag mit source "raider.io",
// ohne "reference" und mit Pulls wird dort als vollwertige Route gezeichnet:
// Karte, Pull-Liste, Import.
//
// Die Zuordnung laeuft ueber den Dungeon: der String nennt ihn selbst, und
// dazu wird der passende Lauf aus data/raiderio gesucht - der hoechste und
// schnellste, der noch keine Route hat. So muss niemand Adressen und Strings
// von Hand paaren.
//
// Aufruf:
//   node tools/toproute-einlesen.mjs --mdt <MDT-Pfad> --datei strings.txt
//   node tools/toproute-einlesen.mjs --mdt <MDT-Pfad> --string "!~MDT2~..."

import { readFileSync, writeFileSync, readdirSync, mkdirSync, existsSync } from 'node:fs'
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
if (!args.mdt || (!args.datei && !args.string)) {
  console.error('Aufruf: node tools/toproute-einlesen.mjs --mdt <MDT-Pfad> --datei strings.txt')
  process.exit(1)
}

// ---- Die Strings einsammeln. Ein String je Zeile, Leeres und Kommentare weg.
const roh = args.datei
  ? readFileSync(String(args.datei), 'utf8').replace(/^﻿/, '').replace(/\r\n?/g, '\n')
  : String(args.string)

const strings = roh
  .split('\n')
  .map((z) => z.trim())
  .filter((z) => z && !z.startsWith('#'))

if (!strings.length) {
  console.error('Keine Strings gefunden.')
  process.exit(1)
}

const { dungeons } = readDungeons(args.mdt)
const lookup = buildLookup(dungeons)

// ---- Die Laeufe, denen eine Route zugeordnet werden kann.
const rioDir = String(args.raiderio ?? 'data/raiderio')
const laeufeJeDungeon = new Map()
if (existsSync(rioDir)) {
  for (const datei of readdirSync(rioDir).filter((f) => f.endsWith('.json'))) {
    for (const run of JSON.parse(readFileSync(join(rioDir, datei), 'utf8'))) {
      const key = run.challengeModeId
      if (!laeufeJeDungeon.has(key)) laeufeJeDungeon.set(key, [])
      laeufeJeDungeon.get(key).push(run)
    }
  }
  // Hoechste Stufe zuerst, darin die schnellste Zeit - dieselbe Ordnung wie in
  // tools/toproute-liste.mjs, damit der erste String zum ersten Lauf passt.
  for (const liste of laeufeJeDungeon.values()) {
    liste.sort((a, b) => (b.keyLevel - a.keyLevel) || (a.clearSeconds - b.clearSeconds))
  }
}

const outDir = String(args.out ?? 'data/routes')
mkdirSync(outDir, { recursive: true })

const vergeben = new Set()
let gebaut = 0

for (const [i, text] of strings.entries()) {
  let route, warnings
  try {
    ;({ route, warnings } = toRoute(decodeSubmission(text, lookup, 'en'), lookup, 'en'))
  } catch (fehler) {
    console.error(String(i + 1).padStart(3) + '. FEHLER: ' + fehler.message)
    continue
  }

  const dungeon = lookup.byChallengeMode.get(route.challengeModeId)

  // Den passenden Lauf suchen: derselbe Dungeon, noch nicht vergeben.
  const kandidaten = laeufeJeDungeon.get(route.challengeModeId) ?? []
  const lauf = kandidaten.find((r) => !vergeben.has(r.id))
  if (lauf) vergeben.add(lauf.id)

  const sek = lauf?.clearSeconds ?? 0
  const titel = lauf
    ? `+${lauf.keyLevel} · ${Math.floor(sek / 60)}:${String(sek % 60).padStart(2, '0')}`
    : (route.title || dungeon?.englishName || 'Top-Route')

  const tank = (lauf?.roster ?? []).find((m) => m.role === 'tank')

  const eintrag = {
    // Die Kennung des Laufs, damit der Verweis ersetzt wird statt daneben zu
    // stehen. Ohne Lauf eine eigene, damit nichts kollidiert.
    id: lauf?.id ?? 'top-' + route.challengeModeId + '-' + route.fingerprint,
    source: 'raider.io',
    title: titel,
    author: tank && tank.spec ? tank.spec + ' ' + tank.class : null,
    url: lauf?.url,
    keystoneUrl: lauf?.keystoneUrl,
    challengeModeId: route.challengeModeId,
    dungeonEnglishName: dungeon?.englishName,
    mdtDungeonIdx: dungeon?.mdtIndex,
    sublevel: route.sublevel ?? 1,
    keyLevelMin: lauf?.keyLevel,
    keyLevel: lauf?.keyLevel,
    clearSeconds: lauf?.clearSeconds,
    onTime: true,
    rank: lauf?.rank,
    region: lauf?.region ?? 'world',
    bracket: lauf?.bracket ?? 'high',
    tier: lauf?.tier ?? 'fast',
    roster: lauf?.roster,
    pulls: route.pulls,
    enemyForces: route.enemyForces,
    enemyForcesRequired: dungeon?.totalCount,
  }

  const name = 'top-' + String(eintrag.id).replace(/[^A-Za-z0-9_-]/g, '-') + '.json'
  writeFileSync(join(outDir, name), JSON.stringify(eintrag, null, 2) + '\n')
  gebaut += 1

  const anteil = eintrag.enemyForcesRequired
    ? Math.round((route.enemyForces / eintrag.enemyForcesRequired) * 1000) / 10
    : '?'

  console.log(
    String(i + 1).padStart(3) + '. ' + (dungeon?.englishName ?? '?').padEnd(22) +
    titel.padEnd(14) +
    String(route.pulls.length).padStart(3) + ' Pulls  ' +
    String(anteil).padStart(5) + '%' +
    (lauf ? '  -> ersetzt Verweis ' + lauf.id : '  (kein Lauf zugeordnet)')
  )
  for (const w of warnings ?? []) console.log('      ! ' + w)
}

console.log('')
console.log(gebaut + ' von ' + strings.length + ' Routen gebaut -> ' + outDir)
console.log('Danach: node tools/build.mjs --mdt <MDT-Pfad> --force')
