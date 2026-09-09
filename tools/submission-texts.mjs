// Beschriftungen und Rueckmeldungen der Einreichung in beiden Sprachen.
//
// Es gibt zwei Issue-Vorlagen, eine deutsche und eine englische. Die Pruefung
// liest die Formularfelder ueber ihre *Beschriftung* - GitHub schreibt die
// Feld-IDs nicht in den Issue-Text, nur "### <Beschriftung>". Damit haengt die
// ganze Pipeline an diesen Zeichenketten: benennt jemand ein Feld in der
// Vorlage um, ohne es hier nachzuziehen, faellt jede Einreichung durch, ohne
// dass irgendwo ein Fehler auftaucht. Deshalb stehen beide Saetze hier
// nebeneinander und nirgends sonst.
//
// Geantwortet wird in der Sprache der benutzten Vorlage. Eine deutsche
// Maengelliste unter einer englischen Einreichung ist so gut wie keine.

/** Kanonische Werte des Auswahlfelds "Art der Route", mit beiden Anzeigetexten. */
export const KINDS = {
  Meta: { de: 'Meta', en: 'Meta' },
  Beginner: { de: 'Einsteiger', en: 'Beginner' },
  Specialised: { de: 'Spezialisiert', en: 'Specialised' },
  Other: { de: 'Sonstiges', en: 'Other' },
}

/** Feldbeschriftungen der beiden Vorlagen. Muss zu den .yml-Dateien passen. */
export const FIELDS = {
  blob: { de: 'Einreichungs-Code', en: 'Submission code' },
  title: { de: 'Name der Route', en: 'Route name' },
  levelMin: { de: 'Schlüsselstufe ab', en: 'Key level from' },
  levelMax: { de: 'Schlüsselstufe bis', en: 'Key level to' },
  kind: { de: 'Art der Route', en: 'Route type' },
  notes: { de: 'Anmerkungen', en: 'Notes' },
  rights: { de: 'Bestätigung', en: 'Confirmation' },
}

export const LANGUAGES = ['de', 'en']

/**
 * In welcher Sprache wurde eingereicht?
 *
 * Entschieden wird an den Feldbeschriftungen, nicht am Fliesstext: die
 * stammen aus der Vorlage und nicht aus dem, was jemand getippt hat. Bei
 * Gleichstand - etwa einem leeren Issue ganz ohne Vorlage - gewinnt Englisch,
 * weil das Addon international veroeffentlicht ist.
 *
 * @param {Record<string,string>} fields Ergebnis von parseIssueForm()
 * @returns {'de'|'en'}
 */
export function detectLanguage(fields = {}) {
  const present = new Set(Object.keys(fields))
  let de = 0
  let en = 0
  for (const labels of Object.values(FIELDS)) {
    if (present.has(labels.de)) de += 1
    if (present.has(labels.en)) en += 1
  }
  return de > en ? 'de' : 'en'
}

/**
 * Liest ein Formularfeld, gleich unter welcher Beschriftung es steht.
 *
 * @param {Record<string,string>} fields
 * @param {keyof FIELDS} key
 * @returns {string|undefined}
 */
export function readField(fields = {}, key) {
  const labels = FIELDS[key]
  if (!labels) throw new Error(`Unbekanntes Feld: ${key}`)
  return fields[labels.de] ?? fields[labels.en]
}

/**
 * Bringt die gewaehlte Routenart auf ihren kanonischen Wert.
 *
 * Im Auswahlfeld steht hinter dem Wort eine Erklaerung in Klammern - die ist
 * Beiwerk und gehoert nicht in die Route.
 *
 * @param {string|undefined} value
 * @returns {string|null} kanonischer Schluessel aus KINDS, oder null
 */
export function normalizeKind(value) {
  const text = String(value ?? '').replace(/\s*\(.*$/, '').trim().toLowerCase()
  if (!text) return null
  for (const [canonical, labels] of Object.entries(KINDS)) {
    if (text === canonical.toLowerCase() || text === labels.de.toLowerCase() || text === labels.en.toLowerCase()) {
      return canonical
    }
  }
  return null
}

/**
 * Steht das Pflichthaekchen der Rechtezusage?
 *
 * GitHub rendert Checkboxen als "- [x] Beschriftung". Wer das Issue ueber die
 * API statt ueber das Formular anlegt, hat den Block gar nicht - dann fehlt
 * die Zusage, und das ist ein Ablehnungsgrund.
 *
 * @param {string|undefined} block
 * @returns {boolean}
 */
export function hasRightsConfirmation(block) {
  return /^\s*-\s*\[x\]\s*(Die Route ist von mir|The route is mine)/im.test(block ?? '')
}

/** Aufzaehlung der erlaubten Arten in der jeweiligen Sprache. */
function kindList(lang) {
  return Object.values(KINDS).map((k) => k[lang]).join(', ')
}

// ---------------------------------------------------------------- Texte
//
// Alles, was ein Einreichender zu lesen bekommt. Beide Sprachen stehen
// nebeneinander, damit beim Aendern nicht eine Haelfte vergessen wird.

export const TEXTS = {
  de: {
    // Pruefung
    noTotalForces: 'Für diesen Dungeon kennt MDT keine Gesamt-Gegnerkräfte – die 100-%-Prüfung entfällt.',
    belowFull: (percent, have, need) =>
      `Die Route erreicht nur **${percent} %** der Gegnerkräfte (${have} von ${need}). ` +
      'Aufgenommen werden nur Routen ab 100 %, weil sich der Schlüssel sonst nicht abschließen lässt.',
    wrongSeason: (dungeon, season) =>
      `**${dungeon}** gehört nicht zur laufenden Season${season ? ` (${season})` : ''}. ` +
      'Routen für vergangene Seasons nimmt die Bibliothek nicht auf.',
    titleTooShort: (min) =>
      `Der Name der Route ist zu kurz (mindestens ${min} Zeichen). ` +
      'Trag im Formularfeld einen Namen ein, unter dem man die Route wiedererkennt.',
    titleTrimmed: (title) => `Der Name wurde auf \`${title}\` gekürzt oder bereinigt.`,
    levelsUnreadable: 'Die Schlüsselstufen sind unlesbar. Erwartet wird eine Angabe wie `+18` oder `egal`.',
    levelOutOfRange: (which, value, min, max) =>
      `Die Schlüsselstufe "${which === 'min' ? 'ab' : 'bis'}" liegt mit +${value} außerhalb von +${min} bis +${max}.`,
    kindMissing: 'Die Art der Route fehlt. Wähle im Formular eine der vorgegebenen Möglichkeiten.',
    kindUnknown: (kind) => `Die Art der Route ist unbekannt: \`${kind}\`. Erlaubt sind: ${kindList('de')}.`,
    rightsMissing:
      'Die Bestätigung fehlt, dass die Route von dir stammt und veröffentlicht werden darf. ' +
      'Setz das Häkchen im Formular – ohne diese Zusage kann die Route nicht aufgenommen werden.',
    fewPulls: (n) => `Die Route hat nur ${n} Pulls – ungewöhnlich wenig.`,

    // Dekodieren. Diese landen als err.message in blobFailed() und damit
    // wörtlich im Kommentar - deshalb müssen auch sie übersetzt sein.
    decodeWrongPrefix: (prefix) => `Der Text beginnt nicht mit "${prefix}" – vermutlich das Falsche kopiert.`,
    decodeMdtNoPreset:
      'Der MDT-String enthält kein Preset. Nimm den String aus MDTs **Share**-Fenster zu einer ' +
      'geöffneten Route – nicht den zu einer Notiz oder einem einzelnen Objekt.',
    decodeMdtUnknownDungeon: (index) =>
      `Den Dungeon zu MDT-Index ${index} gibt es in der Version nicht, gegen die gebaut wird. ` +
      'Das passiert, wenn dein MDT älter oder neuer ist als unseres. Reiche die Route mit ' +
      '`/routes submit` ein – dieser Code nennt den Dungeon beim Namen statt über eine Nummer.',
    decodeEmpty: 'Der Einreichungs-Code ist leer.',
    decodeUnpackFailed: 'Der Einreichungs-Code ließ sich nicht entpacken – vermutlich unterwegs abgeschnitten.',
    decodeUnknownFormat: (version) =>
      `Unbekannte Formatversion: ${version}. Bring das Addon auf den neuesten Stand und reiche neu ein.`,
    decodeNoDungeon: 'Der Einreichungs-Code nennt keinen Dungeon.',
    decodeUnknownDungeon: (name) => `Dungeon unbekannt: ${name}.`,
    decodeNoPulls: 'Nach der Prüfung bleibt kein gültiger Pull übrig.',

    unknownEnemy: (index, dungeon) => `Gegnerindex ${index} gibt es in ${dungeon} nicht – übersprungen.`,
    unknownClone: (enemy, clone) => `Klon ${enemy}/${clone} gibt es nicht – übersprungen.`,
    belowRequired: (have, need) => `Route erreicht nur ${have} von ${need} nötigen Gegnerkräften.`,

    // Kommentare
    noBlob:
      'Im Issue steht kein Routen-Code. Erwartet wird entweder der Text aus `/routes submit` ' +
      '(beginnt mit `mdtrl1:`) oder MDTs eigener Export-String aus dem **Share**-Fenster ' +
      '(beginnt mit `!~MDT2~`).',
    blobFailed: (message) => `Der Einreichungs-Code ließ sich nicht verarbeiten: ${message}`,
    rejectionIntro: 'Die Einreichung ist noch nicht aufnahmefähig:',
    rejectionWarnings: 'Hinweise, die der Aufnahme nicht im Weg stehen:',
    rejectionOutro:
      'Das Issue bleibt offen. **Bearbeite es einfach** – jede Änderung startet die Prüfung ' +
      'automatisch neu, du musst nichts weiter tun. Sobald alles stimmt, wird die Route ' +
      'aufgenommen und das Issue geschlossen.',
    accepted: (id, have, need) =>
      `Aufgenommen als \`${id}\`. Die Route erreicht ${have} von ${need} Gegnerkräften ` +
      'und ist im nächsten Datenpaket enthalten. Danke!\n\n' +
      '---\n\n' +
      '**Die Route bleibt deine.**\n\n' +
      '- **Ändern:** dieses Issue bearbeiten – auch jetzt, wo es geschlossen ist. ' +
      'Die Route behält dabei ihre Kennung, also auch die Favoriten und Bestzeiten ' +
      'der Spieler.\n' +
      '- **Zurückziehen:** `/withdraw` als Kommentar hier hinein. Die Route ' +
      'verschwindet dann mit dem nächsten Datenpaket bei allen.',
    acceptedNotes: 'Hinweise:',
    updated: (have, need) =>
      `Aktualisiert. Die Route erreicht jetzt ${have} von ${need} Gegnerkräften und geht mit ` +
      'dem nächsten Datenpaket an alle Spieler, die sie gespeichert haben.',
    withdrawn:
      'Zurückgezogen. Die Route ist aus der Bibliothek entfernt und verschwindet mit dem ' +
      'nächsten Datenpaket bei allen Spielern.\n\n' +
      'War das ein Versehen? Label `withdrawn` entfernen, dann wird sie beim ' +
      'nächsten Lauf wieder aufgenommen.',
    duplicateOf: (number) =>
      `Dieselbe Route steht schon in #${number}. Zwei gleiche Wege doppelt auszuliefern hilft ` +
      'niemandem – ändere die Route oder ziehe diese Einreichung zurück.',
    brokenUpdate:
      'Die Bearbeitung ist nicht aufnahmefähig, deshalb bleibt vorerst die bisher ' +
      'veröffentlichte Fassung stehen. Bessere nach, dann wird sie ersetzt – oder ' +
      'schreibe `/withdraw` als Kommentar, wenn die Route ganz raus soll.',
  },

  en: {
    noTotalForces: 'MDT has no total enemy forces for this dungeon – the 100% check is skipped.',
    belowFull: (percent, have, need) =>
      `The route only reaches **${percent}%** of the enemy forces (${have} of ${need}). ` +
      'Only routes at 100% or above are accepted, because the key cannot be completed below that.',
    wrongSeason: (dungeon, season) =>
      `**${dungeon}** is not part of the current season${season ? ` (${season})` : ''}. ` +
      'The library does not take routes for past seasons.',
    titleTooShort: (min) =>
      `The route name is too short (at least ${min} characters). ` +
      'Put a name in the form field that makes the route recognisable.',
    titleTrimmed: (title) => `The name was shortened or cleaned up to \`${title}\`.`,
    levelsUnreadable: 'The key levels cannot be read. Expected something like `+18` or `any`.',
    levelOutOfRange: (which, value, min, max) =>
      `Key level "${which === 'min' ? 'from' : 'to'}" is +${value}, outside the range +${min} to +${max}.`,
    kindMissing: 'The route type is missing. Pick one of the options in the form.',
    kindUnknown: (kind) => `Unknown route type: \`${kind}\`. Allowed are: ${kindList('en')}.`,
    rightsMissing:
      'The confirmation is missing that the route is yours and may be published. ' +
      'Tick the box in the form – without it the route cannot be accepted.',
    fewPulls: (n) => `The route has only ${n} pulls – unusually few.`,

    decodeWrongPrefix: (prefix) => `The text does not start with "${prefix}" – you probably copied the wrong thing.`,
    decodeMdtNoPreset:
      'The MDT string contains no preset. Take the string from the **Share** window of MDT for an ' +
      'open route – not the one for a note or a single object.',
    decodeMdtUnknownDungeon: (index) =>
      `There is no dungeon for MDT index ${index} in the version we build against. ` +
      'That happens when your MDT is older or newer than ours. Submit the route with ' +
      '`/routes submit` instead – that code names the dungeon rather than numbering it.',
    decodeEmpty: 'The submission code is empty.',
    decodeUnpackFailed: 'The submission code could not be unpacked – it was probably cut off on the way.',
    decodeUnknownFormat: (version) =>
      `Unknown format version: ${version}. Update the addon to the latest version and submit again.`,
    decodeNoDungeon: 'The submission code names no dungeon.',
    decodeUnknownDungeon: (name) => `Unknown dungeon: ${name}.`,
    decodeNoPulls: 'No valid pull is left after the check.',

    unknownEnemy: (index, dungeon) => `Enemy index ${index} does not exist in ${dungeon} – skipped.`,
    unknownClone: (enemy, clone) => `Clone ${enemy}/${clone} does not exist – skipped.`,
    belowRequired: (have, need) => `Route only reaches ${have} of the ${need} enemy forces required.`,

    noBlob:
      'There is no route code in this issue. Expected either the text from `/routes submit` ' +
      '(starts with `mdtrl1:`) or the export string from the **Share** window of MDT ' +
      '(starts with `!~MDT2~`).',
    blobFailed: (message) => `The submission code could not be processed: ${message}`,
    rejectionIntro: 'This submission is not ready to be accepted yet:',
    rejectionWarnings: 'Notes that do not stand in the way:',
    rejectionOutro:
      'The issue stays open. **Just edit it** – every change starts the check again by itself, ' +
      'you need do nothing else. Once everything is right, the route is accepted and the issue ' +
      'is closed.',
    accepted: (id, have, need) =>
      `Accepted as \`${id}\`. The route reaches ${have} of ${need} enemy forces and will be in ` +
      'the next data package. Thank you!\n\n' +
      '---\n\n' +
      '**The route stays yours.**\n\n' +
      '- **Change it:** edit this issue – yes, even now that it is closed. The route ' +
      'keeps its id, and with it the favourites and best times players have on it.\n' +
      '- **Take it back:** comment `/withdraw` here. The route disappears for ' +
      'everyone with the next data package.',
    acceptedNotes: 'Notes:',
    updated: (have, need) =>
      `Updated. The route now reaches ${have} of ${need} enemy forces and goes out to ` +
      'everyone who saved it with the next data update.',
    withdrawn:
      'Withdrawn. The route is out of the library and disappears for all players with the ' +
      'next data update.\n\n' +
      'A mistake? Remove the `withdrawn` label and the next run takes it back in.',
    duplicateOf: (number) =>
      `The same route is already in #${number}. Shipping the same path twice helps nobody – ` +
      'change the route or withdraw this submission.',
    brokenUpdate:
      'The edit is not acceptable, so the version published so far stays in place for now. ' +
      'Fix it and it will be replaced – or comment `/withdraw` if the route ' +
      'should come out entirely.',
  },
}

/**
 * Textsatz einer Sprache, mit Englisch als Rueckfallebene.
 *
 * @param {string} lang
 * @returns {object}
 */
export function texts(lang) {
  return TEXTS[lang] ?? TEXTS.en
}
