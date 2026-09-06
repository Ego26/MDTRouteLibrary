// Schreibt die Release-Notes fuer eine Version.
//
// Gespeist wird das aus zwei Quellen:
//
//   * Dem Abschnitt "## Unreleased" in CHANGELOG.md. Da steht von Hand drin,
//     was am Addon selbst passiert ist. Wer Code aendert, traegt es dort ein -
//     sonst taucht es in keinem Release auf.
//   * Dem Unterschied in data/routes zwischen dem letzten Tag und jetzt: neue,
//     geaenderte und entfernte Routen. Das rechnet dieses Werkzeug selbst aus,
//     weil es der Teil ist, der sich bei fast jedem Release aendert und den
//     niemand von Hand pflegen wuerde.
//
// Herauskommen zwei Dinge:
//
//   * CHANGELOG.md bekommt den neuen Abschnitt eingesetzt, "Unreleased" ist
//     danach wieder leer. Diese Datei ist die Historie fuers Repository.
//   * RELEASE-NOTES.md enthaelt nur diesen einen Abschnitt. Genau sie liest der
//     BigWigs-Packager (.pkgmeta: manual-changelog) und macht daraus den
//     GitHub-Release-Text und den Changelog bei CurseForge. Deshalb steht dort
//     nur die aktuelle Version - mit der vollen Historie waechst der
//     Release-Text sonst mit jedem Mal weiter an.
//
// Aufruf:
//   node tools/changelog.mjs --version 2026.09.06.1 [--since 2026.09.05.1] [--dry]

import { execFileSync } from 'node:child_process'
import { readdirSync, readFileSync, writeFileSync, existsSync } from 'node:fs'
import { join, dirname } from 'node:path'
import { fileURLToPath, pathToFileURL } from 'node:url'

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..')

// Mehr Zeilen als das liest ohnehin niemand. Der Rest wird gezaehlt.
const MAX_ROUTE_LINES = 25

// Anmerkungen duerfen bis 600 Zeichen lang sein. So viel gehoert in die
// Route, nicht in den Release-Text.
const MAX_NOTE_CHARS = 200

/**
 * Ruft git auf und gibt die Ausgabe zurueck, oder null wenn der Aufruf
 * fehlschlaegt (etwa weil es den Tag noch gar nicht gibt).
 *
 * @param {string[]} args
 * @returns {string|null}
 */
function git(args) {
  try {
    return execFileSync('git', args, { cwd: ROOT, encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] })
  } catch {
    return null
  }
}

/**
 * Der zuletzt gesetzte Tag - der Stand, gegen den verglichen wird.
 * Der Tag der laufenden Veroeffentlichung existiert noch nicht; sollte er
 * doch schon da sein (Wiederholung eines Laufs), wird er uebersprungen.
 *
 * @param {string} exclude
 * @returns {string|null}
 */
export function previousTag(exclude) {
  const out = git(['for-each-ref', '--sort=-creatordate', '--format=%(refname:short)', 'refs/tags'])
  if (!out) return null
  return out.split('\n').map((l) => l.trim()).filter((l) => l && l !== exclude)[0] ?? null
}

/** Liest alle Routen-JSONs aus dem Arbeitsverzeichnis. */
function routesNow(dir) {
  const full = join(ROOT, dir)
  if (!existsSync(full)) return []
  return readdirSync(full)
    .filter((f) => f.endsWith('.json'))
    .map((f) => JSON.parse(readFileSync(join(full, f), 'utf8')))
}

/** Liest alle Routen-JSONs, wie sie zu einem Tag aussahen. */
function routesAt(ref, dir) {
  if (!ref) return []
  const list = git(['ls-tree', '-r', '--name-only', ref, '--', dir])
  if (list === null) return []
  const routes = []
  for (const file of list.split('\n').map((l) => l.trim()).filter((l) => l.endsWith('.json'))) {
    const text = git(['show', `${ref}:${file}`])
    if (!text) continue
    try {
      routes.push(JSON.parse(text))
    } catch {
      // Kaputte Datei im alten Stand interessiert uns hier nicht.
    }
  }
  return routes
}

/**
 * Zeichen entschaerfen, die Markdown sonst als Auszeichnung liest. Routentitel
 * kommen von Nutzern; ein Sternchen darin soll den Rest der Zeile nicht kursiv
 * setzen.
 *
 * @param {string} text
 * @returns {string}
 */
export function escapeMarkdown(text) {
  return String(text ?? '').replace(/[\\`*_[\]<>]/g, (c) => `\\${c}`)
}

/**
 * "+10 to +16", "+10 and up", "up to +16" - oder nichts, wenn die Route fuer
 * jede Stufe gedacht ist.
 *
 * @param {object} route
 * @returns {string|null}
 */
export function levelRange(route) {
  const min = route.keyLevelMin ?? null
  const max = route.keyLevelMax ?? null
  if (min !== null && max !== null) return min === max ? `+${min}` : `+${min} to +${max}`
  if (min !== null) return `+${min} and up`
  if (max !== null) return `up to +${max}`
  return null
}

/**
 * Eine Route als Aufzaehlungszeile.
 *
 * @param {object} route
 * @returns {string}
 */
export function routeLine(route) {
  const facts = [escapeMarkdown(route.dungeonEnglishName)]
  const level = levelRange(route)
  if (level) facts.push(level)
  if (route.kind) facts.push(escapeMarkdown(KIND_LABELS[route.kind] ?? route.kind))
  if (route.author) facts.push(`by ${escapeMarkdown(route.author)}`)

  // Der Prozentsatz steht bewusst nicht dabei: aufgenommen wird ohnehin nur,
  // was die Gegnerkraefte voll erreicht. Er stuende in jeder Zeile und saehe
  // in jeder gleich aus.
  const pulls = route.pulls?.length ?? 0
  const detail = pulls > 0 ? ` (${pulls} ${pulls === 1 ? 'pull' : 'pulls'})` : ''

  const title = escapeMarkdown(route.title || 'Untitled route')
  let line = `- **${title}** — ${facts.join(', ')}${detail}`

  // Was der Einreichende zu seiner Route geschrieben hat, gehoert dazu: es
  // sagt mehr ueber sie als jede Zahl. Eingerueckt, damit Markdown es noch
  // zum selben Punkt zaehlt, und gekuerzt, damit ein Aufsatz den Release-Text
  // nicht sprengt.
  const notes = String(route.notes ?? '').trim()
  if (notes) {
    const short = notes.length > MAX_NOTE_CHARS ? `${notes.slice(0, MAX_NOTE_CHARS - 1).trimEnd()}…` : notes
    line += `\n  ${escapeMarkdown(short)}`
  }

  return line
}

// Die Routenart steht im Einreichungsformular auf Deutsch, der Release-Text
// ist englisch. Unbekanntes bleibt stehen, wie es ist - lieber ein deutsches
// Wort im Text als gar keine Angabe.
const KIND_LABELS = {
  Meta: 'Meta',
  Einsteiger: 'Beginner',
  Spezialisiert: 'Specialised',
  Sonstiges: 'Other',
}

const NUMBERS = ['no', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten']

/** "three", oder "17" wenn es dafuer kein Wort mehr gibt. */
function count(n) {
  return NUMBERS[n] ?? String(n)
}

/**
 * Der Satz, der ueber den Listen steht. Ohne ihn liest sich ein Release wie
 * ein Diff; mit ihm weiss man nach einer Zeile, was drin ist.
 *
 * @param {object[]} added
 * @param {object[]} changed
 * @param {object[]} removed
 * @returns {string}
 */
export function leadSentence(added, changed, removed) {
  const parts = []

  if (added.length > 0) {
    const dungeons = [...new Set(added.map((r) => r.dungeonEnglishName))]
    if (added.length === 1) {
      parts.push(`One new route, for ${dungeons[0]}.`)
    } else if (dungeons.length === 1) {
      parts.push(`${count(added.length)} new routes, all for ${dungeons[0]}.`)
    } else {
      parts.push(`${count(added.length)} new routes across ${count(dungeons.length)} dungeons.`)
    }
  }

  if (changed.length > 0) {
    parts.push(changed.length === 1
      ? 'One route was updated by its author.'
      : `${count(changed.length)} routes were updated by their authors.`)
  }

  if (removed.length > 0) {
    parts.push(removed.length === 1 ? 'One route was withdrawn.' : `${count(removed.length)} routes were withdrawn.`)
  }

  // Erster Buchstabe gross - "three new routes" faengt sonst klein an.
  const text = parts.join(' ')
  return text ? text[0].toUpperCase() + text.slice(1) : ''
}

/** Was an einer Route den Nutzer interessiert - nur daran haengt "changed". */
function visible(route) {
  return JSON.stringify([
    route.title, route.author, route.kind,
    route.keyLevelMin ?? null, route.keyLevelMax ?? null,
    route.enemyForces, route.pulls?.length ?? 0,
  ])
}

/**
 * Vergleicht zwei Routenstaende.
 *
 * @param {object[]} before
 * @param {object[]} after
 * @returns {{added: object[], changed: object[], removed: object[]}}
 */
export function diffRoutes(before, after) {
  const old = new Map(before.map((r) => [r.id, r]))
  const added = []
  const changed = []

  for (const route of after) {
    const previous = old.get(route.id)
    if (!previous) added.push(route)
    else if (visible(previous) !== visible(route)) changed.push(route)
    old.delete(route.id)
  }

  const byDungeon = (a, b) =>
    (a.dungeonEnglishName ?? '').localeCompare(b.dungeonEnglishName ?? '') ||
    (a.title ?? '').localeCompare(b.title ?? '')

  return { added: added.sort(byDungeon), changed: changed.sort(byDungeon), removed: [...old.values()].sort(byDungeon) }
}

/** Haengt eine Liste an, gekappt auf MAX_ROUTE_LINES. */
function section(lines, heading, routes) {
  if (routes.length === 0) return
  lines.push(`### ${heading}`, '')
  for (const route of routes.slice(0, MAX_ROUTE_LINES)) lines.push(routeLine(route))
  const rest = routes.length - MAX_ROUTE_LINES
  if (rest > 0) lines.push(`- …and ${rest} more.`)
  lines.push('')
}

/**
 * Holt den handgeschriebenen Teil aus CHANGELOG.md heraus.
 *
 * @param {string} text
 * @returns {string} Inhalt unter "## Unreleased", ohne Kommentare
 */
export function unreleasedBody(text) {
  const start = text.search(/^##\s+Unreleased\s*$/m)
  if (start < 0) return ''
  const after = text.slice(start)
  const next = after.slice(1).search(/^##\s/m)
  const body = next < 0 ? after : after.slice(0, next + 1)
  return body
    .replace(/^##\s+Unreleased\s*$/m, '')
    .replace(/<!--[\s\S]*?-->/g, '')
    .trim()
}

/**
 * Baut den Text eines Release-Abschnitts (ohne Ueberschrift).
 *
 * @param {object} args
 * @returns {string}
 */
export function buildNotes({ manual = '', added = [], changed = [], removed = [], mdtVersion = null, previousMdt = null }) {
  const lines = []
  const hasRoutes = added.length + changed.length + removed.length > 0

  if (manual) {
    // Wer eigene Ueberschriften geschrieben hat, bekommt keine
    // uebergestuelpt. Blosse Stichpunkte dagegen brauchen ein Dach, sobald
    // darunter noch Routenlisten kommen.
    const ownHeading = /^#{2,4}\s/m.test(manual)
    if (hasRoutes && !ownHeading) lines.push('### Addon', '')
    lines.push(manual, '')
  }

  const lead = leadSentence(added, changed, removed)
  if (lead) lines.push(lead, '')

  section(lines, added.length === 1 ? 'New route' : 'New routes', added)
  section(lines, 'Updated routes', changed)
  section(lines, 'Removed routes', removed)

  // Wenn sonst nichts dasteht, soll wenigstens der Grund dastehen. Ein
  // Release ohne einen einzigen Satz ist schlimmer als ein knapper.
  if (lines.length === 0) {
    lines.push(
      mdtVersion && previousMdt && mdtVersion !== previousMdt
        ? `Dungeon data rebuilt against Mythic Dungeon Tools ${mdtVersion}.`
        : 'Maintenance release. No changes to routes or dungeon data.',
    )
  }

  return `${lines.join('\n').trim()}\n`
}

/**
 * Der veroeffentlichte Text. Nur was sich in dieser Version getan hat, unter
 * einer Ueberschrift - keine Beschreibung des Addons.
 *
 * Die gehoert auf die Projektseite, nicht in jeden Release-Text: dort stuende
 * sie bei jeder Version wieder, und wer auf ein Update schaut, will wissen was
 * neu ist und nicht noch einmal lesen was das Addon ueberhaupt macht.
 *
 * @param {string} notes
 * @returns {string}
 */
export function buildReleaseNotes(notes) {
  const body = String(notes ?? '').trim()
  return body ? `## What's new in this version\n\n${body}\n` : ''
}

/**
 * Setzt den Abschnitt in CHANGELOG.md ein und leert "Unreleased".
 *
 * @param {string} text
 * @param {string} version
 * @param {string} notes
 * @returns {string}
 */
export function insertSection(text, version, notes) {
  const entry = `## ${version}\n\n${notes.trim()}\n`
  const marker = text.search(/^##\s+Unreleased\s*$/m)

  if (marker < 0) {
    // Kein Unreleased-Block: hinter die erste Ueberschrift setzen.
    const head = text.search(/^##\s/m)
    return head < 0 ? `${text.trimEnd()}\n\n${entry}` : `${text.slice(0, head)}${entry}\n${text.slice(head)}`
  }

  const after = text.slice(marker)
  const next = after.slice(1).search(/^##\s/m)
  const tail = next < 0 ? '' : after.slice(next + 1)
  return `${text.slice(0, marker)}## Unreleased\n\n${entry}\n${tail}`.replace(/\n{3,}$/, '\n')
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

// Die Pruefung auf argv[1] ist noetig, weil "node --input-type=module -e"
// kein Skript hat - ohne sie stuerzt schon der Import ab.
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const args = parseArgs(process.argv.slice(2))
  if (!args.version || args.version === true) {
    console.error('Aufruf: node tools/changelog.mjs --version 2026.09.06.1 [--since <tag>] [--dry]')
    process.exit(1)
  }

  const routesDir = typeof args.routes === 'string' ? args.routes : 'data/routes'
  const changelogFile = join(ROOT, typeof args.changelog === 'string' ? args.changelog : 'CHANGELOG.md')
  const notesFile = join(ROOT, typeof args.notes === 'string' ? args.notes : 'RELEASE-NOTES.md')

  const since = typeof args.since === 'string' ? args.since : previousTag(args.version)
  const { added, changed, removed } = diffRoutes(routesAt(since, routesDir), routesNow(routesDir))

  const state = existsSync(join(ROOT, 'data/build-state.json'))
    ? JSON.parse(readFileSync(join(ROOT, 'data/build-state.json'), 'utf8'))
    : {}
  let previousState = {}
  try {
    previousState = JSON.parse(git(['show', `${since}:data/build-state.json`]) ?? '{}')
  } catch {
    previousState = {}
  }

  const changelog = existsSync(changelogFile) ? readFileSync(changelogFile, 'utf8') : '# Changelog\n\n## Unreleased\n'
  const notes = buildNotes({
    manual: unreleasedBody(changelog),
    added,
    changed,
    removed,
    mdtVersion: state.mdtVersion ?? null,
    previousMdt: previousState.mdtVersion ?? null,
  })

  console.log(`Vergleich gegen: ${since ?? '(kein Tag - erste Veroeffentlichung)'}`)
  console.log(`Routen: ${added.length} neu, ${changed.length} geaendert, ${removed.length} entfernt`)
  console.log('--- Abschnitt fuer CHANGELOG.md ---')
  console.log(notes.trimEnd())
  console.log('-----------------------------------')

  if (args.dry) {
    console.log('--- veroeffentlichter Text (RELEASE-NOTES.md) ---')
    console.log(buildReleaseNotes(notes).trimEnd())
    console.log('------------------------------------------------')
    console.log('Probelauf - nichts geschrieben.')
  } else {
    writeFileSync(notesFile, buildReleaseNotes(notes))
    writeFileSync(changelogFile, insertSection(changelog, args.version, notes))
    console.log(`geschrieben: ${notesFile}`)
    console.log(`geschrieben: ${changelogFile}`)
  }
}
