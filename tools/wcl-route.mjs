// Baut aus einem Warcraftlogs-Bericht die tatsaechlich gelaufene Route.
//
// Warum das ueberhaupt geht, und warum es die anderen Wege nicht tun:
//
//   Raider.IOs API nennt Toetungsereignisse ohne Spawn und ohne Ort - daraus
//   laesst sich keine Route bauen, nur eine erfinden. Das wurde versucht und
//   wieder entfernt: sie sah ueberzeugend aus und war nicht die gelaufene.
//
//   Warcraftlogs gibt beides heraus. targetInstance unterscheidet die neun
//   gleichnamigen Gegner voneinander, und mit includeResources haengen x, y
//   und die Karten-ID an jedem Ereignis. Die Pull-Einteilung kommt als
//   dungeonPulls sogar fertig - dieselbe, die deren Wiederholung zeichnet.
//
// Bleibt die Uebersetzung in MDTs Welt. WoW zaehlt in Weltkoordinaten je
// Stockwerk, MDT in Kartenpunkten auf einem einzigen Bild. Die Abbildung
// dazwischen steht nirgends geschrieben - sie wird hier aus den Daten selbst
// bestimmt und danach geprueft.
//
// Aufruf:
//   node tools/wcl-route.mjs --mdt <MDT-Pfad> --report <Code> --fight <Nr>
//        [--dungeon "Murder Row"] [--truth <Datei mit MDT-String>] [--out <Datei>]

import { readFileSync, writeFileSync, existsSync, mkdirSync } from 'node:fs'
import { join } from 'node:path'
import { readDungeons, buildLookup } from './mdt-dungeons.mjs'

// ---------------------------------------------------------------- Zugang

/** Liest einen Wert aus der Umgebung oder aus .env. */
function env(name) {
  if (process.env[name]) return process.env[name].trim()
  try {
    const text = readFileSync('.env', 'utf8').replace(/^﻿/, '').replace(/\r\n?/g, '\n')
    for (const zeile of text.split('\n')) {
      const treffer = zeile.match(new RegExp('^\\s*' + name + '\\s*=\\s*(.*)$'))
      if (treffer) return treffer[1].trim().replace(/^["']|["']$/g, '')
    }
  } catch {}
  return null
}

/**
 * Meldet sich an und gibt eine Abfragefunktion zurueck.
 *
 * Warcraftlogs vergibt Zugangsdaten selbst - kein Antrag, keine Freigabe,
 * 3600 Punkte je Stunde. Das ist der Grund, warum dieser Weg ueberhaupt
 * gangbar ist.
 */
async function anmelden() {
  const id = env('WCL_CLIENT_ID')
  const secret = env('WCL_CLIENT_SECRET')
  if (!id || !secret) throw new Error('WCL_CLIENT_ID oder WCL_CLIENT_SECRET fehlt in .env')

  const antwort = await fetch('https://www.warcraftlogs.com/oauth/token', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      Authorization: 'Basic ' + Buffer.from(id + ':' + secret).toString('base64'),
    },
    body: 'grant_type=client_credentials',
  })
  if (!antwort.ok) throw new Error('Anmeldung: HTTP ' + antwort.status)
  const marke = (await antwort.json()).access_token

  return async function gql(query, variables = {}) {
    for (let versuch = 1; versuch <= 4; versuch += 1) {
      const res = await fetch('https://www.warcraftlogs.com/api/v2/client', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: 'Bearer ' + marke },
        body: JSON.stringify({ query, variables }),
      })
      if (res.status === 429 || res.status >= 500) {
        await new Promise((f) => setTimeout(f, versuch * 3000))
        continue
      }
      const body = await res.json()
      if (body.errors) throw new Error(JSON.stringify(body.errors).slice(0, 400))
      return body.data
    }
    throw new Error('Warcraftlogs antwortet nicht')
  }
}

// ------------------------------------------------------------------ Holen

/**
 * Holt alle Ereignisse einer Art. Seitenweise, ohne Deckel.
 *
 * Der Deckel war ein Fehler: 60 Seiten a 3000 sind 180 000 Ereignisse, und
 * ein langer Lauf hat mehr. Abgeschnitten fehlten die letzten Pulls
 * vollstaendig, ohne dass es auffiel - die Zahlen sahen nur etwas mager aus.
 */
async function alleEreignisse(gql, code, kampf, typ, aktoren) {
  const raus = []
  let von = kampf.startTime
  for (let seite = 0; seite < 500 && von < kampf.endTime; seite += 1) {
    const d = await gql(`query ($code: String!, $fight: Int!, $start: Float!, $end: Float!) {
      reportData { report(code: $code) {
        events(fightIDs: [$fight], startTime: $start, endTime: $end,
               dataType: ${typ}, hostilityType: Enemies,
               includeResources: true, limit: 3000) { data nextPageTimestamp }
      } }
    }`, { code, fight: kampf.id, start: von, end: kampf.endTime })

    const block = d.reportData.report.events
    for (const e of block.data ?? []) {
      const akteur = aktoren.get(e.targetID)
      if (!akteur) continue
      raus.push({
        t: e.timestamp,
        npcId: akteur.gameID,
        instanz: e.targetInstance ?? 1,
        x: e.x, y: e.y, mapID: e.mapID,
      })
    }
    if (!block.nextPageTimestamp) break
    von = block.nextPageTimestamp
  }
  return raus
}

// -------------------------------------------------------------- Abbildung

/**
 * Sucht die Abbildung von Weltkoordinaten auf MDTs Kartenpunkte.
 *
 * Aus je zwei denkbaren Paaren (Instanz, Klon derselben npcID) ergibt sich
 * eine Aehnlichkeitsabbildung; gewaehlt wird die, die die meisten Instanzen
 * dicht an einem eigenen Klon landen laesst.
 *
 * Der Massstab ist auf beiden Achsen derselbe. Das ist keine Vereinfachung,
 * sondern eine Bedingung: eine Karte spiegelt nicht eine Achse allein. Ohne
 * sie kam bei einem Stockwerk ein Massstab von -0,078 gegen 0,0162 heraus -
 * eine Anpassung, die rechnerisch passte und geometrisch unmoeglich war.
 */
function abbildungSuchen(instanzen, kloneJeNpc, toleranz = 45) {
  const paare = []
  for (const e of instanzen) {
    for (const k of kloneJeNpc.get(e.npcId) ?? []) paare.push({ e, k })
  }
  if (paare.length < 2) return null

  let beste = null
  const schritt = Math.max(1, Math.floor(paare.length / 160))

  for (let i = 0; i < paare.length; i += schritt) {
    for (let j = i + 1; j < paare.length; j += schritt) {
      const a = paare[i], b = paare[j]
      const dxW = b.e.x - a.e.x, dyW = b.e.y - a.e.y
      const dxM = b.k.x - a.k.x, dyM = b.k.y - a.k.y
      const weiteW = Math.hypot(dxW, dyW)
      const weiteM = Math.hypot(dxM, dyM)
      if (weiteW < 500 || weiteM < 30) continue

      const s = weiteM / weiteW
      if (s < 0.004 || s > 0.08) continue
      if (Math.sign(dxW) !== Math.sign(dxM) || Math.sign(dyW) !== Math.sign(dyM)) continue

      const kandidat = { s, dx: a.k.x - s * a.e.x, dy: a.k.y - s * a.e.y }
      const gueltig = bewerten(kandidat, instanzen, kloneJeNpc, toleranz)
      if (!beste || gueltig.treffer > beste.treffer ||
          (gueltig.treffer === beste.treffer && gueltig.summe < beste.summe)) {
        beste = { ...kandidat, ...gueltig }
      }
    }
  }

  // Nachjustieren: an den Treffern noch einmal rechnen, dann erneut zuordnen.
  // Zwei Punkte legen eine Abbildung fest, aber sie tragen auch ihren
  // eigenen Messfehler hinein; ueber dreissig Treffer mittelt er sich weg.
  for (let runde = 0; beste && runde < 3; runde += 1) {
    const zuordnung = zuordnen(beste, instanzen, kloneJeNpc, toleranz)
    if (zuordnung.length < 4) break
    const verfeinert = ausgleichen(zuordnung)
    if (!verfeinert) break
    const gueltig = bewerten(verfeinert, instanzen, kloneJeNpc, toleranz)
    if (gueltig.treffer < beste.treffer) break
    beste = { ...verfeinert, ...gueltig }
  }

  return beste
}

/** Kleinste Quadrate fuer gemeinsamen Massstab und zwei Verschiebungen. */
function ausgleichen(paare) {
  const n = paare.length
  let sxx = 0, sx = 0, sy = 0, sxy = 0, suu = 0, su = 0, sv = 0, suv = 0
  for (const p of paare) {
    sxx += p.wx * p.wx; sx += p.wx; sy += p.mx; sxy += p.wx * p.mx
    suu += p.wy * p.wy; su += p.wy; sv += p.my; suv += p.wy * p.my
  }
  const zaehler = (sxy - sx * sy / n) + (suv - su * sv / n)
  const nenner = (sxx - sx * sx / n) + (suu - su * su / n)
  if (!nenner) return null
  const s = zaehler / nenner
  return { s, dx: (sy - s * sx) / n, dy: (sv - s * su) / n }
}

/** Ordnet zu und gibt die Paare zurueck - fuer die Nachjustierung. */
function zuordnen(abb, instanzen, kloneJeNpc, toleranz) {
  const treffer = vergeben(abb, instanzen, kloneJeNpc, toleranz)
  return treffer.map((t) => ({ wx: t.e.x, wy: t.e.y, mx: t.k.x, my: t.k.y }))
}

function bewerten(abb, instanzen, kloneJeNpc, toleranz) {
  const treffer = vergeben(abb, instanzen, kloneJeNpc, toleranz)
  return { treffer: treffer.length, summe: treffer.reduce((s, t) => s + t.abstand, 0) }
}

/**
 * Vergibt Klone an Instanzen - alle auf einmal, nicht nacheinander.
 *
 * Nacheinander war der Fehler: wer zuerst drankam, nahm den naechsten freien
 * Klon, und ein Fehlgriff blockierte den richtigen fuer den naechsten. Jetzt
 * werden erst alle Abstaende gesammelt und dann die kuerzesten zuerst
 * vergeben - wer sicher ist, kommt zuerst.
 */
function vergeben(abb, instanzen, kloneJeNpc, toleranz) {
  const kandidaten = []
  for (const e of instanzen) {
    const x = abb.s * e.x + abb.dx
    const y = abb.s * e.y + abb.dy
    for (const k of kloneJeNpc.get(e.npcId) ?? []) {
      const abstand = Math.hypot(x - k.x, y - k.y)
      if (abstand <= toleranz) kandidaten.push({ e, k, abstand })
    }
  }
  kandidaten.sort((a, b) => a.abstand - b.abstand)

  const belegteKlone = new Set()
  const belegteInstanzen = new Set()
  const raus = []
  for (const kandidat of kandidaten) {
    const kSchluessel = kandidat.k.enemy + ':' + kandidat.k.clone
    const eSchluessel = kandidat.e.npcId + ':' + kandidat.e.instanz
    if (belegteKlone.has(kSchluessel) || belegteInstanzen.has(eSchluessel)) continue
    belegteKlone.add(kSchluessel)
    belegteInstanzen.add(eSchluessel)
    raus.push(kandidat)
  }
  return raus
}

// ----------------------------------------------------------------- Ablauf

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
if (!args.mdt || !args.report) {
  console.error('Aufruf: node tools/wcl-route.mjs --mdt <MDT-Pfad> --report <Code> --fight <Nr>')
  process.exit(1)
}

const code = String(args.report)
const fightId = args.fight !== undefined ? Number(args.fight) : null
const cacheDir = String(args.cache ?? 'data/cache/wcl')
mkdirSync(cacheDir, { recursive: true })

const gql = await anmelden()

// ---- Kampf, Akteure, Pulls
const kopf = await gql(`query ($code: String!) {
  reportData { report(code: $code) {
    title
    masterData { actors(type: "NPC") { id gameID name } }
    fights(translate: false) {
      id name startTime endTime keystoneLevel keystoneTime
      dungeonPulls {
        id name startTime endTime
        maps { id }
        enemyNPCs { gameID minimumInstanceID maximumInstanceID }
      }
    }
  } }
}`, { code })

const bericht = kopf.reportData.report
const kampf = fightId !== null
  ? bericht.fights.find((f) => f.id === fightId)
  : bericht.fights.find((f) => f.keystoneLevel)

if (!kampf) {
  console.error('Kampf nicht gefunden. Mythisch+ im Bericht: ' +
    bericht.fights.filter((f) => f.keystoneLevel).map((f) => f.id + '=' + f.name).join(', '))
  process.exit(1)
}

const aktoren = new Map(bericht.masterData.actors.map((a) => [a.id, a]))
const dauer = Math.round((kampf.endTime - kampf.startTime) / 1000)
console.log(kampf.name + ' +' + kampf.keystoneLevel + ', ' +
  Math.floor(dauer / 60) + ':' + String(dauer % 60).padStart(2, '0') +
  ', ' + (kampf.dungeonPulls ?? []).length + ' Pulls')

// ---- Ereignisse, mit Zwischenspeicher
async function geholt(typ) {
  const datei = join(cacheDir, code + '-' + kampf.id + '-' + typ + '.json')
  if (existsSync(datei)) return JSON.parse(readFileSync(datei, 'utf8'))
  const daten = await alleEreignisse(gql, code, kampf, typ, aktoren)
  writeFileSync(datei, JSON.stringify(daten))
  return daten
}

const schaden = await geholt('DamageTaken')
const tode = await geholt('Deaths')

// Wo stand jede Instanz, als ihr Kampf begann?
const ort = new Map()
for (const e of schaden) {
  if (e.x === undefined || e.y === undefined) continue
  const key = e.npcId + ':' + e.instanz
  if (!ort.has(key)) ort.set(key, e)
}
const gestorben = new Set(tode.map((e) => e.npcId + ':' + e.instanz))
console.log('Ereignisse: ' + schaden.length + ', Instanzen mit Ort: ' + ort.size +
  ', gestorben: ' + gestorben.size)

// ---- MDT
const { dungeons } = readDungeons(String(args.mdt))
const lookup = buildLookup(dungeons)
const name = String(args.dungeon ?? kampf.name).toLowerCase()
const dungeon = lookup.byName.get(name)
if (!dungeon) {
  console.error('Dungeon "' + name + '" nicht in MDT. Mit --dungeon den englischen Namen angeben.')
  process.exit(1)
}

const kloneJeNpc = new Map()
for (const gegner of dungeon.enemies ?? []) {
  for (const [idx, pos] of Object.entries(gegner.clonePos ?? {})) {
    if (!kloneJeNpc.has(gegner.id)) kloneJeNpc.set(gegner.id, [])
    kloneJeNpc.get(gegner.id).push({
      npcId: gegner.id, enemy: gegner.index, clone: Number(idx),
      x: pos.x, y: pos.y,
      // Ein Klon darf mehr Kraefte geben als seine Geschwister.
      count: pos.count ?? gegner.count,
    })
  }
}

// ---- Abbildung je Stockwerk
const abbildungen = new Map()
for (const mapID of [...new Set([...ort.values()].map((e) => e.mapID))]) {
  const hier = [...ort.values()].filter((e) => e.mapID === mapID)
  const abb = abbildungSuchen(hier, kloneJeNpc)
  if (!abb) { console.log('Karte ' + mapID + ': keine Abbildung'); continue }
  abbildungen.set(mapID, abb)
  console.log('Karte ' + String(mapID) + ': ' + String(hier.length).padStart(3) +
    ' Instanzen, Massstab ' + abb.s.toFixed(5) +
    ', erklaert ' + abb.treffer + ' (Abstand im Mittel ' +
    Math.round(abb.summe / Math.max(1, abb.treffer)) + ')')
}

// ---- Zuordnung, nach Karten getrennt und nur fuer Gestorbene
const zugeteilt = new Map()   // "npcId:instanz" -> Klon
for (const [mapID, abb] of abbildungen) {
  const hier = [...ort.values()].filter((e) => e.mapID === mapID &&
    gestorben.has(e.npcId + ':' + e.instanz))
  for (const t of vergeben(abb, hier, kloneJeNpc, Number(args.toleranz ?? 60))) {
    zugeteilt.set(t.e.npcId + ':' + t.e.instanz, t.k)
  }
}

// ---- Pulls in MDTs Sprache
const pulls = []
let kraefte = 0

// Jeder Gegner gehoert in genau einen Pull. Die Instanzbereiche der Pulls
// ueberschneiden sich naemlich: kommt dieselbe Gegnerart in mehreren Pulls
// vor, nennen beide einen Bereich, der die anderen Instanzen mit einschliesst.
// Wer das uebersieht, zaehlt Gegner mehrfach - und landet bei 117 Prozent,
// obwohl nur zwei Klone falsch sind.
const vergebeneInstanzen = new Set()

// Warcraftlogs fasst Chainpulls zusammen: wer weiterzieht, ohne aus dem
// Kampf zu fallen, bekommt dort einen einzigen Pull. keystone.guru trennt
// sie - und wer eine Route liest, will diese Trennung, denn sie sagt, wo man
// anhaelt.
//
// Innerhalb eines groben Pulls verrät der Erstkontakt die Grenze: ein Pack
// wird auf einen Schlag angegriffen, das naechste Sekunden spaeter. Geteilt
// wird nur innerhalb - so kann nichts falsch zusammengelegt werden, was
// Warcraftlogs richtig getrennt hat.
// 45 Sekunden, an drei echten Routen abgetastet. Der Wert ist eine Kante,
// keine Spitze: darunter zerfaellt ein Pull in seine Wellen, darueber
// verschmelzen benachbarte Packs. Gemessene Guete der Einteilung 80 / 95 / 86.
//
// Drei Routen sind wenig, um eine Zahl festzuzurren - wer mehr hat, sollte
// nachmessen, statt ihr zu vertrauen.
const teilen = Number(args.split ?? 45000)

for (const p of kampf.dungeonPulls ?? []) {
  const mitglieder = []
  for (const n of p.enemyNPCs ?? []) {
    const von = n.minimumInstanceID ?? 1
    const bis = n.maximumInstanceID ?? von
    for (let inst = von; inst <= bis; inst += 1) {
      const schluessel = n.gameID + ':' + inst
      if (vergebeneInstanzen.has(schluessel)) continue
      const klon = zugeteilt.get(schluessel)
      if (!klon) continue
      vergebeneInstanzen.add(schluessel)
      mitglieder.push({ klon, t: ort.get(schluessel)?.t ?? p.startTime })
    }
  }

  mitglieder.sort((a, b) => a.t - b.t)

  let gruppe = []
  let vorige = null
  const abschliessen = () => {
    if (!gruppe.length) return
    const eintraege = new Map()
    for (const m of gruppe) {
      if (!eintraege.has(m.klon.enemy)) eintraege.set(m.klon.enemy, [])
      eintraege.get(m.klon.enemy).push(m.klon.clone)
      kraefte += m.klon.count ?? 0
    }
    pulls.push({ enemies: [...eintraege.entries()].map(([enemy, clones]) => ({ enemy, clones })) })
    gruppe = []
  }

  for (const m of mitglieder) {
    if (vorige !== null && m.t - vorige > teilen) abschliessen()
    gruppe.push(m)
    vorige = m.t
  }
  abschliessen()
}

const anteil = Math.round(kraefte / dungeon.totalCount * 1000) / 10
console.log('')
console.log('Route: ' + pulls.length + ' Pulls, ' + zugeteilt.size + ' Gegner, ' +
  kraefte + ' von ' + dungeon.totalCount + ' Kraeften (' + anteil + '%)')

const ergebnis = {
  report: code, fight: kampf.id,
  dungeon: dungeon.englishName,
  challengeModeId: dungeon.challengeModeId,
  keyLevel: kampf.keystoneLevel,
  clearSeconds: dauer,
  enemyForces: kraefte,
  enemyForcesRequired: dungeon.totalCount,
  pulls,
}

if (args.out) {
  writeFileSync(String(args.out), JSON.stringify(ergebnis, null, 2) + '\n')
  console.log('-> ' + args.out)
}

// ---- Gegen die Wahrheit halten, wenn eine da ist
if (args.truth) {
  const { decodeSubmission, toRoute } = await import('./parse-submission.mjs')
  const string = readFileSync(String(args.truth), 'utf8').trim()
  const { route } = toRoute(decodeSubmission(string, lookup, 'en'), lookup, 'en')

  const sammeln = (ps) => {
    const m = new Map()
    for (const [i, p] of ps.entries()) {
      for (const e of p.enemies ?? []) for (const c of e.clones ?? []) m.set(e.enemy + ':' + c, i + 1)
    }
    return m
  }
  const A = sammeln(route.pulls), B = sammeln(pulls)
  const gemeinsam = [...A.keys()].filter((k) => B.has(k))

  // Die Einteilung paarweise messen, nicht ueber Pull-Nummern: wer 25 Pulls
  // baut und 14 vergleicht, kann keine Nummer treffen, auch wenn er richtig
  // gruppiert. Die Frage ist, ob zwei Gegner, die in der echten Route
  // zusammenstehen, auch bei mir zusammenstehen - und ob getrennte getrennt
  // bleiben.
  let zusammenBeide = 0, zusammenNurEcht = 0, zusammenNurMeins = 0
  for (let i = 0; i < gemeinsam.length; i += 1) {
    for (let j = i + 1; j < gemeinsam.length; j += 1) {
      const a = gemeinsam[i], b = gemeinsam[j]
      const echt = A.get(a) === A.get(b)
      const meins = B.get(a) === B.get(b)
      if (echt && meins) zusammenBeide += 1
      else if (echt) zusammenNurEcht += 1
      else if (meins) zusammenNurMeins += 1
    }
  }
  const genauigkeit = zusammenBeide / Math.max(1, zusammenBeide + zusammenNurMeins)
  const vollstaendig = zusammenBeide / Math.max(1, zusammenBeide + zusammenNurEcht)
  const guete = 2 * genauigkeit * vollstaendig / Math.max(1e-9, genauigkeit + vollstaendig)

  console.log('')
  console.log('Gegen die echte Route:')
  console.log('  Wahrheit:        ' + A.size + ' Klone, ' + route.pulls.length + ' Pulls, ' +
    route.enemyForces + ' Kraefte')
  console.log('  getroffen:       ' + gemeinsam.length +
    ' (' + Math.round(gemeinsam.length / A.size * 100) + '%)')
  console.log('  falsch:          ' + [...B.keys()].filter((k) => !A.has(k)).length)
  console.log('  fehlend:         ' + [...A.keys()].filter((k) => !B.has(k)).length)
  console.log('  Einteilung:      ' +
    Math.round(genauigkeit * 100) + '% der von mir zusammengelegten gehoeren zusammen, ' +
    Math.round(vollstaendig * 100) + '% der zusammengehoerigen habe ich zusammen  (Guete ' +
    Math.round(guete * 100) + ')')
}
