// Baut gespeicherte Routen aus dem Zwischenspeicher neu, ohne Netz.
//
// Wofuer: wenn sich am Bau etwas aendert - ein Schwellwert, eine Regel - muss
// nicht die ganze Bestenliste noch einmal von Warcraftlogs geholt werden. Die
// Berichtskennung und der Kampf stehen im Eintrag, die Ereignisse liegen im
// Zwischenspeicher. Es bleibt reine Rechnerei.
//
// Aufruf:
//   node tools/wcl-nachtragen.mjs --mdt <MDT-Pfad> [--in data/raiderio]

import { readFileSync, writeFileSync, readdirSync, existsSync } from 'node:fs'
import { join } from 'node:path'
import { readDungeons, buildLookup } from './mdt-dungeons.mjs'
import { kloneOrdnen, routeBauen } from './wcl-route.mjs'

const args = {}
for (let i = 2; i < process.argv.length; i += 1) {
  if (!process.argv[i].startsWith('--')) continue
  const next = process.argv[i + 1]
  args[process.argv[i].slice(2)] = next === undefined || next.startsWith('--') ? true : process.argv[++i]
}

if (!args.mdt) {
  console.error('Aufruf: node tools/wcl-nachtragen.mjs --mdt <MDT-Pfad> [--in data/raiderio]')
  process.exit(1)
}

const inDir = String(args.in ?? 'data/raiderio')
const cacheDir = String(args.cache ?? 'data/cache/wcl')
const { dungeons } = readDungeons(String(args.mdt))
const lookup = buildLookup(dungeons)

let gebaut = 0, ohneSpeicher = 0, geaendert = 0

for (const datei of readdirSync(inDir).filter((f) => f.endsWith('.json'))) {
  const pfad = join(inDir, datei)
  const laeufe = JSON.parse(readFileSync(pfad, 'utf8'))
  let schreiben = false

  for (const lauf of laeufe) {
    if (!lauf.wclReport || lauf.wclFight === undefined) continue
    const dungeon = lookup.byChallengeMode.get(lauf.challengeModeId)
    if (!dungeon) continue

    const kopfDatei = join(cacheDir, lauf.wclReport + '-kopf.json')
    const schadenDatei = join(cacheDir, lauf.wclReport + '-' + lauf.wclFight + '-DamageTaken.json')
    const todDatei = join(cacheDir, lauf.wclReport + '-' + lauf.wclFight + '-Deaths.json')
    const zauberDatei = join(cacheDir, lauf.wclReport + '-' + lauf.wclFight + '-Casts.json')
    const lebenDatei = join(cacheDir, lauf.wclReport + '-' + lauf.wclFight + '-Leben.json')
    if (!existsSync(kopfDatei) || !existsSync(schadenDatei) || !existsSync(todDatei)) {
      ohneSpeicher += 1
      continue
    }

    const bericht = JSON.parse(readFileSync(kopfDatei, 'utf8')).reportData.report
    const kampf = bericht.fights.find((f) => f.id === lauf.wclFight)
    if (!kampf) { ohneSpeicher += 1; continue }

    const ergebnis = routeBauen({
      kampf,
      schaden: JSON.parse(readFileSync(schadenDatei, 'utf8')),
      tode: JSON.parse(readFileSync(todDatei, 'utf8')),
      zauber: existsSync(zauberDatei) ? JSON.parse(readFileSync(zauberDatei, 'utf8')) : [],
      leben: existsSync(lebenDatei) ? JSON.parse(readFileSync(lebenDatei, 'utf8')) : null,
      dungeon,
      kloneJeNpc: kloneOrdnen(dungeon),
    })

    const vorher = JSON.stringify([lauf.pulls, lauf.enemyForces, lauf.filled])
    lauf.pulls = ergebnis.pulls
    lauf.enemyForces = ergebnis.kraefte
    lauf.filled = ergebnis.ergaenzt || undefined
    gebaut += 1
    if (JSON.stringify([lauf.pulls, lauf.enemyForces, lauf.filled]) !== vorher) {
      geaendert += 1
      schreiben = true
    }
  }

  if (schreiben) writeFileSync(pfad, JSON.stringify(laeufe, null, 2) + '\n')
}

console.log('neu gebaut ' + gebaut + ', davon anders ' + geaendert +
  (ohneSpeicher ? ', ohne Zwischenspeicher ' + ohneSpeicher : ''))
