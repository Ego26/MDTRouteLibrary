// Liest MDTs eigenen Exportstring.
//
// Format laut MythicDungeonTools/Modules/Transmission.lua:
//
//   "!~MDT2~" .. EncodeBase64(CompressString(SerializeCBOR(preset), Deflate))
//
// Serialisiert wird das ganze Preset - genau die Tabelle, mit der auch
// Core/Submit.lua arbeitet:
//
//   { text = "Name", difficulty = 18, uid = "...",
//     value = { currentDungeonIdx = 161, currentSublevel = 1, pulls = { ... } },
//     objects = { ... } }
//
// Warum ueberhaupt: wer eine Route in MDT gebaut hat, hat diesen String mit
// zwei Klicks. Ihn abzulehnen und auf `/routes submit` zu verweisen, kostet
// ehrliche Leute Zeit und haelt niemanden auf, der eine fremde Route
// einreichen will - der importiert sie in MDT und tippt eben den Befehl.
//
// Was dabei fehlt, gegenueber unserem eigenen Blob:
//
//   * Der Autor. MDT legt ihn nicht ins Preset. Der Sammler traegt ohnehin den
//     GitHub-Namen des Einreichenden ein, insofern kein Verlust.
//   * Der englische Dungeonname. Der String nennt nur MDTs Index, und der ist
//     keine stabile Kennung - er verschiebt sich, wenn MDT Dungeons ergaenzt
//     oder umsortiert. Aufgeloest wird er deshalb hier, gegen genau die
//     MDT-Quellen, mit denen auch gebaut wird.

import { decode } from './cbor.mjs'
import { texts } from './submission-texts.mjs'

export const MDT_PREFIX = '!~MDT2~'

/**
 * Entpackt einen MDT-Exportstring zum Preset.
 *
 * @param {string} text
 * @param {(raw: Buffer) => string|Buffer} inflate Entpacker aus parse-submission.mjs
 * @param {'de'|'en'} [lang]
 * @returns {object} MDT-Preset
 */
export function decodeMdtPreset(text, inflate, lang = 'en') {
  const t = texts(lang)
  const trimmed = String(text ?? '').trim().replace(/\s+/g, '')
  if (!trimmed.startsWith(MDT_PREFIX)) throw new Error(t.decodeWrongPrefix(MDT_PREFIX))

  const raw = Buffer.from(trimmed.slice(MDT_PREFIX.length), 'base64')
  if (raw.length === 0) throw new Error(t.decodeEmpty)

  let preset
  try {
    preset = decode(inflate(raw))
  } catch {
    throw new Error(t.decodeUnpackFailed)
  }

  if (!preset || typeof preset !== 'object' || typeof preset.value !== 'object') {
    throw new Error(t.decodeMdtNoPreset)
  }
  return preset
}

/**
 * Bringt MDTs Pull-Tabelle in dieselbe Form, die Core/Submit.lua schreibt.
 *
 * MDT legt je Pull `{ color = "rrggbb", [gegnerIndex] = { klonIndex, ... } }`
 * ab. Aus CBOR kommen die Zahlenschluessel als Zeichenketten zurueck, deshalb
 * wird hier gefiltert statt blind ueber alle Schluessel zu laufen: "color",
 * "enemyForces" und was MDT sonst noch dazulegt, sind keine Gegner.
 *
 * @param {object|Array} pulls
 * @returns {Array<{color?: string, enemies: Array<{enemy:number, clones:number[]}>}>}
 */
export function normalizePulls(pulls) {
  const list = Array.isArray(pulls) ? pulls.map((p, i) => [i + 1, p]) : Object.entries(pulls ?? {})

  const out = []
  // Nach Pull-Nummer sortieren, nicht nach Einfuegereihenfolge: alte Presets
  // koennen Luecken haben, und ein Objekt gibt Zahlenschluessel nicht
  // zwangslaeufig in der richtigen Ordnung zurueck.
  for (const [key, pull] of list.sort((a, b) => Number(a[0]) - Number(b[0]))) {
    if (!Number.isFinite(Number(key)) || !pull || typeof pull !== 'object') continue

    const enemies = []
    for (const [enemyKey, clones] of Object.entries(pull)) {
      const enemy = Number(enemyKey)
      if (!Number.isInteger(enemy) || enemy < 1) continue
      if (!Array.isArray(clones) && typeof clones !== 'object') continue

      const numbers = (Array.isArray(clones) ? clones : Object.values(clones))
        .map(Number)
        .filter((n) => Number.isInteger(n) && n > 0)
        .sort((a, b) => a - b)

      if (numbers.length > 0) enemies.push({ enemy, clones: numbers })
    }

    if (enemies.length > 0) {
      enemies.sort((a, b) => a.enemy - b.enemy)
      out.push({ color: typeof pull.color === 'string' ? pull.color : undefined, enemies })
    }
  }

  return out
}

/**
 * Macht aus einem MDT-Preset dieselbe Nutzlast, die decodeBlob() liefert.
 *
 * Damit laeuft alles Weitere - toRoute(), die Aufnahmekriterien, der
 * Fingerabdruck - unveraendert weiter, gleich woher die Route kam.
 *
 * @param {object} preset
 * @param {object} lookup Ergebnis von buildLookup()
 * @param {'de'|'en'} [lang]
 * @returns {object} Nutzlast in der Form von Core/Submit.lua
 */
export function presetToPayload(preset, lookup, lang = 'en') {
  const t = texts(lang)

  const index = Number(preset.value?.currentDungeonIdx)
  const dungeon = Number.isFinite(index) ? lookup.byMdtIndex?.get(index) : null
  if (!dungeon) throw new Error(t.decodeMdtUnknownDungeon(Number.isFinite(index) ? index : '?'))

  const pulls = normalizePulls(preset.value?.pulls)
  if (pulls.length === 0) throw new Error(t.decodeNoPulls)

  return {
    format: 1,
    addon: 'mdt-string',
    createdAt: null,
    dungeon: {
      mdtIndex: dungeon.mdtIndex,
      englishName: dungeon.englishName,
    },
    // MDT legt keinen Autor ins Preset. Der Sammler setzt ohnehin den
    // GitHub-Namen des Einreichenden ein.
    author: { character: null },
    route: {
      title: typeof preset.text === 'string' ? preset.text : null,
      keyLevel: typeof preset.difficulty === 'number' ? preset.difficulty : null,
      sublevel: Number(preset.value?.currentSublevel) || 1,
      pulls,
    },
  }
}
