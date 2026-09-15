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
// Gemessen an drei echten keystone.guru-Routen trifft das Ergebnis 142 von
// 148, 115 von 115 und 90 von 92 Gegnern, bei 2, 2 und 0 falschen.
//
// Aufruf:
//   node tools/wcl-route.mjs --mdt <MDT-Pfad> --report <Code> --fight <Nr>
//        [--dungeon "Murder Row"] [--truth <Datei mit MDT-String>] [--out <Datei>]

import { readFileSync, writeFileSync, existsSync, mkdirSync } from 'node:fs'
import { join } from 'node:path'
import { readDungeons, buildLookup } from './mdt-dungeons.mjs'
import { anmelden } from './wcl-api.mjs'

// ------------------------------------------------------------------ Holen

/**
 * Holt Kampf, Akteure und die grobe Pull-Einteilung eines Berichts.
 *
 * Mit Zwischenspeicher: der Kopf kostet eine Anfrage und aendert sich nie -
 * ein abgeschlossener Lauf bekommt keine neuen Pulls mehr.
 */
export async function berichtHolen(gql, code, cacheDir) {
  const datei = join(cacheDir, code + '-kopf.json')
  if (existsSync(datei)) return JSON.parse(readFileSync(datei, 'utf8')).reportData.report

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
  writeFileSync(datei, JSON.stringify(kopf))
  return kopf.reportData.report
}

/**
 * Holt alle Ereignisse einer Art. Seitenweise, ohne Deckel.
 *
 * Der Deckel war ein Fehler: 60 Seiten a 3000 sind 180 000 Ereignisse, und
 * ein langer Lauf hat mehr. Abgeschnitten fehlten die letzten Pulls
 * vollstaendig, ohne dass es auffiel - die Zahlen sahen nur etwas mager aus.
 */
export async function alleEreignisse(gql, code, kampf, typ, aktoren, leben = null, rolle = 'ziel') {
  // Zehntausend je Seite ist die Obergrenze - darueber liefert Warcraftlogs
  // trotzdem nur zehntausend. Und eine Seite kostet zwei Punkte, egal wie
  // voll sie ist: mit 3000 kostete ein Lauf 84 Anfragen, mit 10000 sind es
  // 22. Das ist der Unterschied zwischen "geht nicht taeglich" und "geht".
  const erste = new Map()
  let von = kampf.startTime
  for (let seite = 0; seite < 200 && von < kampf.endTime; seite += 1) {
    const d = await gql(`query ($code: String!, $fight: Int!, $start: Float!, $end: Float!) {
      reportData { report(code: $code) {
        events(fightIDs: [$fight], startTime: $start, endTime: $end,
               dataType: ${typ}, hostilityType: Enemies,
               includeResources: true, limit: 10000) { data nextPageTimestamp }
      } }
    }`, { code, fight: kampf.id, start: von, end: kampf.endTime })

    const block = d.reportData.report.events
    for (const e of block.data ?? []) {
      // Wem gehoeren die Koordinaten? resourceActor sagt es: 1 heisst dem
      // Verursacher, 2 dem Ziel. Bei erlittenem Schaden ist der Gegner das
      // Ziel, und es steht fast immer 2 - in Mordgasse gab es unter 214 000
      // Ereignissen vier Ausnahmen. Vier falsch gesetzte Gegner sind wenig,
      // aber sie kosten nichts zu vermeiden.
      //
      // Bei Zaubern ist der Gegner der Verursacher. Dieselbe Regel traegt
      // also beide Quellen, und wessen Ereignis auf einen Spieler zeigt,
      // faellt von selbst heraus: Spieler stehen nicht in aktoren.
      const ortlos = e.x === undefined
      const quelle = rolle === 'quelle'
      const wer = quelle ? e.sourceID : e.targetID
      const welche = (quelle ? e.sourceInstance : e.targetInstance) ?? 1
      const akteur = aktoren.get(wer)
      if (!akteur) continue

      // Der Ort gehoert dem, den resourceActor nennt: 1 der Verursacher,
      // 2 dem Ziel. Steht dort ein anderer als unser Gegner, taugt der Ort
      // nicht - dann bleibt nur der Zeitpunkt.
      const eigenerOrt = quelle ? e.resourceActor === 1 : e.resourceActor === 2
      const x = !ortlos && eigenerOrt ? e.x : undefined
      const y = !ortlos && eigenerOrt ? e.y : undefined
      const karte = !ortlos && eigenerOrt ? e.mapID : undefined
      // Nur das erste Ereignis je Gegner behalten. Gebraucht wird ohnehin
      // nur, wo er stand, als sein Kampf begann - alles danach ist
      // Wiederholung. Ungefiltert sind das neun Megabyte je Lauf und fast
      // zwei Gigabyte fuer die ganze Bestenliste; so bleiben ein paar
      // Kilobyte, und der Zwischenspeicher passt in einen CI-Lauf.
      // Und zwar das erste MIT Ort. Nicht jeder Treffer bringt Koordinaten
      // mit; wer einfach den ersten nimmt, wirft bei manchen Gegnern den
      // einzigen brauchbaren weg - gemessen fielen so bei Rubinquell 18 von
      // 90 Gegnern aus der Route.
      const key = akteur.gameID + ':' + welche

      // Nebenbei den Lebensverlauf mitschreiben, wenn jemand ihn haben will.
      //
      // keystone.guru trennt Chainpulls an den Lebenspunkten der laufenden
      // Gruppe - und Warcraftlogs haengt sie an jedes Ereignis. Sie nicht
      // aufzuheben hiess, sie zwischen Erstkontakt und Tod zu schaetzen, und
      // das ging bei Rubinquell daneben: wer angepullt, aber nicht fokussiert
      // wird, galt zu frueh als sterbend.
      //
      // Hoechstens alle zwei Sekunden ein Wert je Gegner. Das reicht, um zu
      // sagen, ob eine Gruppe schon liegt, und haelt den Zwischenspeicher
      // klein - die Trennung wird ohnehin nur an den Erstkontakten gefragt.
      if (leben && !quelle && e.hitPoints !== undefined && e.maxHitPoints > 0) {
        if (!leben.has(key)) leben.set(key, [])
        const reihe = leben.get(key)
        const letzter = reihe[reihe.length - 1]
        if (!letzter || e.timestamp - letzter[0] >= 2000) {
          reihe.push([e.timestamp, Math.round(e.hitPoints / e.maxHitPoints * 1000) / 1000])
        }
      }

      const bisher = erste.get(key)
      if (bisher && (bisher.x !== undefined || x === undefined)) continue
      erste.set(key, {
        // Der frueheste Zeitpunkt zaehlt, auch wenn der Ort von spaeter kommt:
        // wann ein Gegner in den Kampf geriet, ist eine andere Frage als, wo er
        // dabei stand.
        t: Math.min(bisher?.t ?? Infinity, e.timestamp),
        npcId: akteur.gameID,
        instanz: welche,
        x, y, mapID: karte,
      })
    }
    if (!block.nextPageTimestamp) break
    von = block.nextPageTimestamp
  }
  return [...erste.values()]
}

/** Ereignisse mit Zwischenspeicher je Bericht und Kampf. */
export async function ereignisseHolen(gql, code, kampf, aktoren, cacheDir, typ) {
  const datei = join(cacheDir, code + '-' + kampf.id + '-' + typ + '.json')
  if (existsSync(datei)) return JSON.parse(readFileSync(datei, 'utf8'))
  // Der Lebensverlauf faellt beim erlittenen Schaden nebenbei mit ab. Er
  // kostet keine einzige zusaetzliche Anfrage, nur ein paar Kilobyte.
  const leben = typ === 'DamageTaken' ? new Map() : null
  // Wer bei welcher Ereignisart der Gegner ist: bei erlittenem Schaden und
  // beim Tod das Ziel, bei Zaubern und ausgeteiltem Schaden der Verursacher.
  // Bei Bedrohung ist der Gegner ebenfalls das Ziel: ein Spieler wirkt auf
  // ihn, und er kommt dadurch in den Kampf.
  const rolle = typ === 'DamageTaken' || typ === 'Deaths' || typ === 'Threat' ? 'ziel' : 'quelle'
  const daten = await alleEreignisse(gql, code, kampf, typ, aktoren, leben, rolle)
  writeFileSync(datei, JSON.stringify(daten))
  if (leben) {
    writeFileSync(join(cacheDir, code + '-' + kampf.id + '-Leben.json'),
      JSON.stringify([...leben.entries()]))
  }
  return daten
}

/** Die Klone eines Dungeons, nach npcID geordnet - die Vorlagen der Zuordnung. */
export function kloneOrdnen(dungeon) {
  const raus = new Map()
  for (const gegner of dungeon.enemies ?? []) {
    for (const [idx, pos] of Object.entries(gegner.clonePos ?? {})) {
      if (!raus.has(gegner.id)) raus.set(gegner.id, [])
      raus.get(gegner.id).push({
        npcId: gegner.id, enemy: gegner.index, clone: Number(idx),
        x: pos.x, y: pos.y, g: pos.g, boss: gegner.isBoss === true,
        // Ein Klon darf mehr Kraefte geben als seine Geschwister.
        count: pos.count ?? gegner.count,
      })
    }
  }
  return raus
}

// -------------------------------------------------------------- Abbildung

/**
 * Sucht die Abbildung von Weltkoordinaten auf MDTs Kartenpunkte.
 *
 * Aus je zwei denkbaren Paaren (Instanz, Klon derselben npcID) ergibt sich
 * eine Aehnlichkeitsabbildung. Davon gibt es Tausende; gesucht wird weit und
 * ausgewaehlt wird eng:
 *
 *   1. Alle Kandidaten grob bewerten und die zwoelf verschiedenen Massstaebe
 *      mit den meisten Treffern als Anfaenge nehmen.
 *   2. Jeden davon an seinen eigenen Treffern nachjustieren.
 *   3. Erst dann streng bewerten - und der Beste gewinnt.
 *
 * Schritt drei ist der entscheidende. Mit derselben weiten Toleranz zu suchen
 * und zu bewerten war der Fehler: bei falschem Massstab rutschen beschworene
 * Adds zufaellig auf irgendwelche Vorlagen und zaehlen mit. Bei Rubinquell
 * bekam die falsche Abbildung so 50 Punkte und die richtige 42 - obwohl die
 * richtige 62 von 65 Gegnern in Reichweite gebracht haette.
 *
 * Der Massstab ist auf beiden Achsen derselbe. Das ist keine Vereinfachung,
 * sondern eine Bedingung: eine Karte spiegelt nicht eine Achse allein. Ohne
 * sie kam bei einem Stockwerk ein Massstab von -0,078 gegen 0,0162 heraus -
 * eine Anpassung, die rechnerisch passte und geometrisch unmoeglich war.
 */
function abbildungSuchen(instanzen, kloneJeNpc, toleranz = 45, eng = 25) {
  const paare = []
  for (const e of instanzen) {
    for (const k of kloneJeNpc.get(e.npcId) ?? []) paare.push({ e, k })
  }
  if (paare.length < 2) return null

  const kandidaten = []
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
      kandidaten.push({ ...kandidat, ...bewerten(kandidat, instanzen, kloneJeNpc, toleranz) })
    }
  }
  if (!kandidaten.length) return null

  // Die aussichtsreichsten Anfaenge, nach Massstab entdoppelt. Tausende
  // Kandidaten unterscheiden sich nur in der vierten Stelle; entscheidend
  // sind die wenigen wirklich verschiedenen Massstaebe.
  kandidaten.sort((a, b) => b.treffer - a.treffer || a.summe - b.summe)
  const anfaenge = []
  const gesehen = new Set()
  for (const k of kandidaten) {
    const schluessel = k.s.toFixed(4)
    if (gesehen.has(schluessel)) continue
    gesehen.add(schluessel)
    anfaenge.push(k)
    if (anfaenge.length >= 12) break
  }

  let beste = null
  for (const anfang of anfaenge) {
    let abb = anfang
    // Nachjustieren: an den Treffern noch einmal rechnen, dann erneut
    // zuordnen. Zwei Punkte legen eine Abbildung fest, aber sie tragen auch
    // ihren eigenen Messfehler hinein; ueber dreissig Treffer mittelt er sich
    // weg.
    for (let runde = 0; runde < 3; runde += 1) {
      const zuordnung = zuordnen(abb, instanzen, kloneJeNpc, toleranz)
      if (zuordnung.length < 4) break
      const verfeinert = ausgleichen(zuordnung)
      if (!verfeinert) break
      const locker = bewerten(verfeinert, instanzen, kloneJeNpc, toleranz)
      if (locker.treffer < abb.treffer) break
      abb = { ...verfeinert, ...locker }
    }

    // Ausgewaehlt wird streng. Das ist der Punkt, an dem sich eine richtige
    // Abbildung von einer bloss plausiblen trennt: mit falschem Massstab
    // rutschen beschworene Adds zufaellig auf irgendwelche Vorlagen und
    // zaehlen bei weiter Toleranz als Treffer. Bei Rubinquell bekam die
    // falsche Abbildung so 50 Punkte und die richtige 42 - und die richtige
    // haette 62 von 65 Gegnern in Reichweite gebracht. Eng gemessen dreht
    // sich das um: was nur zufaellig passt, passt nicht auf 25 Punkte genau.
    //
    // Bei Gleichstand entscheidet die lockere Zaehlung. Ein Stockwerk mit
    // zwoelf Instanzen bringt kaum genug enge Treffer, um zu unterscheiden -
    // dort zaehlt wieder, wer insgesamt mehr erklaert.
    const streng = bewerten(abb, instanzen, kloneJeNpc, eng)
    const punkte = [streng.treffer, abb.treffer, -streng.summe]
    if (!beste || besser(punkte, beste.punkte)) beste = { ...abb, streng, punkte }
  }

  return beste ? { ...beste, ...bewerten(beste, instanzen, kloneJeNpc, toleranz) } : null
}

/** Vergleicht zwei Bewertungen der Reihe nach: erst enge Treffer, dann lockere. */
function besser(a, b) {
  for (let i = 0; i < a.length; i += 1) {
    if (a[i] !== b[i]) return a[i] > b[i]
  }
  return false
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
function vergeben(abb, instanzen, kloneJeNpc, toleranz, erlaubt = null) {
  const kandidaten = []
  for (const e of instanzen) {
    const x = abb.s * e.x + abb.dx
    const y = abb.s * e.y + abb.dy
    for (const k of kloneJeNpc.get(e.npcId) ?? []) {
      if (erlaubt && !erlaubt(e, k)) continue
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


// ------------------------------------------------- Gegner, die verschwinden

/**
 * Gegner, die nicht sterben, sondern sich aufloesen - und die Leiche, an der
 * man sie trotzdem erkennt.
 *
 * Das ganze Verfahren haengt an Todesereignissen: platziert wird, wer gefallen
 * ist. Manche Gegner fallen aber nie. Geister verschwinden, wenn sie besiegt
 * sind; die statischen Anomalien in Tempel von Sethraliss verwandeln sich in
 * eine Kugel; der Avatar von Sethraliss wird geheilt statt getoetet. Fuer
 * keinen von ihnen gibt es irgendwo ein Todesereignis - nicht bei
 * Warcraftlogs, nicht bei Raider.IO, nicht im rohen Protokoll.
 *
 * keystone.guru loest das ueber Nachbarn: jeder dieser Gegner hat einen, der
 * regulaer stirbt, und dessen Tod belegt ihn mit. Die Zuordnungen stehen
 * offen in deren Quelltext (RaiderIO/keystone.guru, Builders/Rules) und sind
 * hier uebernommen, nicht nachempfunden.
 *
 * Gemessen fehlten dadurch in Koenigsruh der dritte Boss, ein Pflicht-Trashpull
 * und der Endboss; in Tempel von Sethraliss sechs Anomalien und der Avatar.
 */
/**
 * Der blendende Hain: die Bruecke und der Weg darunter.
 *
 * Beide liegen bei fast denselben Koordinaten - die Bruecke oben, der Weg
 * darunter - und sie teilen sich dieselben Gegnerarten. Eine Hoehenachse gibt
 * es nicht, also kann keine Geometrie der Welt sie auseinanderhalten.
 *
 * Getrennt werden sie allein durch den Ablauf: die Gruppe geht ueber die
 * Bruecke zu Ikuzz, und erst wenn Lichtwaechterin Ruia liegt, darunter
 * hindurch zu Ziekket. Vorher existieren die Gegner unter der Bruecke fuer
 * die Route nicht, nachher die auf ihr nicht mehr.
 *
 * Ausgeschlossen wird, nicht bevorzugt. keystone.guru merkt dazu an, dass
 * eine Bevorzugung den Abstand ueberstimmt und damit richtige Zuordnungen
 * kaputtmacht: ein Kill genau auf einem Gegner unter der Bruecke landete auf
 * einem fuenfzehn Meter entfernten oben. Wer die Nichtexistierenden entfernt,
 * statt die anderen vorzuziehen, hat diesen Fehlerfall nicht.
 *
 * Die Schluessel sind npcID-Klon und stammen unveraendert aus deren
 * TheBlindingValeBridgeRule; nachgeprueft liegen sie in MDTs Gruppen 44 bis 46
 * beziehungsweise 47 bis 50 und 54.
 */
const BRUECKE = {
  wache: 245912,
  oben: new Set([
    '245339-11', '245339-12', '245345-25', '254850-10',
    '245410-90', '245410-91', '245410-92', '245410-93', '245410-94',
    '245346-5', '245473-9', '245484-16',
  ]),
  unten: new Set([
    '245410-107', '245410-108', '245410-109', '245410-110', '245410-111',
    '245345-28', '245410-112', '245410-113',
    '245346-6',
    '245336-1', '245339-1', '245345-26', '245345-27',
    '245410-104', '245410-105', '245410-106',
    '245345-10', '245410-15', '245410-16', '245410-17', '245410-18', '245410-19',
    // Die Lichtfeder-Bluetenfluegel, die MDT je nach Kartenstand gruppiert
    // oder nicht.
    '245484-5', '245484-6', '245484-7',
  ]),
}

const VERSCHWINDER = {
  "King's Rest": [
    // Der Rat der Stämme sind drei Geister. Von Zanazals Totems bekommen wir
    // Tode - das erste gefallene Totem belegt die anderen beiden gleich mit,
    // damit der Kampf in einem Pull landet statt in zweien.
    {
      ausloeser: [135761, 135764, 135765],
      verleiht: [135761, 135764, 135765, 269808, 269810, 269811],
    },
    // Der Schatten Zuls, ueber einen Diener Zuls aus seinem eigenen Pack -
    // aber erst, wenn der Rat liegt. Vorher ist die Gruppe nicht in seiner
    // Naehe, und ein frueher Trashkill duerfte ihn nicht belegen.
    //
    // 138493 ist der Diener aus seinem Pack; die gleichnamigen 133943 aus den
    // fruehen Packs sind ausdruecklich nicht gemeint.
    { ausloeser: [138493], verleiht: [138489], erst: [269808, 269810, 269811] },
    // Koenig Dazar und T'zala ueber Reban, das letzte Add vor dem Kampf. Der
    // Schatten steht mit in der Liste: wer bis hierher kam, ist an ihm vorbei.
    { ausloeser: [136984], verleiht: [138489, 136976, 136160] },
  ],
  'Temple of Sethraliss': [
    // Galvazzt erscheint erst, wenn alle Anomalien weg sind - sein Tod ist
    // also der Beleg fuer sie alle. Er traegt zwei Kennungen ueber die
    // Kartenstaende hinweg, beide gelten.
    { ausloeser: [133389, 263658], verleiht: [134691] },
    // Der Avatar wird gesundgepflegt, nicht erschlagen. Nur der Umstand, dass
    // der Lauf zu Ende ging, belegt ihn - also der letzte Tod ueberhaupt.
    { amEnde: true, verleiht: [133392] },
  ],
}


// ----------------------------------------------------------------- Bauen

/**
 * Baut aus Ereignissen und Pulls die Route in MDTs Sprache.
 *
 * Alles Netz liegt davor, alles Messen dahinter - dazwischen ist es reine
 * Rechnerei ueber Zahlen, die schon da sind. Deshalb laesst sich das gegen
 * echte Routen halten, ohne Warcraftlogs noch einmal zu fragen.
 */
export function routeBauen({ kampf, schaden, tode, zauber, leben, dungeon, kloneJeNpc, ...e }) {
  // Lebensverlauf je Gegner, falls vorhanden: "npcId:instanz" -> [[t, anteil]]
  const verlauf = new Map(leben ?? [])
  // Wo stand jede Instanz, als ihr Kampf begann?
  const ort = new Map()
  for (const ereignis of schaden) {
    if (ereignis.x === undefined || ereignis.y === undefined) continue
    const key = ereignis.npcId + ':' + ereignis.instanz
    if (!ort.has(key)) ort.set(key, ereignis)
  }

  // Wann geriet ein Gegner in den Kampf?
  //
  // Der frueheste Treffer, den er einsteckt - und nur der. Nicht der erste,
  // der zufaellig auch Koordinaten trug.
  //
  // Drei andere Quellen wurden probiert und sind alle wieder draussen:
  //
  //   Sein erster ausgeteilter Schlag: aendert an sechzehn Vergleichsrouten
  //   keinen einzigen Punkt. Gegner werden getroffen, bevor sie zurueckschlagen.
  //
  //   Sein erstes Bedrohungsereignis: ebenso wirkungslos.
  //
  //   Sein erster Zauber: schaedlich. Ein Gegner wirkt auch, bevor jemand ihn
  //   anfasst, und der frueh gesetzte Zeitpunkt wirft die Reihenfolge der
  //   Packs durcheinander. Mordgasse fiel dadurch von 93 auf 61, das Mittel
  //   ueber alle sechzehn von 91 auf 87. Als Ortsquelle bleiben die Zauber
  //   trotzdem - dort sind sie unverzichtbar.
  const frueh = new Map()
  for (const liste of [schaden]) {
    for (const ereignis of liste) {
      const key = ereignis.npcId + ':' + ereignis.instanz
      if (!frueh.has(key) || ereignis.t < frueh.get(key)) frueh.set(key, ereignis.t)
    }
  }

  // Zweite Quelle fuer die, die aus dem Schaden keinen Ort mitbekamen.
  //
  // Es gibt solche Gegner: in Koenigsruh sterben siebzehn "Diener Zuls", ohne
  // dass ein einziger ihrer erlittenen Treffer Koordinaten traegt. Sie fehlten
  // damit in jeder Route dieses Dungeons - deshalb lagen dessen neun Laeufe
  // alle bei 81 bis 89 Prozent, waehrend der Rest bei 98 liegt.
  //
  // Ihre eigenen Zauber tragen den Ort. Die Seite kostet zwei Punkte. Der
  // Schaden bleibt trotzdem die erste Wahl: ein Zauber kommt oft spaeter als
  // der erste Treffer, und der Zeitpunkt entscheidet mit ueber die Pull-Grenzen.
  for (const ereignis of zauber ?? []) {
    if (ereignis.x === undefined || ereignis.y === undefined) continue
    const key = ereignis.npcId + ':' + ereignis.instanz
    if (!ort.has(key)) ort.set(key, ereignis)
  }
  const gestorben = new Set(tode.map((x) => x.npcId + ':' + x.instanz))
  const todesZeit = new Map()
  for (const x of tode) {
    const key = x.npcId + ':' + x.instanz
    if (!todesZeit.has(key) || x.t < todesZeit.get(key)) todesZeit.set(key, x.t)
  }

  // ---- Abbildung je Stockwerk
  const abbildungen = new Map()
  for (const mapID of [...new Set([...ort.values()].map((x) => x.mapID))]) {
    const hier = [...ort.values()].filter((x) => x.mapID === mapID)
    const abb = abbildungSuchen(hier, kloneJeNpc, e.fit ?? 45, e.eng ?? 25)
    if (abb) abbildungen.set(mapID, { ...abb, instanzen: hier.length })
  }

  // ---- Zuordnung, nach Karten getrennt und nur fuer Gestorbene
  //
  // Im blendenden Hain haengt daran, wann ein Gegner beruehrt wurde: vor
  // Ruias Tod existieren die unter der Bruecke noch nicht, danach die auf ihr
  // nicht mehr.
  const ruiaTot = dungeon.englishName === 'The Blinding Vale'
    ? [...todesZeit.entries()].filter(([k]) => Number(k.split(':')[0]) === BRUECKE.wache)
      .reduce((a, [, zeit]) => Math.min(a, zeit), Infinity)
    : Infinity

  const erlaubt = Number.isFinite(ruiaTot)
    ? (instanz, klon) => {
      const schluessel = klon.npcId + '-' + klon.clone
      const vorher = (frueh.get(instanz.npcId + ':' + instanz.instanz) ?? instanz.t) < ruiaTot
      return vorher ? !BRUECKE.unten.has(schluessel) : !BRUECKE.oben.has(schluessel)
    }
    : null

  const zugeteilt = new Map()
  for (const [mapID, abb] of abbildungen) {
    const hier = [...ort.values()].filter((x) => x.mapID === mapID &&
      gestorben.has(x.npcId + ':' + x.instanz))
    for (const t of vergeben(abb, hier, kloneJeNpc, e.toleranz ?? 60, erlaubt)) {
      zugeteilt.set(t.e.npcId + ':' + t.e.instanz, t.k)
    }
  }

  // ---- Pulls, zunaechst als blosse Klonlisten
  const rohPulls = []

  // Jeder Gegner gehoert in genau einen Pull. Die Instanzbereiche der Pulls
  // ueberschneiden sich naemlich: kommt dieselbe Gegnerart in mehreren Pulls
  // vor, nennen beide einen Bereich, der die anderen Instanzen mit
  // einschliesst. Wer das uebersieht, zaehlt Gegner mehrfach - und landet bei
  // 117 Prozent, obwohl nur zwei Klone falsch sind.
  const vergebeneInstanzen = new Set()

  // Und jeder Klon nur an einen Gegner. Die geometrische Zuordnung achtet
  // schon darauf; der Eindeutigkeitsgriff weiter unten braucht die Liste,
  // um ihr nicht dazwischenzufunken.
  const belegteKlone = new Set([...zugeteilt.values()].map((k) => k.enemy + ':' + k.clone))

  // Warcraftlogs fasst Chainpulls zusammen: wer weiterzieht, ohne aus dem
  // Kampf zu fallen, bekommt dort einen einzigen Pull. keystone.guru trennt
  // sie - und wer eine Route liest, will diese Trennung, denn sie sagt, wo
  // man anhaelt.
  //
  // Innerhalb eines groben Pulls verraet der Erstkontakt die Grenze: ein Pack
  // wird auf einen Schlag angegriffen, das naechste Sekunden spaeter. Geteilt
  // wird nur innerhalb - so kann nichts falsch zusammengelegt werden, was
  // Warcraftlogs richtig getrennt hat.
  //
  // 45 Sekunden, an drei echten Routen abgetastet. Der Wert ist eine Kante,
  // keine Spitze: darunter zerfaellt ein Pull in seine Wellen, darueber
  // verschmelzen benachbarte Packs. Gemessene Guete der Einteilung 81/95/88,
  // im Mittel 88 gegen 87 bei 40 und 83 bei 50 Sekunden.
  //
  // Drei Routen sind wenig, um eine Zahl festzuzurren - wer mehr hat, sollte
  // nachmessen, statt ihr zu vertrauen.
  const kette = e.kette ?? 0.30

  // Alle beruehrten Gegner in einer Folge, nicht je Warcraftlogs-Pull.
  //
  // Warcraftlogs teilt den Lauf selbst in Pulls, und lange habe ich innerhalb
  // dieser Grenzen getrennt. Das setzt an jeder ihrer Grenzen eine eigene,
  // ungeprueft: faellt eine Gruppe kurz aus dem Kampf und pullt sofort weiter,
  // trennt Warcraftlogs, keystone.guru aber nicht.
  //
  // Deren Bauer kennt diese Grenzen gar nicht. Er arbeitet die Anpullungen in
  // einer durchgehenden Folge ab und entscheidet allein am Kampfzustand. Genau
  // das wird hier nachgebaut - die Warcraftlogs-Pulls liefern nur noch, welche
  // Gegner ueberhaupt zum Lauf gehoeren.
  const alleMitglieder = []
  for (const p of kampf.dungeonPulls ?? []) {
    for (const n of p.enemyNPCs ?? []) {
      const von = n.minimumInstanceID ?? 1
      const bis = n.maximumInstanceID ?? von
      for (let inst = von; inst <= bis; inst += 1) {
        const schluessel = n.gameID + ':' + inst
        if (vergebeneInstanzen.has(schluessel)) continue

        let klon = zugeteilt.get(schluessel)

        // Wo es nur eine Moeglichkeit gibt, braucht es keine Geometrie.
        //
        // Kennt MDT zu dieser Gegnerart genau eine Vorlage, ist sie noch frei,
        // und ist der Gegner gestorben - dann ist er diese Vorlage. Es gibt
        // keine andere.
        //
        // Ohne das haengen solche Gegner an der Toleranzgrenze. In Der
        // blendende Hain kippte eine "Potatoad Matriarch" aus der Route, weil
        // eine zusaetzliche Ortsangabe den Massstab um drei Promille verschob -
        // und mit ihr sechzig Kraefte, ein Elftel des Dungeons.
        if (!klon && gestorben.has(schluessel)) {
          const nurEine = (kloneJeNpc.get(n.gameID) ?? []).length === 1
          const einzige = (kloneJeNpc.get(n.gameID) ?? [])[0]
          // Und nur, wenn der Gegner Kraefte gibt oder ein Boss ist. Wer null
          // zaehlt und kein Boss ist, ist ein beschworenes Add - die stehen in
          // keiner Route, und sie hereinzuholen bringt nicht einmal Prozente.
          // In Altar der Reisszaehne war das ein "Hatchling".
          //
          // Bosse geben ebenfalls null Kraefte, gehoeren aber in jede Route.
          // Ohne die Ausnahme fehlten in Tempel von Sethraliss Adderis, Aspix,
          // Merektha, Galvazzt und der Avatar - eine Route ohne ihre Bosse
          // sieht in MDT aus wie ein Fehler, und sie ist auch einer.
          if (nurEine && (einzige.count > 0 || einzige.boss) &&
              !belegteKlone.has(einzige.enemy + ':' + einzige.clone)) klon = einzige
        }

        if (!klon) continue
        belegteKlone.add(klon.enemy + ':' + klon.clone)
        vergebeneInstanzen.add(schluessel)
        alleMitglieder.push({
          klon,
          schluessel,
          t: frueh.get(schluessel) ?? ort.get(schluessel)?.t ?? p.startTime,
          tod: todesZeit.get(schluessel),
        })
      }
    }
  }

  // Die Gegner der Reihe nach, wie sie beruehrt wurden.
  //
  // keystone.guru ordnet einzelne Gegner zu, nicht Packs. Ich hatte zunaechst
  // zu Packs gebuendelt, weil in den echten Routen ein Pack fast immer in
  // genau einem Pull liegt - nachgemessen 510 von 534. Fast immer ist aber
  // nicht immer: in Rubinquell verteilt eine Route ein Pack ueber drei Pulls,
  // und gebuendelt ist das unerreichbar.
  //
  // Beides gemessen hielt sich die Waage - gebuendelt gewann eine
  // Rubinquell-Route und verlor zwei, ungebuendelt umgekehrt. Deshalb der
  // Mittelweg: die Folge laeuft ueber einzelne Gegner, aber ein Pack, das
  // gerade im Kampf ist, wird nicht mittendrin getrennt. Es kann nur zerfallen,
  // wenn zwischendurch etwas anderes den Pull beendet hat.
  const reihe = alleMitglieder.slice().sort((a, b) => a.t - b.t)

  const anteilLeben = (m, zeit) => {
    const tod = m.tod
    if (tod !== undefined && zeit >= tod) return 0
    const messwerte = verlauf.get(m.schluessel)
    if (messwerte && messwerte.length) {
      let wert = null
      for (const [zp, anteil] of messwerte) {
        if (zp > zeit) break
        wert = anteil
      }
      return wert === null ? 1 : wert
    }
    if (tod === undefined) return 1
    const spanne = tod - m.t
    if (spanne <= 0) return 0
    return Math.max(0, Math.min(1, (tod - zeit) / spanne))
  }

  // Getrennt wird wie bei keystone.guru: ein neuer Pull beginnt, wenn der
  // laufende abgeschlossen ist - alles daran Beteiligte tot - oder wenn beim
  // Anpullen des naechsten Gegners die Lebenspunkte der laufenden Gruppe im
  // Mittel bei hoechstens 30 Prozent stehen. Tote zaehlen dabei mit null im
  // Zaehler und voll im Nenner, genau wie in deren getAverageHPPercentAt.
  let gruppe = []
  const abschliessen = () => {
    if (!gruppe.length) return
    rohPulls.push(gruppe.map((m) => m.klon))
    gruppe = []
  }
  for (const m of reihe) {
    const schonDa = m.klon.g !== undefined &&
      gruppe.some((x) => x.klon.g === m.klon.g)
    if (gruppe.length && !schonDa) {
      const alleTot = gruppe.every((x) => x.tod !== undefined && x.tod <= m.t)
      const leben = gruppe.reduce((s, x) => s + anteilLeben(x, m.t), 0) / gruppe.length
      if (alleTot || leben <= kette) abschliessen()
    }
    gruppe.push(m)
  }
  abschliessen()

  // ---- Gegner nachtragen, die sich aufgeloest haben
  //
  // Erst hier, nachdem die Pulls stehen: der verliehene Gegner gehoert in den
  // Pull dessen, der ihn belegt.
  const regeln = VERSCHWINDER[dungeon.englishName] ?? []
  let verliehen = 0

  if (regeln.length) {
    const wo = new Map()
    for (const [i, liste] of rohPulls.entries()) {
      for (const k of liste) wo.set(k.enemy + ':' + k.clone, i)
    }
    const belegt = (npc) => (kloneJeNpc.get(npc) ?? []).some((k) => wo.has(k.enemy + ':' + k.clone))

    const eintragen = (npcIds, ziel) => {
      for (const npc of npcIds) {
        for (const k of kloneJeNpc.get(npc) ?? []) {
          const schluessel = k.enemy + ':' + k.clone
          if (wo.has(schluessel)) continue
          rohPulls[ziel].push(k)
          wo.set(schluessel, ziel)
          verliehen += 1
        }
      }
    }

    // Die Tode der Reihe nach - eine Regel gilt ab dem Moment, in dem ihr
    // Ausloeser faellt, und nur wenn ihre Vorbedingung schon erfuellt ist.
    const reihenfolge = [...todesZeit.entries()]
      .map(([schluessel, zeit]) => ({ npc: Number(schluessel.split(':')[0]), schluessel, zeit }))
      .sort((a, b) => a.zeit - b.zeit)

    for (const tod of reihenfolge) {
      for (const regel of regeln) {
        if (regel.amEnde || !regel.ausloeser.includes(tod.npc)) continue
        if (regel.erst && !regel.erst.every(belegt)) continue
        const klon = zugeteilt.get(tod.schluessel)
        const ziel = klon ? wo.get(klon.enemy + ':' + klon.clone) : undefined
        if (ziel === undefined) continue
        eintragen(regel.verleiht, ziel)
      }
    }

    // Was das blosse Ende des Laufs belegt, kommt in den letzten Pull.
    for (const regel of regeln) {
      if (!regel.amEnde || !rohPulls.length) continue
      eintragen(regel.verleiht, rohPulls.length - 1)
    }
  }

  // ---- Packs vervollstaendigen
  //
  // MDT kennt zu jedem Klon eine Packnummer g. Wer eines dieser Geschwister
  // pullt, pullt alle - sie stehen beieinander und ziehen mit. Die echten
  // Routen bestaetigen das: von 35 Packs in Rubinquell sind 30 vollstaendig
  // drin und keines halb, bei Altar der Reisszaehne 35 von 36.
  //
  // Fuer mich ist das die Rettung der fehlenden Gegner. Wenn Warcraftlogs mir
  // zwei von drei Feuerbeschwoerern liefert, fehlt der dritte nicht, weil er
  // nicht gepullt wurde, sondern weil er zu weit von seiner Vorlage stand oder
  // sein Treffer ohne Ort ankam. Sein Pack sagt mir, wo er hingehoert.
  //
  // Ergaenzt wird aber nur gegen Beleg. Der Beleg ist eine Leiche: im Bericht
  // muss eine Instanz derselben Gegnerart gestorben sein, die ich nirgends
  // unterbringen konnte. Dann fehlt der Klon wirklich nur an der Geometrie.
  //
  // Ohne diese Bedingung erfindet die Ergaenzung. Mordgasse hat Packs aus
  // sieben beschworenen Schergen, von denen einer gepullt wird - vervollstaen-
  // digt kam die Route auf 109 Prozent der Kraefte. Mit Beleg bleibt sie
  // darunter, denn beschworene Adds, die nie kamen, sind auch nie gestorben.
  const packAnteil = Number(e.pack ?? 0.34)
  let ergaenzt = 0

  if (packAnteil > 0) {
    // Gestorben, aber keinem Klon zugeteilt - je Gegnerart ein Vorrat.
    const uebrig = new Map()
    for (const schluessel of gestorben) {
      if (zugeteilt.has(schluessel)) continue
      const npc = Number(schluessel.split(':')[0])
      uebrig.set(npc, (uebrig.get(npc) ?? 0) + 1)
    }
    const packKlone = new Map()
    for (const liste of kloneJeNpc.values()) {
      for (const k of liste) {
        if (k.g === undefined) continue
        if (!packKlone.has(k.g)) packKlone.set(k.g, [])
        packKlone.get(k.g).push(k)
      }
    }

    const wo = new Map()
    for (const [i, liste] of rohPulls.entries()) {
      for (const k of liste) wo.set(k.enemy + ':' + k.clone, i)
    }

    for (const klone of packKlone.values()) {
      const drin = klone.filter((k) => wo.has(k.enemy + ':' + k.clone))
      if (!drin.length || drin.length === klone.length) continue
      if (drin.length / klone.length < packAnteil) continue

      // In den Pull, in dem das Pack ohnehin ueberwiegend steht.
      const zaehler = new Map()
      for (const k of drin) {
        const i = wo.get(k.enemy + ':' + k.clone)
        zaehler.set(i, (zaehler.get(i) ?? 0) + 1)
      }
      const ziel = [...zaehler.entries()].sort((a, b) => b[1] - a[1])[0][0]

      for (const k of klone) {
        if (wo.has(k.enemy + ':' + k.clone)) continue
        if (!(uebrig.get(k.npcId) > 0)) continue
        uebrig.set(k.npcId, uebrig.get(k.npcId) - 1)
        rohPulls[ziel].push(k)
        wo.set(k.enemy + ':' + k.clone, ziel)
        ergaenzt += 1
      }
    }
  }


  // ---- In MDTs Sprache
  const pulls = []
  let kraefte = 0
  let gegnerZahl = 0
  for (const liste of rohPulls) {
    const eintraege = new Map()
    for (const klon of liste) {
      if (!eintraege.has(klon.enemy)) eintraege.set(klon.enemy, [])
      eintraege.get(klon.enemy).push(klon.clone)
      kraefte += klon.count ?? 0
      gegnerZahl += 1
    }
    pulls.push({ enemies: [...eintraege.entries()].map(([enemy, clones]) => ({ enemy, clones })) })
  }

  return {
    pulls, kraefte, gegnerZahl, ergaenzt, abbildungen,
    orte: ort.size, tote: gestorben.size, verliehen,
  }
}

// ----------------------------------------------------------- Kommandozeile
//
// Nur, wenn diese Datei selbst aufgerufen wird. Als Modul eingebunden bleibt
// sie stumm - der Sammler baut hundert Routen und will keine hundert Berichte.

if (process.argv[1] && process.argv[1].endsWith('wcl-route.mjs')) {
  const args = {}
  for (let i = 2; i < process.argv.length; i += 1) {
    if (!process.argv[i].startsWith('--')) continue
    const next = process.argv[i + 1]
    args[process.argv[i].slice(2)] =
      next === undefined || next.startsWith('--') ? true : process.argv[++i]
  }

  if (!args.mdt || !args.report) {
    console.error('Aufruf: node tools/wcl-route.mjs --mdt <MDT-Pfad> --report <Code> --fight <Nr>')
    process.exit(1)
  }

  const code = String(args.report)
  const cacheDir = String(args.cache ?? 'data/cache/wcl')
  mkdirSync(cacheDir, { recursive: true })

  // Traege anmelden: liegt alles im Zwischenspeicher, braucht es kein Netz.
  let gql = null
  const zugang = async () => (gql = gql ?? await anmelden())

  const bericht = await berichtHolen(await zugang(), code, cacheDir)
  const kampf = args.fight !== undefined
    ? bericht.fights.find((f) => f.id === Number(args.fight))
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

  const schaden = await ereignisseHolen(await zugang(), code, kampf, aktoren, cacheDir, 'DamageTaken')
  const tode = await ereignisseHolen(await zugang(), code, kampf, aktoren, cacheDir, 'Deaths')
  const zauber = await ereignisseHolen(await zugang(), code, kampf, aktoren, cacheDir, 'Casts')
  const lebenDatei = join(cacheDir, code + '-' + kampf.id + '-Leben.json')
  const leben = existsSync(lebenDatei) ? JSON.parse(readFileSync(lebenDatei, 'utf8')) : null

  const { dungeons } = readDungeons(String(args.mdt))
  const lookup = buildLookup(dungeons)
  const name = String(args.dungeon ?? kampf.name).toLowerCase()
  const dungeon = lookup.byName.get(name)
  if (!dungeon) {
    console.error('Dungeon "' + name + '" nicht in MDT. Mit --dungeon den englischen Namen angeben.')
    process.exit(1)
  }

  const gebaut = routeBauen({
    kampf, schaden, tode, zauber, leben, dungeon, kloneJeNpc: kloneOrdnen(dungeon),
    fit: args.fit !== undefined ? Number(args.fit) : undefined,
    eng: args.eng !== undefined ? Number(args.eng) : undefined,
    toleranz: args.toleranz !== undefined ? Number(args.toleranz) : undefined,
    split: args.split !== undefined ? Number(args.split) : undefined,
    pack: args.pack !== undefined ? Number(args.pack) : undefined,
  })
  const { pulls, kraefte, gegnerZahl, ergaenzt, abbildungen } = gebaut

  console.log('Ereignisse: ' + schaden.length + ', Instanzen mit Ort: ' + gebaut.orte +
    ', gestorben: ' + gebaut.tote)
  for (const [mapID, abb] of abbildungen) {
    console.log('Karte ' + String(mapID) + ': ' + String(abb.instanzen).padStart(3) +
      ' Instanzen, Massstab ' + abb.s.toFixed(5) +
      ', erklaert ' + abb.treffer + ' (Abstand im Mittel ' +
      Math.round(abb.summe / Math.max(1, abb.treffer)) + ')')
  }

  const anteil = Math.round(kraefte / dungeon.totalCount * 1000) / 10
  console.log('')
  console.log('Route: ' + pulls.length + ' Pulls, ' + gegnerZahl + ' Gegner' +
    (ergaenzt ? ' (davon ' + ergaenzt + ' aus dem Pack ergaenzt)' : '') + ', ' +
    kraefte + ' von ' + dungeon.totalCount + ' Kraeften (' + anteil + '%)')

  if (args.out) {
    writeFileSync(String(args.out), JSON.stringify({
      report: code, fight: kampf.id,
      dungeon: dungeon.englishName,
      challengeModeId: dungeon.challengeModeId,
      keyLevel: kampf.keystoneLevel,
      clearSeconds: dauer,
      enemyForces: kraefte,
      enemyForcesRequired: dungeon.totalCount,
      pulls,
    }, null, 2) + '\n')
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

    // Die Einteilung paarweise messen, nicht ueber Pull-Nummern: wer 19 Pulls
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
    if (args.zeige) {
      const namen = new Map((dungeon.enemies ?? []).map((e) => [e.index, e.name]))
      const zeig = (k) => k + ' ' + String(namen.get(Number(k.split(':')[0])) ?? '?').slice(0, 18)
      console.log('    falsch:        ' + [...B.keys()].filter((k) => !A.has(k)).map(zeig).join(' | '))
      console.log('    fehlend:       ' + [...A.keys()].filter((k) => !B.has(k)).map(zeig).join(' | '))
    }
    console.log('  Einteilung:      ' +
      Math.round(genauigkeit * 100) + '% der von mir zusammengelegten gehoeren zusammen, ' +
      Math.round(vollstaendig * 100) + '% der zusammengehoerigen habe ich zusammen  (Guete ' +
      Math.round(guete * 100) + ')')
  }
}
