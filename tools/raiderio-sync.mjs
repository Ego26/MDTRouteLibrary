// Holt die Top-Laeufe von Raider.IO als Verweise.
//
// Nicht als Routen: die API protokolliert, welche Gegner wann gefallen sind -
// nicht, welcher von neun gleichnamigen es war und wo ein Pull endete. Beides
// liess sich nur schaetzen, und eine Route, die ungefaehr stimmt, schickt ihre
// Nutzer an die falsche Stelle. Die echte Route liegt bei keystone.guru, und
// die Antwort nennt ihren Schluessel (logged_details.route_key) - darauf
// verweist jeder Eintrag.
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

import { mkdirSync, writeFileSync, readFileSync, existsSync } from 'node:fs'
import { join, dirname } from 'node:path'
import { fileURLToPath, pathToFileURL } from 'node:url'
import { readDungeons, readSeasons } from './mdt-dungeons.mjs'

const BASE = 'https://raider.io/api/v1/mythic-plus'

/** Ohne Kennung ruft niemand gern etwas ab. */
const USER_AGENT = 'MDTRouteLibrary (https://github.com/Ego26/MDTRouteLibrary)'

/**
 * Der Zugangsschluessel.
 *
 * In der CI steht er als Secret in der Umgebung. Auf einem Entwicklerrechner
 * ist das unpraktisch: eine Zuweisung in der eigenen Shell erbt kein Prozess,
 * der aus einem anderen Fenster gestartet wird. Deshalb zusaetzlich aus .env
 * im Wurzelverzeichnis - die Datei steht in .gitignore und geht nirgendwo hin.
 *
 * @returns {string|null}
 */
function apiKey() {
  if (process.env.RAIDERIO_API_KEY) return process.env.RAIDERIO_API_KEY

  const file = join(dirname(fileURLToPath(import.meta.url)), '..', '.env')
  if (!existsSync(file)) return null

  // Zeilenenden vereinheitlichen und eine Bytefolgemarkierung abschneiden.
  // PowerShell schreibt CRLF und mit -Encoding utf8 ausserdem eine BOM; das
  // "\r" am Zeilenende liess den Anker "$" ins Leere laufen, und der
  // Schluessel galt als nicht vorhanden. Auffaellig wurde das erst daran, dass
  // die Suche bei Seite 128 abbrach - der ersten Zweierpotenz oberhalb von
  // 100, dem Seitenlimit fuer unangemeldete Abfragen.
  const text = readFileSync(file, 'utf8').replace(/^﻿/, '').replace(/\r\n?/g, '\n')

  for (const line of text.split('\n')) {
    const match = line.match(/^\s*RAIDERIO_API_KEY\s*=\s*(.*)$/)
    if (match) return match[1].trim().replace(/^["']|["']$/g, '') || null
  }
  return null
}

const API_KEY = apiKey()


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
  if (API_KEY) url.searchParams.set('access_key', API_KEY)

  for (let attempt = 1; attempt <= 4; attempt += 1) {
    const response = await fetch(url, { headers: { 'User-Agent': USER_AGENT } })

    if (response.status === 429) {
      // Warten, was sie sagen - nicht, was uns passt.
      const wait = Number(response.headers.get('retry-after')) || attempt * 5
      console.warn(`   Ratenbegrenzung, warte ${wait}s`)
      await new Promise((done) => setTimeout(done, wait * 1000))
      continue
    }

    // Ein 502 oder 504 ist der Server, nicht die Anfrage. Beim ersten Versuch
    // aufzugeben hiesse, wegen eines Schluckaufs einen ganzen Dungeon ohne
    // Routen zu lassen - und genau das soll der Abbruch weiter unten ja
    // verhindern.
    if (response.status >= 500 && attempt < 4) {
      const wait = attempt * 3
      console.warn(`   ${response.status} vom Server, neuer Versuch in ${wait}s`)
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

/** Kurzform der Gruppe: Spezialisierung und Klasse je Mitglied. */
function roster(run) {
  return (run.roster ?? []).map((member) => {
    const c = member.character ?? {}
    return {
      // Der Name steht auf raider.io oeffentlich neben dem Lauf. Ihn
      // wegzulassen waere die schlechtere Wahl: wer eine Route zeigt,
      // soll sagen, wer sie gelaufen ist.
      name: c.name ?? null,
      // Realm und Region stehen genauso oeffentlich daneben. Sie sind die
      // Adresse, unter der Warcraftlogs denselben Spieler fuehrt - und damit
      // der einzige Weg vom Ranglisteneintrag zum Bericht des Laufs. Aus der
      // Rangliste kommen sie nicht mit, nur aus den Laufdetails.
      realm: c.realm?.slug ?? null,
      realmRegion: c.region?.slug ?? null,
      class: c.class?.name ?? null,
      spec: c.spec?.name ?? null,
      // Zwei Stellen, weil zwei Antwortformen: die Rangliste legt die Rolle
      // neben den Charakter, die Laufdetails in die Spezialisierung. Wer nur
      // die zweite liest, haelt in der Rangliste jede Gruppe fuer tanklos.
      role: member.role ?? c.spec?.role ?? null,
    }
  })
}

/**
 * Holt die Top-Laeufe eines Dungeons und macht Routen daraus.
 *
 * @param {object} options
 * @returns {Promise<object[]>}
 */
/** Tank-Spezialisierung einer Gruppe, als Schluessel. */
function tankKey(members) {
  const tank = members.find((member) => member.role === 'tank')
  return tank && tank.spec ? tank.spec + ' ' + tank.class : '?'
}

/**
 * Blaettert die Rangliste eines Dungeons und merkt sich, was schon geholt ist.
 *
 * Die Rangliste ist nach Wertung geordnet, und die Wertung haengt zuerst an
 * der Schluesselstufe. Gleiche Stufen liegen deshalb als zusammenhaengender
 * Block beieinander, und die Stufe faellt mit dem Rang monoton. Genau das
 * macht die Binaersuche weiter unten moeglich.
 *
 * @param {object} options
 * @returns {{ page: (n:number)=>Promise<object[]|null>, count: ()=>number }}
 */
function rankingReader({ season, region, dungeonSlug }) {
  const cache = new Map()
  let calls = 0

  return {
    async page(n) {
      if (cache.has(n)) return cache.get(n)

      let rankings = null
      try {
        calls += 1
        const list = await api('/runs', { season, region, dungeon: dungeonSlug, page: n })
        rankings = list.rankings ?? []
      } catch (err) {
        // Jenseits des Seitenlimits antwortet die API mit 400. Ohne
        // Zugangsschluessel ist bei Seite 100 Schluss, mit einem geht es
        // weiter - wie weit, sagt sie nicht, also tasten wir uns heran.
        //
        // Alles andere ist ein echter Fehler und muss nach oben. Vorher
        // verschluckte dieses catch auch Netzaussetzer: ein Ruckler auf
        // Seite 0 sah aus wie "keine Seiten vorhanden", der Dungeon lieferte
        // null Laeufe, und im Protokoll stand nur sein Name. Genau so ist
        // Voidscar Arena einmal spurlos aus dem Datenpaket gefallen.
        if (!/^400\b/.test(err.message ?? '')) throw err
        rankings = null
      }

      cache.set(n, rankings)
      return rankings
    },
    count() {
      return calls
    },
  }
}

/** Hoechste Stufe auf einer Seite, oder null wenn es die Seite nicht gibt. */
async function topLevelOf(reader, page) {
  const rankings = await reader.page(page)
  if (!rankings || rankings.length === 0) return null
  return Math.max(...rankings.map((entry) => entry.run?.mythic_level ?? 0))
}

/**
 * Sucht die erste Seite, auf der eine Schluesselstufe auftaucht.
 *
 * Der Block einer Stufe kann sehr weit hinten liegen - die +18er eines
 * Dungeons fangen bei Rang 1050 an, die +2er stehen bei Rang 1,5 Millionen.
 * Sich dorthin durchzublaettern waere sinnlos; weil die Stufe mit dem Rang
 * monoton faellt, genuegt eine Binaersuche mit rund einem Dutzend Abfragen.
 *
 * @param {object} reader
 * @param {number} level
 * @param {number} maxPage
 * @returns {Promise<number|null>}
 */
async function findLevelStart(reader, level, maxPage) {
  // Erst eine Obergrenze finden: verdoppeln, bis die Seite unter die gesuchte
  // Stufe faellt oder es sie nicht mehr gibt.
  let hi = 1
  while (hi <= maxPage) {
    const top = await topLevelOf(reader, hi)
    if (top === null) break
    if (top <= level) break
    hi *= 2
  }
  hi = Math.min(hi, maxPage)
  if (process.env.RIO_DEBUG) console.log("       [suche] Stufe " + level + ": Obergrenze " + hi)

  let lo = 0
  let found = null

  while (lo <= hi) {
    const mid = Math.floor((lo + hi) / 2)
    const top = await topLevelOf(reader, mid)

    if (top === null) {
      // Seite jenseits des Limits - nach vorn ausweichen.
      hi = mid - 1
      continue
    }

    if (top <= level) {
      found = mid
      hi = mid - 1
    } else {
      lo = mid + 1
    }
  }

  return found
}

/**
 * In welchen Bereich faellt eine Schluesselstufe?
 *
 * Zwei, nicht zwoelf. Gemessen an Altar of Fangs aendert eine Stufe Abstand
 * an der Route nichts - +18 bis +21 liegen bei 30 Pulls und 3,2 Mobs je Pull,
 * und die Streuung innerhalb einer Stufe ist groesser als die zwischen
 * zweien. Der Abstand zwischen oben und unten dagegen ist deutlich: ein
 * Weltrang-1-Lauf faengt mit vier Mobs an, ein +12er mit elf, und ist dabei
 * sieben Minuten schneller. Wer unten spielt, laeuft eine andere Route -
 * wer zwei Stufen darueber spielt, nicht.
 *
 * @param {number} level
 * @param {number} highest
 * @param {number} lowTop Obergrenze des unteren Bereichs
 * @returns {string|null}
 */
function bracketOf(level, highest, lowTop) {
  if (level >= highest - 3) return 'high'
  if (level <= lowTop) return 'low'
  return 'mid'
}

/**
 * Sammelt Kandidaten: die Spitze der Rangliste und den Anfang jeder Stufe,
 * die in einen der beiden Bereiche faellt.
 *
 * @param {object} options
 * @returns {Promise<{ candidates: object[], reader: object, highest: number }>}
 */
async function collectCandidates({ season, region, dungeonSlug, minLevel, maxPage, topPages, lowTop, lowRegions }) {
  const reader = rankingReader({ season, region, dungeonSlug })
  const byId = new Map()

  const add = (entry, from, tier) => {
    const run = entry.run ?? {}
    const id = run.keystone_run_id
    if (!id || byId.has(id)) return
    if ((run.mythic_level ?? 0) < minLevel) return

    byId.set(id, {
      id,
      // Aus welcher Rangliste dieser Lauf stammt. Ein Rang aus tw ist
      // kein Weltrang, und das Addon darf ihn nicht als solchen zeigen.
      region: from,
      // Vorn oder hinten im Rangblock seiner Stufe - siehe gatherLevel().
      tier,
      rank: typeof entry.rank === 'number' ? entry.rank : undefined,
      level: run.mythic_level,
      // Die Zeit ist ueber Ranglisten hinweg vergleichbar, der Rang nicht.
      seconds: Math.round((run.clear_time_ms ?? 0) / 1000),
      // Schon in der Rangliste enthalten - die Auswahl kostet deshalb keine
      // einzige zusaetzliche Abfrage.
      roster: roster(run),
    })
  }

  // Die Spitze der Rangliste, und zwar grosszuegig. Nicht nur wegen der
  // schnellsten Zeiten: die seltenen Tank-Spezialisierungen tauchen erst
  // hier auf. In Altar of Fangs steht der erste Waechter-Druide auf Rang 28,
  // der erste Schutz-Krieger auf 107.
  for (let page = 0; page < topPages; page += 1) {
    const rankings = await reader.page(page)
    if (!rankings || rankings.length === 0) break
    for (const entry of rankings) add(entry, region, 'fast')
  }

  const highest = await topLevelOf(reader, 0)
  if (highest === null) return { candidates: [], reader, highest: 0 }

  /**
   * Sammelt eine Stufe aus einer bestimmten Rangliste.
   * @returns {Promise<number>} wie viele Eintraege gefunden wurden
   */
  /**
   * Sammelt eine Stufe aus einer Rangliste - vorn und aus der Mitte.
   *
   * Nur den Anfang zu nehmen hiesse: immer die schnellsten. Auf einer
   * Stufe gibt es aber beides, zuegige und vorsichtige Routen, und welche
   * davon die richtige ist, entscheidet nicht die Bestenliste, sondern
   * wer sie laeuft. Also nehmen wir aus beiden Enden des Blocks.
   *
   * Die Grenzen sind bekannt: der Block einer Stufe reicht von ihrem
   * Anfang bis zum Anfang der naechstniedrigeren.
   */
  const gatherLevel = async (from, useReader, level, spread) => {
    const startPage = await findLevelStart(useReader, level, maxPage)
    if (startPage === null) return 0

    const readFrom = async (first, tier, pages) => {
      let seen = 0
      for (let page = first; page < first + pages; page += 1) {
        const rankings = await useReader.page(page)
        if (!rankings || rankings.length === 0) break

        for (const entry of rankings) {
          if ((entry.run?.mythic_level ?? 0) !== level) continue
          add(entry, from, tier)
          seen += 1
        }
        if (seen >= 60) break
      }
      return seen
    }

    let seen = await readFrom(startPage, 'fast', spread ? 2 : 4)
    if (!spread || seen === 0) return seen

    // Wo endet der Block? Am Anfang der naechstniedrigeren Stufe. Findet
    // sich die nicht mehr, liegt das Ende jenseits unserer Reichweite -
    // dann genuegt ein fester Abstand.
    const nextStart = await findLevelStart(useReader, level - 1, maxPage)
    const end = nextStart === null ? startPage + 40 : nextStart
    const middle = Math.floor(startPage + (end - startPage) * 0.5)
    if (middle > startPage + 1) {
      seen += await readFrom(middle, 'slow', 2)
    }

    return seen
  }

  // Stufe fuer Stufe an ihren Anfang springen.
  //
  // Reicht die Weltrangliste nicht so tief, weichen wir auf eine kuerzere
  // aus. Der Grund ist die Laenge, nicht die Herkunft: bei Altar of Fangs
  // steht auf Seite 99 in der Welt noch +18, in eu +17, in us +16, in tw
  // und kr dagegen schon +12. Ohne Zugangsschluessel endet die API bei
  // Seite 100, und auch mit einem steht nirgends, wie weit sie geht.
  //
  // Fuer die Spitze waere das falsch - dort will man die schnellsten
  // Laeufe der Welt. Fuer einen +12er ist die Region gleichgueltig: der
  // Dungeon ist derselbe, und die Route, die eine Gruppe dort laeuft,
  // auch. Woher ein Lauf stammt, haelt der Kandidat trotzdem fest.
  const fallbacks = new Map()

  for (let level = highest - 1; level >= minLevel; level -= 1) {

    if ((await gatherLevel(region, reader, level, true)) > 0) continue

    // Aus allen, nicht aus der erstbesten. Mit Zugangsschluessel reicht us
    // bis +14 und eu bis +15, tw und kr bis +10 - wer nur die erste nimmt,
    // die etwas liefert, holt den ganzen unteren Bereich aus Taiwan. Dort
    // wird anders gespielt, und das waere dann die einzige Vorlage, die ein
    // Spieler auf +12 zu sehen bekommt.
    for (const other of lowRegions) {
      if (other === region) continue
      if (!fallbacks.has(other)) {
        fallbacks.set(other, rankingReader({ season, region: other, dungeonSlug }))
      }
      const got = await gatherLevel(other, fallbacks.get(other), level, true)
      if (process.env.RIO_DEBUG) console.log("     [debug] +" + level + " aus " + other + ": " + got)
    }
  }

  // Erst nach Stufe, dann nach Rang - und die Weltrangliste vor den
  // kuerzeren. Bloss nach Rang zu sortieren vermischte die Ranglisten: ein
  // tw-Rang 500 stuende dann vor einem Weltrang 1000, obwohl der Weltlauf
  // um Klassen besser ist.
  const candidates = [...byId.values()].sort((a, b) => {
    if (a.level !== b.level) return b.level - a.level
    return (a.seconds || Infinity) - (b.seconds || Infinity)
  })
  return { candidates, reader, highest }
}
/**
 * Holt die Laeufe eines Dungeons und macht Routen daraus.
 *
 * Die Auswahl folgt der Frage, die jemand tatsaechlich stellt: "Welche Route
 * laeuft eine Gruppe wie meine auf einem Schluessel wie meinem?" Also eine
 * Quote je Kombination aus Bereich und Tank-Spezialisierung, dazu die
 * schnellsten Laeufe ueberhaupt.
 *
 * Getrennte Quoten fuer Bereich und Tank waeren zu wenig: sie koennten von
 * derselben Handvoll Laeufe erfuellt werden und liessen den Waechter-Druiden
 * auf +12 trotzdem aus.
 *
 * Eine Detailabfrage faellt erst an, wenn ein Lauf eine Quote fuellt - die
 * Auswahl selbst laeuft auf den Ranglistenseiten, die Gruppe und Stufe schon
 * mitbringen.
 *
 * @param {object} options
 * @returns {Promise<object[]>}
 */
export async function fetchDungeonRuns({
  season,
  dungeonSlug,
  dungeon,
  minLevel,
  wanted,
  perCell = 2,
  lowTop = 14,
  maxPerLevel = 2,
  // Kuerzere Ranglisten fuer den unteren Bereich, in dieser Reihenfolge.
  lowRegions = ['us', 'eu', 'tw', 'kr'],
  maxRuns = 40,
  topPages = 15,
  maxPage = 4096,
  // Etwa jeder fuenfte Spitzenlauf hat eine veroeffentlichte Route. Der
  // Deckel muss also ein Vielfaches der gesuchten Laeufe sein, sonst
  // bricht die Suche ab, bevor die Felder gefuellt sind.
  maxDetails = 900,
  // Und zwar je Bereich, nicht insgesamt. Die Kandidaten stehen nach Stufe
  // absteigend; ein gemeinsamer Deckel gehoert am Ende den hohen Stufen,
  // und die niedrigen kommen nie dran. Gemessen: je eine Route auf +10 und
  // +12, keine auf +11 - und 31 auf +19.
  maxPerBracket = 300,
  // Nach so vielen vergeblichen Versuchen gilt ein Bereich als leer.
  // Bei 60 und einer Quote von drei Prozent liegt die Wahrscheinlichkeit,
  // trotzdem daneben zu greifen, bei einem Sechstel - zu viel, um daraus
  // "dort gibt es nichts" zu schliessen. Bei 150 sind es unter einem
  // Prozent. Das Budget je Bereich traegt das jetzt.
  emptyAfter = 150,
  // Wie viele Detailabfragen gleichzeitig unterwegs sein duerfen. Bei zehn
  // und einer Sekunde Antwortzeit sind das zehn Anfragen je Sekunde - der
  // Schluessel erlaubt gut sechzehn. Genug Abstand, dass ein langsamer
  // Moment nicht in die Ratenbegrenzung laeuft.
  lookahead = 10,
  region = 'world',
}) {
  const { candidates, reader, highest } = await collectCandidates({
    season,
    region,
    dungeonSlug,
    minLevel,
    maxPage,
    topPages,
    lowTop,
    lowRegions,
  })

  if (candidates.length === 0) return []

  const levelsSeen = candidates.map((c) => c.level)
  const poolByRegion = new Map()
  for (const c of candidates) poolByRegion.set(c.region, (poolByRegion.get(c.region) ?? 0) + 1)
  console.log("   Kandidatenpool: " + [...poolByRegion].map(([r, n]) => n + "x " + r).join(", "))
  console.log(
    '   ' + candidates.length + ' Kandidaten bis Rang ' +
      (candidates[candidates.length - 1].rank ?? 0) +
      ', Stufen +' + Math.min(...levelsSeen) + ' bis +' + Math.max(...levelsSeen) +
      ' (' + reader.count() + ' Ranglistenabfragen)'
  )

  // Die Quote zaehlt erst, wenn ein Lauf wirklich uebernommen wurde. Faellt
  // einer wegen fehlender Freigabe aus, rueckt der naechste nach, statt eine
  // Luecke zu hinterlassen.
  const out = []
  const cells = new Map()
  const levelSeen = new Map()
  let calls = 0
  let ohneRoute = 0
  // Versuche und Treffer je Bereich, um leere fruehzeitig zu verlassen.
  const tries = new Map()
  const hits = new Map()
  const givenUp = new Set()
  // Verbrauchtes Budget je Bereich.
  const spent = new Map()

  // Lohnt sich die Detailabfrage fuer diesen Kandidaten - nach dem Stand
  // von jetzt? Getrennt von der Schleife, weil der Vorausgriff dieselbe
  // Frage stellt, bevor er eine Anfrage losschickt.
  function plan(candidate) {
    const bracket = bracketOf(candidate.level, highest, lowTop)
    if (!bracket) return null

    // Ein Bereich, in dem nach vielen Versuchen keine einzige Route lag,
    // wird nicht weiter abgefragt. Die Kandidaten stehen nach Stufe
    // absteigend, also ist das kein Vorgriff: was danach kommt, ist
    // niedriger und damit noch unwahrscheinlicher.
    if (givenUp.has(bracket)) return null

    // Und keiner nimmt dem anderen sein Budget weg.
    if ((spent.get(bracket) ?? 0) >= maxPerBracket) return null

    // Ein Feld je Band, Tempo und Tank-Spezialisierung - das sind die drei
    // Fragen, die jemand stellt, der eine Route sucht. Die Stufe selbst steht
    // im Titel; sie zur vierten Achse zu machen hat beim Ausprobieren
    // Tempo und Tank verdraengt.
    const cell = bracket + ':' + (candidate.tier ?? 'fast') + ':' + tankKey(candidate.roster)
    const used = cells.get(cell) ?? 0

    // Deckel je Stufe und Tempo. Die Kandidaten stehen nach Stufe absteigend;
    // ohne ihn besetzten die hoechsten saemtliche Plaetze, bevor die naechste
    // an die Reihe kam - das obere Band bestand aus neun +21ern, das untere
    // ausschliesslich aus +14ern. Und ohne das Tempo im Schluessel fuellten
    // die schnellsten Laeufe einer Stufe den Deckel auf, weil die Kandidaten
    // nach Zeit sortiert stehen.
    //
    // Die mittleren Stufen bekommen die kleinste Quote. Zwischen benachbarten
    // Stufen ist kein Unterschied messbar - aber ganz auszulassen geht auch
    // nicht: wer auf +16 filtert und nichts findet, schliesst daraus, dass es
    // fuer seinen Schluessel keine Routen gibt. Eine je Stufe und Tempo
    // genuegt, damit keine Einstellung ins Leere laeuft.
    const levelCell = candidate.level + ':' + (candidate.tier ?? 'fast')
    const levelCap = bracket === 'mid' ? 1 : maxPerLevel
    if ((levelSeen.get(levelCell) ?? 0) >= levelCap) return null

    // Die schnellsten Laeufe insgesamt kommen immer mit, unabhaengig von
    // den Feldern - sie sind der Massstab, an dem alles andere haengt.
    if (out.length >= wanted && used >= perCell) return null

    return { bracket, cell, used, levelCell }
  }

  // Die laufenden Abfragen, nach Platz in der Kandidatenliste. Eine
  // abgewiesene Antwort wird sofort abgefangen und aufgehoben statt
  // geworfen: sonst meldet Node eine unbehandelte Ablehnung fuer eine
  // Anfrage, die vielleicht nie jemand abholt.
  const inFlight = new Map()
  // Tatsaechlich gestellte Anfragen. Weicht von calls ab, wenn der
  // Vorausgriff daneben lag - das ist der Preis des Verfahrens, und er
  // gehoert in den Bericht, nicht unter den Teppich.
  let sent = 0

  function prefetch(index) {
    if (index >= candidates.length || inFlight.has(index)) return
    if (!plan(candidates[index])) return
    sent += 1
    inFlight.set(
      index,
      api('/run-details', { season, id: candidates[index].id })
        .then((value) => ({ ok: true, value }))
        .catch((error) => ({ ok: false, error }))
    )
  }

  for (let index = 0; index < candidates.length; index += 1) {
    if (calls >= maxDetails || out.length >= maxRuns) break

    const candidate = candidates[index]
    const step = plan(candidate)
    if (!step) {
      // Vorab geholt und doch nicht gebraucht: die Antwort verfaellt,
      // aber der Platz in der Karte darf nicht liegenbleiben.
      inFlight.delete(index)
      continue
    }

    const { bracket, cell, used, levelCell } = step

    // Das Fenster auffuellen, bevor auf die eigene Antwort gewartet wird -
    // sonst waere der Vorausgriff wirkungslos.
    for (let ahead = index; ahead < index + lookahead; ahead += 1) prefetch(ahead)

    prefetch(index)
    const answer = await inFlight.get(index)
    inFlight.delete(index)
    if (!answer.ok) throw answer.error

    calls += 1
    spent.set(bracket, (spent.get(bracket) ?? 0) + 1)
    const details = answer.value
    const logged = details.logged_details ?? {}

    // Der Spieler hat widersprochen - dann endet es hier.
    if (logged.showing_route_authorized !== true) continue
    if (!Array.isArray(logged.enemies) || logged.enemies.length === 0) continue

    // Die Gegnerliste wird nur noch als Nachweis gelesen, dass der Lauf
    // ueberhaupt protokolliert ist. Was daraus fuer eine Route zu machen
    // waere, waere geraten - welcher von neun gleichnamigen Gegnern fiel und
    // wo ein Pull endete, steht dort nicht. Dafuer verweist der Eintrag auf
    // keystone.guru, wo die tatsaechlich gespielte Route liegt.

    // Und ohne diese Adresse ist der Eintrag wertlos: Stufe, Zeit und
    // Gruppe stehen auf raider.io besser. Vier von fuenf Spitzenlaeufen
    // haben keine veroeffentlichte Route - sie hier aussortieren statt
    // erst beim Bauen laesst den naechsten Kandidaten nachruecken,
    // genau wie bei fehlender Freigabe.
    tries.set(bracket, (tries.get(bracket) ?? 0) + 1)

    if (!logged.route_key) {
      ohneRoute += 1
      if ((tries.get(bracket) ?? 0) >= emptyAfter && !(hits.get(bracket) ?? 0)) {
        givenUp.add(bracket)
      }
      continue
    }

    hits.set(bracket, (hits.get(bracket) ?? 0) + 1)

    out.push({
      id: 'rio-' + candidate.id,
      source: 'raider.io',
      // Bedingung ihrer Nutzungsbedingungen, und das Mindeste: jede Route
      // zeigt, wo sie herkommt.
      url:
        'https://raider.io/mythic-plus-runs/' +
        season + '/' + candidate.id + '-' + details.mythic_level + '-' + details.dungeon.slug,
      // Aus unseren eigenen Daten, nicht aus der Antwort: Raider.IO nennt die
      // Kennung anders, und MDTs Katalog ist hier ohnehin massgeblich.
      challengeModeId: dungeon.challengeModeId,
      dungeonEnglishName: dungeon.englishName,
      mdtDungeonIdx: dungeon.mdtIndex,
      // Der Rang steht in der Rangliste, nicht in den Laufdetails - und
      // gilt nur fuer die, aus der er stammt.
      rank: candidate.rank,
      region: candidate.region,
      // Wofuer diese Route steht. Ohne das muesste der Nutzer aus Stufe und
      // Zeit selbst erschliessen, ob sie zu ihm passt.
      bracket,
      tier: candidate.tier ?? 'fast',
      keyLevel: details.mythic_level,
      clearSeconds: Math.round((details.clear_time_ms ?? 0) / 1000),
      // Auf die Millisekunde, nicht gerundet: so wird der Kampf im
      // Warcraftlogs-Bericht bestaetigt. Zwei Laeufe derselben Gruppe
      // unterscheiden sich darin immer.
      clearMs: details.clear_time_ms ?? null,
      // Wann er endete. Zusammen mit dem Kader findet das den Bericht:
      // wessen Bericht diesen Zeitpunkt umschliesst, ist der gesuchte.
      completedAt: details.completed_at ?? null,
      onTime: (details.num_chests ?? 0) > 0,
      roster: roster(details),
      // MDTs Soll, nicht das der API. Die beiden weichen ab: fuer Tempel von
      // Sethraliss nennt Raider.IO 649, MDT 687. Gegen 649 gemessen kaemen
      // die Laeufe auf 106 Prozent, gegen 687 auf 99,7 bis 100,7 - und das
      // ist der Bereich, in dem ein abgeschlossener Schluessel liegt. Das
      // Addon sitzt ausserdem in MDTs Fenster; eine Prozentzahl, die der
      // daneben widerspricht, waere in jedem Fall die falsche.
      enemyForcesRequired: dungeon.totalCount ?? logged.total_enemy_forces,
      // Der Schluessel der echten Route bei keystone.guru. Raider.IO bettet
      // deren Ansicht ein, und beide Seiten teilen sich diese Kennung -
      // keystone.guru/route/<dungeon>/<key> loest damit auf.
      //
      // Er ist die Bruecke zur tatsaechlich gespielten Route: was wir hier
      // rekonstruieren, ist bestenfalls nah dran. Sobald ein Zugang zu
      // keystone.guru vorliegt, holt tools/keystone-fetch.mjs damit die
      // echten Pulls statt sie zu erraten.
      routeKey: logged.route_key,
      // Die Adresse der echten Route. Raider.IO bettet keystone.gurus Ansicht
      // ein, beide teilen sich diese Kennung.
      keystoneUrl: `https://keystone.guru/route/${dungeonSlug}/${logged.route_key}`,
    })

    cells.set(cell, used + 1)
    levelSeen.set(levelCell, (levelSeen.get(levelCell) ?? 0) + 1)
  }

  const levels = new Map()
  for (const run of out) levels.set(run.keyLevel, (levels.get(run.keyLevel) ?? 0) + 1)

  console.log(
    '   ' + out.length + ' Laeufe aus ' + calls + ' Detailabfragen' +
      (sent > calls ? ' (' + sent + ' gestellt)' : '') +
      ' [' + [...spent.entries()].sort().map(([b, n]) => b + ' ' + n).join(', ') + ']' +
      ' (' + ohneRoute + ' ohne veroeffentlichte Route' +
      (givenUp.size ? ', ' + [...givenUp].join('/') + ' vorzeitig beendet' : '') + ')'
  )
  console.log(
    '     Stufen: ' +
      [...levels.entries()]
        .sort((a, b) => b[0] - a[0])
        .map(([level, n]) => n + 'x +' + level)
        .join(', ')
  )
  console.log(
    '     Felder: ' +
      [...cells.entries()]
        .sort()
        .map(([cell, n]) => cell + ' (' + n + ')')
        .join(', ')
  )

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

  const minLevel = Number(args['min-level'] ?? 10)
  const wanted = Number(args.runs ?? 5)
  const perCell = Number(args['per-cell'] ?? 2)
  const lowTop = Number(args['low-top'] ?? 14)
  const maxRuns = Number(args['max-runs'] ?? 40)
  // --lookahead 1 stellt die Anfragen wieder einzeln. Dient dem Vergleich:
  // parallel und sequenziell muessen dieselbe Auswahl liefern.
  const lookahead = Number(args.lookahead ?? 10)
  // Die Weltrangliste ist die richtige Quelle. --region dient dem Pruefen:
  // kleinere Regionen haben kuerzere Listen, dort liegen niedrige Stufen
  // auch ohne Zugangsschluessel in Reichweite.
  const region = typeof args.region === 'string' ? args.region : 'world'
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

  console.log(`Season ${season}: je Dungeon die besten ${wanted}, dazu ${perCell} je Tank-Spezialisierung` +
    ` in jedem der beiden Bereiche (High Keys, +${minLevel} bis +${lowTop}), höchstens ${maxRuns}`)
  if (!API_KEY) {
    console.log('Ohne Zugangsschlüssel - unangemeldet, also stärker begrenzt.')
    console.log('Setze RAIDERIO_API_KEY in der Umgebung oder in .env im Wurzelverzeichnis.')
  }

  mkdirSync(outDir, { recursive: true })
  let total = 0
  let failed = 0

  for (const target of targets) {
    console.log(`\n${target.dungeon.englishName} (${target.slug})`)
    try {
      const runs = await fetchDungeonRuns({
        season,
        dungeonSlug: target.slug,
        dungeon: target.dungeon,
        minLevel,
        wanted,
        perCell,
        lowTop,
        maxRuns,
        region,
        lookahead,
      })

      if (runs.length > 0) {
        const file = join(outDir, `${target.slug}.json`)

        // Schon gebaute Routen uebernehmen.
        //
        // Die Rangliste aendert sich taeglich nur an den Raendern; die meisten
        // Laeufe von gestern stehen morgen noch da. Wer die Datei blind neu
        // schreibt, wirft ihre Pulls weg - und tools/wcl-toproutes.mjs holt
        // dieselben Berichte jeden Tag noch einmal von Warcraftlogs. Das waere
        // eine Stunde Rechenzeit taeglich fuer ein Ergebnis, das sich nicht
        // geaendert hat.
        let alt = new Map()
        try {
          alt = new Map(JSON.parse(readFileSync(file, 'utf8')).map((r) => [r.id, r]))
        } catch {}

        let uebernommen = 0
        for (const run of runs) {
          const vorher = alt.get(run.id)
          if (!vorher?.pulls) continue
          run.wclReport = vorher.wclReport
          run.wclFight = vorher.wclFight
          run.pulls = vorher.pulls
          run.enemyForces = vorher.enemyForces
          uebernommen += 1
        }

        writeFileSync(file, `${JSON.stringify(runs, null, 2)}\n`)
        console.log(`   ${runs.length} Läufe -> ${file}` +
          (uebernommen ? ` (${uebernommen} Routen uebernommen)` : ''))
        total += runs.length
      } else {
        // Laut sein. Ein leeres Ergebnis heisst, dass dieser Dungeon im
        // Addon ohne Top-Routen dasteht - das darf nicht als Leerzeile
        // durchgehen.
        failed += 1
        console.warn('   ! keine Läufe - dieser Dungeon bleibt ohne Top-Routen')
      }
    } catch (err) {
      failed += 1
      console.warn(`   ! ${err.message}`)
    }
  }

  console.log(`\n${total} Läufe insgesamt.`)

  // Mit einem Exitcode ungleich null bricht der CI-Schritt ab, statt ein
  // Datenpaket zu bauen, in dem still ein Dungeon fehlt. Genau das war
  // passiert: ein Netzaussetzer, und Voidscar Arena stand ohne Top-Routen da,
  // ohne dass irgendwo eine Fehlermeldung aufgetaucht waere.
  if (failed > 0) {
    console.error(`${failed} von ${targets.length} Dungeons ohne Ergebnis.`)
    process.exit(1)
  }
}
