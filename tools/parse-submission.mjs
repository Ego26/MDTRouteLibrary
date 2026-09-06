// Liest einen Einreich-Blob aus dem Addon und macht eine normalisierte Route
// daraus.
//
// Der Blob entsteht in Core/Submit.lua: JSON, mit Deflate gepackt, Base64
// kodiert, mit dem Praefix "mdtrl1:". Welche Deflate-Variante Blizzards
// C_EncodingUtil genau ausgibt, ist nicht dokumentiert - deshalb probieren wir
// der Reihe nach zlib, raw deflate und gzip durch.
//
// Aufruf:
//   node tools/parse-submission.mjs --blob "mdtrl1:..." --mdt "<MDT-Pfad>"
//   node tools/parse-submission.mjs --file einreichung.txt --mdt "<MDT-Pfad>" --out data/routes

import { inflateSync, inflateRawSync, gunzipSync } from 'node:zlib'
import { createHash } from 'node:crypto'
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs'
import { join } from 'node:path'
import { pathToFileURL } from 'node:url'
import { readDungeons, buildLookup } from './mdt-dungeons.mjs'
import { texts } from './submission-texts.mjs'

const PREFIX = 'mdtrl1:'

// MDTs eigener Export-String (Core/Init.lua: ns.MDT_STRING_PREFIX). Wird hier
// nicht gelesen, aber erkannt - siehe decodeBlob().
const MDT_PREFIX = '!~MDT2~'

/**
 * Entpackt die Nutzlast. Faellt der Reihe nach auf andere Deflate-Varianten
 * und zuletzt auf unkomprimierten Text zurueck.
 *
 * @param {Buffer} raw
 * @param {object} t Textsatz aus submission-texts.mjs
 * @returns {string}
 */
function decompress(raw, t) {
  for (const fn of [inflateSync, inflateRawSync, gunzipSync]) {
    try {
      return fn(raw).toString('utf8')
    } catch {
      // naechste Variante
    }
  }
  const text = raw.toString('utf8')
  if (text.trimStart().startsWith('{')) return text
  throw new Error(t.decodeUnpackFailed)
}

/**
 * Dekodiert einen Einreich-Blob.
 *
 * Die Fehlertexte gehen unveraendert in den Kommentar am Issue - deshalb
 * kommen auch sie aus dem Textsatz und nicht als feste Zeichenkette.
 *
 * @param {string} blob
 * @param {'de'|'en'} [lang]
 * @returns {object} Nutzlast aus Core/Submit.lua
 */
export function decodeBlob(blob, lang = 'en') {
  const t = texts(lang)
  const trimmed = blob.trim().replace(/\s+/g, '')
  if (!trimmed.startsWith(PREFIX)) {
    // Der haeufigste Irrtum: der MDT-Export-String. MDT gibt ihn selbst aus,
    // keystone.guru auch - er sieht nach "dem String zur Route" aus, enthaelt
    // aber weder unsere Zusatzangaben noch ein Format, das hier gelesen wird.
    // Ein blosses "beginnt nicht mit mdtrl1:" hilft da niemandem weiter.
    if (trimmed.startsWith(MDT_PREFIX)) throw new Error(t.decodeMdtString)
    throw new Error(t.decodeWrongPrefix(PREFIX))
  }

  const raw = Buffer.from(trimmed.slice(PREFIX.length), 'base64')
  if (raw.length === 0) throw new Error(t.decodeEmpty)

  const payload = JSON.parse(decompress(raw, t))
  if (payload.format !== 1) throw new Error(t.decodeUnknownFormat(payload.format))
  return payload
}

/**
 * Reichert eine Einreichung mit NPC-IDs an und rechnet die Gegnerkraefte aus.
 *
 * Das Addon kann die NPC-IDs nicht mitliefern, weil MDT seine Gegnertabelle
 * nicht nach aussen gibt. Hier haben wir die MDT-Quellen und holen das nach -
 * damit die Route auch dann noch stimmt, wenn MDT spaeter umnummeriert.
 *
 * @param {object} payload
 * @param {object} lookup Ergebnis von buildLookup()
 * @param {'de'|'en'} [lang] Sprache fuer die Hinweise an den Einreichenden
 * @returns {{ route: object, warnings: string[] }}
 */
export function toRoute(payload, lookup, lang = 'en') {
  const t = texts(lang)
  const warnings = []
  const name = payload.dungeon?.englishName
  if (!name) throw new Error(t.decodeNoDungeon)

  const dungeon = lookup.byName.get(name.toLowerCase())
  if (!dungeon) throw new Error(t.decodeUnknownDungeon(name))

  const byIndex = new Map(dungeon.enemies.map((e) => [e.index, e]))
  let forces = 0

  const pulls = []
  for (const pull of payload.route?.pulls ?? []) {
    const enemies = []
    for (const entry of pull.enemies ?? []) {
      const enemy = byIndex.get(entry.enemy)
      if (!enemy) {
        warnings.push(t.unknownEnemy(entry.enemy, name))
        continue
      }

      // Gegen die echten Schluessel pruefen, nicht gegen 1..Anzahl: MDTs
      // Klontabellen haben Luecken. Gegner 3 in Den of Nalorakk etwa hat
      // 21 Klone, aber die Nummern laufen bis 23 - eine Pruefung auf
      // "kleiner gleich Anzahl" verwirft die letzten beiden und rechnet die
      // Route damit unter 100 Prozent.
      const known = new Set(enemy.cloneKeys ?? [])
      const clones = (entry.clones ?? []).filter((c) => {
        if (known.has(c)) return true
        warnings.push(t.unknownClone(entry.enemy, c))
        return false
      })
      if (clones.length === 0) continue

      forces += enemy.count * clones.length
      enemies.push({ enemy: entry.enemy, npc: enemy.id, clones })
    }

    if (enemies.length > 0) {
      pulls.push({ color: pull.color ?? undefined, enemies })
    }
  }

  if (pulls.length === 0) throw new Error(t.decodeNoPulls)

  // Stabile ID aus dem Inhalt: dieselbe Route zweimal eingereicht ergibt
  // dieselbe ID und wird nicht doppelt ausgeliefert.
  const fingerprint = createHash('sha256')
    .update(JSON.stringify({ d: dungeon.challengeModeId, p: pulls }))
    .digest('hex')
    .slice(0, 10)

  const route = {
    id: `sub-${fingerprint}`,
    source: 'community',
    title: payload.route?.title || 'Community-Route',
    author: payload.author?.character ?? null,
    url: null,
    challengeModeId: dungeon.challengeModeId,
    dungeonEnglishName: dungeon.englishName,
    mdtDungeonIdx: dungeon.mdtIndex,
    sublevel: payload.route?.sublevel ?? 1,
    enemyForces: forces,
    enemyForcesRequired: dungeon.totalCount,
    submittedAt: payload.createdAt ?? null,
    pulls,
  }

  if (dungeon.totalCount && forces < dungeon.totalCount) {
    warnings.push(t.belowRequired(forces, dungeon.totalCount))
  }

  return { route, warnings }
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

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const args = parseArgs(process.argv.slice(2))
  if (!args.mdt || (!args.blob && !args.file)) {
    console.error('Aufruf: node tools/parse-submission.mjs (--blob "..." | --file datei) --mdt "<MDT-Pfad>" [--out ordner]')
    process.exit(1)
  }

  const text = args.blob ?? readFileSync(args.file, 'utf8')

  // Aus einem GitHub-Issue-Text die Blob-Zeile herausziehen.
  const found = /mdtrl1:[A-Za-z0-9+/=]+/.exec(text)
  if (!found) {
    console.error('Kein Blob gefunden. Erwartet wird eine Zeile, die mit mdtrl1: beginnt.')
    process.exit(1)
  }

  const { dungeons } = readDungeons(args.mdt)
  const { route, warnings } = toRoute(decodeBlob(found[0], 'de'), buildLookup(dungeons), 'de')

  for (const w of warnings) console.warn(`  ! ${w}`)
  console.log(`${route.id}  ${route.dungeonEnglishName}  "${route.title}"  ${route.pulls.length} Pulls  ${route.enemyForces} Kraefte`)

  if (args.out) {
    mkdirSync(args.out, { recursive: true })
    const file = join(args.out, `${route.id}.json`)
    writeFileSync(file, `${JSON.stringify(route, null, 2)}\n`)
    console.log(`geschrieben: ${file}`)
  } else {
    console.log(JSON.stringify(route, null, 2))
  }
}
