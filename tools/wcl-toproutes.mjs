// Macht aus den Ranglisteneintraegen echte Routen.
//
// Die Ranglistenlaeufe von Raider.IO bringen Stufe, Zeit, Gruppe und Rang mit,
// aber keine Route: welcher von neun gleichnamigen Gegnern fiel und wo ein
// Pull endete, steht dort nicht. Bisher verwies der Eintrag deshalb nur auf
// keystone.guru.
//
// Warcraftlogs hat beides. Dieses Werkzeug schlaegt die Bruecke: es sucht zu
// jedem Lauf den Bericht - ueber Kader, Realm und Zeitpunkt - und baut daraus
// die Pulls, die das Addon anzeigen kann.
//
// Was dabei nicht gefunden wird, bleibt ein Verweis. Ein Eintrag ohne Pulls
// ist ehrlicher als einer mit erfundenen.
//
// Aufruf:
//   node tools/wcl-toproutes.mjs --mdt <MDT-Pfad> [--in data/raiderio]
//        [--cache data/cache/wcl] [--nur murder-row] [--neu]

import { readFileSync, writeFileSync, readdirSync, mkdirSync } from 'node:fs'
import { join } from 'node:path'
import { readDungeons, buildLookup } from './mdt-dungeons.mjs'
import { anmelden, berichtFinden } from './wcl-api.mjs'
import { berichtHolen, ereignisseHolen, kloneOrdnen, routeBauen } from './wcl-route.mjs'

const args = {}
for (let i = 2; i < process.argv.length; i += 1) {
  if (!process.argv[i].startsWith('--')) continue
  const next = process.argv[i + 1]
  args[process.argv[i].slice(2)] = next === undefined || next.startsWith('--') ? true : process.argv[++i]
}

if (!args.mdt) {
  console.error('Aufruf: node tools/wcl-toproutes.mjs --mdt <MDT-Pfad> [--in data/raiderio]')
  process.exit(1)
}

const inDir = String(args.in ?? 'data/raiderio')
const cacheDir = String(args.cache ?? 'data/cache/wcl')
mkdirSync(cacheDir, { recursive: true })

const { dungeons } = readDungeons(String(args.mdt))
const lookup = buildLookup(dungeons)
const gql = await anmelden()

// Ein Spieler laeuft mehrere der Top-Laeufe. Seine Berichtsliste einmal zu
// holen und dann wiederzuverwenden spart bei 145 Laeufen ein gutes Drittel
// der Anfragen.
const merker = new Map()

let gesucht = 0, gefunden = 0, gebaut = 0, uebersprungen = 0
const magerer = []

for (const datei of readdirSync(inDir).filter((f) => f.endsWith('.json'))) {
  if (args.nur && !datei.startsWith(String(args.nur))) continue
  const pfad = join(inDir, datei)
  const laeufe = JSON.parse(readFileSync(pfad, 'utf8'))
  let geaendert = false

  for (const lauf of laeufe) {
    // Schon gebaut? Dann nichts noch einmal aus dem Netz holen.
    if (lauf.pulls && !args.neu) { uebersprungen += 1; continue }

    const dungeon = lookup.byChallengeMode.get(lauf.challengeModeId)
    if (!dungeon) continue

    gesucht += 1

    // ---- Den Bericht suchen
    const treffer = await berichtFinden(gql, {
      completed_at: lauf.completedAt,
      mythic_level: lauf.keyLevel,
      clear_time_ms: lauf.clearMs ?? (lauf.clearSeconds ?? 0) * 1000,
      roster: (lauf.roster ?? []).map((m) => ({
        name: m.name, realm: m.realm, region: m.realmRegion,
      })),
    }, merker).catch((e) => {
      console.log('   ! ' + lauf.id + ': ' + e.message.slice(0, 80))
      return null
    })

    if (!treffer) {
      process.stdout.write('-')
      continue
    }
    gefunden += 1

    // ---- Die Route bauen
    try {
      const bericht = await berichtHolen(gql, treffer.code, cacheDir)
      const kampf = bericht.fights.find((f) => f.id === treffer.fight)
      if (!kampf) { process.stdout.write('?'); continue }

      const aktoren = new Map(bericht.masterData.actors.map((a) => [a.id, a]))
      const schaden = await ereignisseHolen(gql, treffer.code, kampf, aktoren, cacheDir, 'DamageTaken')
      const tode = await ereignisseHolen(gql, treffer.code, kampf, aktoren, cacheDir, 'Deaths')

      const ergebnis = routeBauen({
        kampf, schaden, tode, dungeon, kloneJeNpc: kloneOrdnen(dungeon),
      })

      const anteil = ergebnis.kraefte / (dungeon.totalCount || 1)

      // Zu wenig zusammenbekommen heisst: der Bericht traegt die Route nicht.
      // Das passiert, wenn jemand erst mittendrin aufzuzeichnen anfing. Eine
      // halbe Route ist schlimmer als keine - wer ihr folgt, endet vor einem
      // Boss mit siebzig Prozent.
      if (anteil < 0.9) {
        magerer.push(lauf.id + ' ' + dungeon.englishName + ' +' + lauf.keyLevel +
          ' nur ' + Math.round(anteil * 100) + '%')
        process.stdout.write('!')
        continue
      }

      lauf.wclReport = treffer.code
      lauf.wclFight = treffer.fight
      lauf.pulls = ergebnis.pulls
      lauf.enemyForces = ergebnis.kraefte
      // Der einzige Teil der Route, den kein Ereignis direkt belegt: Gegner,
      // die im Protokoll starben, aber geometrisch nicht unterzubringen waren
      // und deshalb ueber ihr Pack eingeordnet wurden. Wer die Route ansieht,
      // soll das erfahren.
      lauf.filled = ergebnis.ergaenzt || undefined
      gebaut += 1
      geaendert = true
      process.stdout.write('.')
    } catch (e) {
      console.log('   ! ' + lauf.id + ' bauen: ' + e.message.slice(0, 100))
    }
  }

  if (geaendert) writeFileSync(pfad, JSON.stringify(laeufe, null, 2) + '\n')
}

console.log('')
console.log('gesucht ' + gesucht + ', Bericht gefunden ' + gefunden +
  ', Route gebaut ' + gebaut +
  (uebersprungen ? ', schon da ' + uebersprungen : ''))
for (const m of magerer) console.log('   zu duenn: ' + m)
