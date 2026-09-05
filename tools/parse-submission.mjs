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

const PREFIX = 'mdtrl1:'

/**
 * Entpackt die Nutzlast. Faellt der Reihe nach auf andere Deflate-Varianten
 * und zuletzt auf unkomprimierten Text zurueck.
 *
 * @param {Buffer} raw
 * @returns {string}
 */
function decompress(raw) {
  for (const fn of [inflateSync, inflateRawSync, gunzipSync]) {
    try {
      return fn(raw).toString('utf8')
    } catch {
      // naechste Variante
    }
  }
  const text = raw.toString('utf8')
  if (text.trimStart().startsWith('{')) return text
  throw new Error('Nutzlast liess sich nicht entpacken')
}

/**
 * Dekodiert einen Einreich-Blob.
 *
 * @param {string} blob
 * @returns {object} Nutzlast aus Core/Submit.lua
 */
export function decodeBlob(blob) {
  const trimmed = blob.trim().replace(/\s+/g, '')
  if (!trimmed.startsWith(PREFIX)) {
    throw new Error(`Blob beginnt nicht mit "${PREFIX}" - vermutlich der falsche Text kopiert`)
  }

  const raw = Buffer.from(trimmed.slice(PREFIX.length), 'base64')
  if (raw.length === 0) throw new Error('Blob ist leer')

  const payload = JSON.parse(decompress(raw))
  if (payload.format !== 1) throw new Error(`Unbekannte Formatversion: ${payload.format}`)
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
 * @returns {{ route: object, warnings: string[] }}
 */
export function toRoute(payload, lookup) {
  const warnings = []
  const name = payload.dungeon?.englishName
  if (!name) throw new Error('Einreichung nennt keinen Dungeon')

  const dungeon = lookup.byName.get(name.toLowerCase())
  if (!dungeon) throw new Error(`Dungeon unbekannt: ${name}`)

  const byIndex = new Map(dungeon.enemies.map((e) => [e.index, e]))
  let forces = 0

  const pulls = []
  for (const pull of payload.route?.pulls ?? []) {
    const enemies = []
    for (const entry of pull.enemies ?? []) {
      const enemy = byIndex.get(entry.enemy)
      if (!enemy) {
        warnings.push(`Gegnerindex ${entry.enemy} gibt es in ${name} nicht - uebersprungen`)
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
        warnings.push(`Klon ${entry.enemy}/${c} gibt es nicht - uebersprungen`)
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

  if (pulls.length === 0) throw new Error('Nach der Pruefung bleibt kein gueltiger Pull uebrig')

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
    warnings.push(`Route erreicht nur ${forces} von ${dungeon.totalCount} noetigen Gegnerkraeften`)
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

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
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
  const { route, warnings } = toRoute(decodeBlob(found[0]), buildLookup(dungeons))

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
