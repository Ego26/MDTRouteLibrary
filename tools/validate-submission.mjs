// Alle Aufnahmekriterien fuer eine Einreichung an einer Stelle.
//
// Warum eigene Datei: parse-submission.mjs beantwortet "laesst sich das
// dekodieren?", hier steht "wollen wir das haben?". Das erste ist ein
// Formatproblem, das zweite eine Entscheidung - und die soll nachlesbar an
// einem Ort stehen, nicht verstreut im Sammler.
//
// Der Prueflauf ersetzt die manuelle Freigabe. Deshalb gilt: was hier nicht
// abgefangen wird, landet ungesehen im Spiel jedes Nutzers. Im Zweifel
// ablehnen und den Einreichenden nachbessern lassen - das Issue bleibt offen,
// eine Aenderung loest die Pruefung erneut aus.

import { KINDS, readField, normalizeKind, hasRightsConfirmation, texts } from './submission-texts.mjs'

// Weitergereicht, damit Aufrufer nicht zwei Module einbinden muessen.
export { hasRightsConfirmation }

/** Kanonische Werte des Auswahlfelds "Art der Route". */
export const ROUTE_KINDS = Object.keys(KINDS)

export const LIMITS = {
  titleMin: 3,
  titleMax: 60,
  notesMax: 600,
  keyMin: 2,
  keyMax: 30,
}

/**
 * Macht aus beliebigem Nutzertext etwas, das gefahrlos in eine Lua-Datei und
 * ins Spiel darf.
 *
 * generate-lua.mjs escapt Backslash, Anfuehrungszeichen und Zeilenumbrueche -
 * einschleusen laesst sich damit nichts. Steuerzeichen escapt es aber nicht,
 * und ein Nullbyte im Quelltext bricht den Lua-Parser fuer *alle* Nutzer.
 * Deshalb fliegen sie hier raus, bevor sie ueberhaupt in die Route kommen.
 *
 * @param {unknown} value
 * @param {number} max
 * @returns {string}
 */
export function sanitizeText(value, max) {
  if (typeof value !== 'string') return ''

  let out = 0
  let text = ''
  for (const ch of value) {
    out = ch.codePointAt(0)
    text += isInvisible(out) ? ' ' : ch
  }

  return text.split(' ').filter(Boolean).join(' ').slice(0, max)
}

/**
 * Zeichen, die im Spiel nichts verloren haben.
 *
 * Steuerzeichen brechen den Lua-Parser - ein Nullbyte im Quelltext des
 * Datenaddons macht die Datei fuer *alle* Nutzer unlesbar. Die unsichtbaren
 * Trennzeichen daneben sind der uebliche Weg, einen harmlos aussehenden
 * Namen mit verstecktem Inhalt zu unterlegen oder die Leserichtung zu
 * drehen. Beides gehoert weg, bevor es in eine Route kommt.
 *
 * @param {number} code
 * @returns {boolean}
 */
function isInvisible(code) {
  return (
    code <= 0x1f ||                        // C0, inklusive Nullbyte
    (code >= 0x7f && code <= 0x9f) ||      // DEL und C1
    (code >= 0x200b && code <= 0x200f) ||  // Breitenlos, LRM/RLM
    code === 0x2028 || code === 0x2029 ||  // Zeilen- und Absatztrenner
    (code >= 0x202a && code <= 0x202e) ||  // Richtungsumkehr
    (code >= 0x2066 && code <= 0x2069) ||  // Richtungsisolate
    code === 0xa0 ||                       // geschuetztes Leerzeichen
    (code >= 0x2000 && code <= 0x200a) ||  // typografische Leerzeichen
    code === 0x3000 ||                     // ideografisches Leerzeichen
    code === 0xfeff                        // Byte-Order-Mark
  )
}

/**
 * Liest eine Stufenangabe wie "+18", "18", "egal" oder "any".
 *
 * @param {string|undefined} value
 * @returns {number|null} null bedeutet "egal", nicht "ungueltig"
 */
export function parseLevel(value) {
  const text = (value ?? '').trim()
  if (!text || /^(egal|any)$/i.test(text)) return null
  const match = /^\+?(\d+)$/.exec(text)
  return match ? Number(match[1]) : Number.NaN
}

/**
 * Entscheidet, ob eine Einreichung aufgenommen wird.
 *
 * @param {object} options
 * @param {object} options.route         Ergebnis von toRoute()
 * @param {Record<string,string>} options.fields  Ergebnis von parseIssueForm()
 * @param {{name?: string, dungeonIndices?: Set<number>}} [options.season]
 * @param {'de'|'en'} [options.lang]     Sprache der benutzten Issue-Vorlage
 * @returns {{ ok: boolean, errors: string[], warnings: string[], patch: object }}
 *   `patch` sind die bereinigten Werte, die bei ok auf die Route gehoeren.
 */
export function validateSubmission({ route, fields = {}, season, lang = 'en' } = {}) {
  const t = texts(lang)
  const errors = []
  const warnings = []
  const patch = {}

  // ---- 1. Gegnerkraefte -------------------------------------------------
  // Die harte Regel: unter 100 Prozent laesst sich der Schluessel mit der
  // Route nicht abschliessen. So eine Route hilft niemandem, egal wie sauber
  // sie sonst ist.
  const required = route.enemyForcesRequired
  if (!required) {
    warnings.push(t.noTotalForces)
  } else if (route.enemyForces < required) {
    const percent = ((route.enemyForces / required) * 100).toFixed(1)
    errors.push(t.belowFull(percent, route.enemyForces, required))
  }

  // ---- 2. Dungeon der laufenden Season ----------------------------------
  // Der Dungeon kommt aus dem Blob, nicht aus einem Auswahlfeld: MDT weiss,
  // welche Karte offen war, der Einreichende koennte sich verklicken.
  const indices = season?.dungeonIndices
  if (indices && indices.size > 0 && !indices.has(route.mdtDungeonIdx)) {
    errors.push(t.wrongSeason(route.dungeonEnglishName, season.name))
  }

  // ---- 3. Name ----------------------------------------------------------
  // Das Formularfeld hat Vorrang vor dem Namen aus MDT: der Einreichende sieht
  // das Formular vor sich, den Blob nicht.
  const given = readField(fields, 'title')
  const title = sanitizeText(given || route.title, LIMITS.titleMax)
  if (title.length < LIMITS.titleMin) {
    errors.push(t.titleTooShort(LIMITS.titleMin))
  } else {
    patch.title = title
    if (title !== (given ?? route.title ?? '').trim()) warnings.push(t.titleTrimmed(title))
  }

  // ---- 4. Schluesselstufen ----------------------------------------------
  let min = parseLevel(readField(fields, 'levelMin'))
  let max = parseLevel(readField(fields, 'levelMax'))

  if (Number.isNaN(min) || Number.isNaN(max)) {
    errors.push(t.levelsUnreadable)
  } else {
    // Vertauscht angegeben? Stillschweigend drehen statt abweisen.
    if (min != null && max != null && min > max) [min, max] = [max, min]

    for (const [which, value] of [['min', min], ['max', max]]) {
      if (value != null && (value < LIMITS.keyMin || value > LIMITS.keyMax)) {
        errors.push(t.levelOutOfRange(which, value, LIMITS.keyMin, LIMITS.keyMax))
      }
    }
    if (min != null) patch.keyLevelMin = min
    if (max != null) patch.keyLevelMax = max
  }

  // ---- 5. Art der Route -------------------------------------------------
  // Beide Vorlagen bieten dieselben vier Moeglichkeiten unter verschiedenen
  // Woertern an; gespeichert wird der kanonische Wert.
  const given_kind = sanitizeText(readField(fields, 'kind'), 60)
  const kind = normalizeKind(given_kind)
  if (!given_kind) {
    errors.push(t.kindMissing)
  } else if (!kind) {
    errors.push(t.kindUnknown(given_kind))
  } else {
    patch.kind = kind
  }

  // ---- 6. Rechtezusage --------------------------------------------------
  // GitHub erzwingt das Haekchen nur in der Formularmaske. Ein Issue ueber die
  // API umgeht die Vorlage vollstaendig, deshalb hier serverseitig nachsehen.
  if (!hasRightsConfirmation(readField(fields, 'rights'))) errors.push(t.rightsMissing)

  // ---- 7. Anmerkungen ---------------------------------------------------
  const notes = sanitizeText(readField(fields, 'notes'), LIMITS.notesMax)
  if (notes) patch.notes = notes

  // ---- Hinweise, die nicht ablehnen -------------------------------------
  if (route.pulls.length < 3) warnings.push(t.fewPulls(route.pulls.length))

  return { ok: errors.length === 0, errors, warnings, patch }
}
