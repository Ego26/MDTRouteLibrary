// Welche Top-Routen lohnen sich zum Abholen, und wo liegen sie?
//
// Der Reiter zeigt 145 Verweise. Von Hand sind die nicht zu holen - aber das
// muss auch niemand: pro Dungeon deckt eine Handvoll ab, wonach tatsaechlich
// gesucht wird. Dieses Werkzeug waehlt sie aus und schreibt die Adressen
// heraus, in der Reihenfolge, in der sie am meisten bringen.
//
// Aufruf:
//   node tools/toproute-liste.mjs [--je 1] [--data data/raiderio]

import { readdirSync, readFileSync } from 'node:fs'
import { join } from 'node:path'

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
const jeDungeon = Number(args.je ?? 1)
const dir = String(args.data ?? 'data/raiderio')

/** Minuten:Sekunden. */
function zeit(sekunden) {
  const m = Math.floor((sekunden ?? 0) / 60)
  const s = String((sekunden ?? 0) % 60).padStart(2, '0')
  return m + ':' + s
}

/** Tank-Spezialisierung einer Gruppe. */
function tank(run) {
  const t = (run.roster ?? []).find((m) => m.role === 'tank')
  return t ? (t.spec + ' ' + t.class) : '?'
}

let gesamt = 0
const zeilen = []

for (const datei of readdirSync(dir).filter((f) => f.endsWith('.json')).sort()) {
  const runs = JSON.parse(readFileSync(join(dir, datei), 'utf8'))
  if (!Array.isArray(runs) || !runs.length) continue

  // Die hoechste Stufe zuerst, darin die schnellste Zeit. Wer nur eine Route
  // je Dungeon holt, will diese - und wer mehrere holt, bekommt der Reihe
  // nach verschiedene Tanks, weil danach am haeufigsten gefiltert wird.
  const sortiert = [...runs].sort((a, b) =>
    (b.keyLevel - a.keyLevel) || (a.clearSeconds - b.clearSeconds))

  const genommen = []
  const tanks = new Set()

  // Erst je einen je Tank-Spezialisierung, dann auffuellen.
  for (const run of sortiert) {
    if (genommen.length >= jeDungeon) break
    const t = tank(run)
    if (tanks.has(t)) continue
    tanks.add(t)
    genommen.push(run)
  }
  for (const run of sortiert) {
    if (genommen.length >= jeDungeon) break
    if (!genommen.includes(run)) genommen.push(run)
  }

  for (const run of genommen) {
    gesamt += 1
    zeilen.push({
      nr: gesamt,
      dungeon: run.dungeonEnglishName,
      titel: '+' + run.keyLevel + ' · ' + zeit(run.clearSeconds),
      tank: tank(run),
      rang: run.rank,
      url: run.keystoneUrl,
      lauf: run.url,
      id: run.id,
      level: run.keyLevel,
      seconds: run.clearSeconds,
    })
  }
}

console.log(gesamt + ' Routen zum Abholen, ' + jeDungeon + ' je Dungeon')
console.log('')
for (const z of zeilen) {
  console.log(String(z.nr).padStart(3) + '. ' + z.dungeon.padEnd(22) +
    z.titel.padEnd(14) + z.tank.padEnd(26) + 'Rang ' + z.rang)
  console.log('     ' + z.url)
}

console.log('')
console.log('So geht es weiter:')
console.log('  1. Adresse oeffnen, "Share" -> "Copy MDT"')
console.log('  2. Alle Strings untereinander in eine Datei, eine je Zeile')
console.log('  3. node tools/toproute-einlesen.mjs --mdt <MDT-Pfad> --datei <Datei>')
