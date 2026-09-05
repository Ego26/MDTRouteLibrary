// Nimmt Routen-Einreichungen aus GitHub-Issues auf - ohne manuelle Freigabe.
//
// Der Ablauf einer Einreichung:
//   1. Spieler baut die Route in MDT, tippt /routes submit, kopiert den Blob.
//   2. Er oeffnet ein Issue nach .github/ISSUE_TEMPLATE/route-submission.yml.
//   3. Dieses Skript prueft die Einreichung gegen tools/validate-submission.mjs.
//   4. Besteht sie, wird die Route geschrieben und das Issue geschlossen.
//      Besteht sie nicht, bleibt das Issue offen und bekommt einen Kommentar
//      mit den konkreten Maengeln. Jede Aenderung am Issue loest die Pruefung
//      erneut aus - der Einreichende bessert also selbst nach.
//
// Warum ohne Freigabe: die Pruefung faengt alles ab, was maschinell
// entscheidbar ist - kaputte Blobs, fremde Dungeons, Routen unter 100 Prozent,
// fehlende Angaben, unsichtbare Zeichen im Namen. Was bleibt, ist Geschmack
// und Boeswilligkeit. Dafuer gibt es das Label "blocked": es haelt eine
// Einreichung dauerhaft draussen, ohne dass jemand jede einzelne ansehen muss.
//
// Braucht die GitHub-CLI (in Actions vorhanden) oder GH_TOKEN.
//
// Aufruf:
//   node tools/collect-submissions.mjs --mdt .mdt --out data/routes [--season "..."] [--dry-run]

import { execFileSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { writeFileSync, mkdirSync, existsSync } from 'node:fs'
import { join } from 'node:path'
import { pathToFileURL } from 'node:url'
import { readDungeons, readSeasons, buildLookup } from './mdt-dungeons.mjs'
import { decodeBlob, toRoute } from './parse-submission.mjs'
import { validateSubmission } from './validate-submission.mjs'

const LABEL_SUBMISSION = 'route-submission'
const LABEL_BLOCKED = 'blocked'
const LABEL_NEEDS_FIX = 'needs-fix'
const LABEL_ACCEPTED = 'accepted'

/**
 * Zerlegt den Text eines GitHub-Issue-Formulars.
 *
 * GitHub rendert jedes Feld als "### Beschriftung" gefolgt vom Wert. Leere
 * Felder stehen als "_No response_" drin.
 *
 * @param {string} body
 * @returns {Record<string, string>} Beschriftung -> Wert
 */
export function parseIssueForm(body) {
  const fields = {}
  const parts = (body ?? '').split(/^###\s+/m).slice(1)

  for (const part of parts) {
    const breakAt = part.indexOf('\n')
    if (breakAt === -1) continue

    const label = part.slice(0, breakAt).trim()
    const value = part.slice(breakAt + 1).trim()
    if (value && value !== '_No response_') fields[label] = value
  }

  return fields
}

/** Ruft die GitHub-CLI auf und gibt JSON zurueck. */
function gh(args, input) {
  const out = execFileSync('gh', args, {
    encoding: 'utf8',
    maxBuffer: 32 * 1024 * 1024,
    ...(input === undefined ? {} : { input }),
  })
  return out.trim().startsWith('{') || out.trim().startsWith('[') ? JSON.parse(out) : null
}

/** Wie gh(), aber ein Fehlschlag ist kein Grund, den Lauf abzubrechen. */
function ghTry(args, input) {
  try {
    return gh(args, input)
  } catch (err) {
    console.warn(`    (gh ${args[0]} ${args[1]} fehlgeschlagen: ${String(err.message).split('\n')[0]})`)
    return null
  }
}

/**
 * Legt ein Label an, falls es im Repository noch fehlt.
 *
 * `gh issue edit --add-label` scheitert an einem unbekannten Label. In einem
 * frisch angelegten Repository gibt es unsere Labels noch nicht, und daran
 * soll die erste Einreichung nicht scheitern.
 *
 * @param {string} name
 * @param {string} color
 * @param {string} description
 */
function ensureLabel(name, color, description) {
  ghTry(['label', 'create', name, '--color', color, '--description', description, '--force'])
}

/**
 * Listet alle offenen Einreichungen, die nicht gesperrt sind.
 *
 * @returns {Array<{number:number,body:string,author:string,labels:string[]}>}
 */
export function listSubmissions() {
  const issues = gh([
    'issue', 'list',
    '--state', 'open',
    '--label', LABEL_SUBMISSION,
    '--limit', '100',
    '--json', 'number,title,body,author,labels',
  ])

  return (issues ?? [])
    .map((i) => ({ ...i, author: i.author?.login ?? null, labels: (i.labels ?? []).map((l) => l.name) }))
    .filter((i) => !i.labels.includes(LABEL_BLOCKED))
}

/**
 * Baut den Kommentartext zu einer abgelehnten Einreichung.
 *
 * Der unsichtbare Marker am Ende traegt einen Fingerabdruck der Maengelliste.
 * Damit erkennt der naechste Lauf, ob sich etwas geaendert hat - sonst
 * kommentierte die taegliche Pipeline jeden Tag dasselbe.
 *
 * @param {string[]} errors
 * @param {string[]} warnings
 * @returns {{ body: string, fingerprint: string }}
 */
export function buildRejection(errors, warnings) {
  const fingerprint = createHash('sha256').update(errors.join('\n')).digest('hex').slice(0, 12)

  const parts = [
    'Die Einreichung ist noch nicht aufnahmefähig:',
    '',
    ...errors.map((e) => `- ${e}`),
  ]

  if (warnings.length > 0) {
    parts.push('', 'Hinweise, die der Aufnahme nicht im Weg stehen:', '', ...warnings.map((w) => `- ${w}`))
  }

  parts.push(
    '',
    'Das Issue bleibt offen. **Bearbeite es einfach** – jede Änderung startet die Prüfung ' +
    'automatisch neu, du musst nichts weiter tun. Sobald alles stimmt, wird die Route ' +
    'aufgenommen und das Issue geschlossen.',
    '',
    `<!-- mdtrl-check:${fingerprint} -->`,
  )

  return { body: parts.join('\n'), fingerprint }
}

/**
 * Hat dieselbe Maengelliste schon einmal als Kommentar gestanden?
 *
 * @param {number} number Issue-Nummer
 * @param {string} fingerprint
 * @returns {boolean}
 */
function alreadyReported(number, fingerprint) {
  const data = ghTry(['issue', 'view', String(number), '--json', 'comments'])
  const comments = data?.comments ?? []
  return comments.some((c) => (c.body ?? '').includes(`<!-- mdtrl-check:${fingerprint} -->`))
}

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

// ---------------------------------------------------------------- CLI

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  const args = parseArgs(process.argv.slice(2))
  if (!args.mdt) {
    console.error('Aufruf: node tools/collect-submissions.mjs --mdt <MDT-Pfad> --out data/routes [--season "..."] [--dry-run]')
    process.exit(1)
  }

  const dry = Boolean(args['dry-run'])
  const outDir = args.out ?? 'data/routes'

  const { dungeons } = readDungeons(args.mdt)
  const lookup = buildLookup(dungeons)

  // Dieselbe Aufloesung wie in build.mjs: benannte Season, sonst die neueste.
  const seasons = readSeasons(args.mdt)
  const chosen = seasons.find((entry) => entry.name === args.season) ?? seasons[0]
  const season = chosen
    ? { name: chosen.name, dungeonIndices: new Set(chosen.dungeonIndices) }
    : { name: null, dungeonIndices: new Set() }

  if (season.dungeonIndices.size === 0) {
    console.warn('  ! Keine Season-Zuordnung gefunden - die Dungeon-Prüfung entfällt.')
  } else {
    console.log(`Season "${season.name}": ${season.dungeonIndices.size} Dungeons`)
  }

  let issues = []
  try {
    issues = listSubmissions()
  } catch (err) {
    // Ohne GitHub-Zugriff ist das kein Fehler: der Build laeuft dann eben nur
    // mit den bereits eingecheckten Routen weiter.
    console.warn(`GitHub nicht erreichbar (${err.message}) - überspringe Einreichungen.`)
    process.exit(0)
  }

  console.log(`${issues.length} offene Einreichungen`)
  mkdirSync(outDir, { recursive: true })

  if (!dry && issues.length > 0) {
    ensureLabel(LABEL_NEEDS_FIX, 'D93F0B', 'Einreichung erfüllt die Aufnahmekriterien noch nicht')
    ensureLabel(LABEL_ACCEPTED, '0E8A16', 'Einreichung wurde ins Datenpaket übernommen')
    ensureLabel(LABEL_BLOCKED, '000000', 'Einreichung wird dauerhaft nicht aufgenommen')
  }

  let accepted = 0
  let rejected = 0

  for (const issue of issues) {
    const fields = parseIssueForm(issue.body)

    // Erst dekodieren. Alles, was hier schiefgeht, ist ein Formatfehler und
    // wird wie ein Pruefergebnis behandelt - der Einreichende soll denselben
    // hilfreichen Kommentar bekommen wie bei einem inhaltlichen Mangel.
    let route = null
    let errors = []
    let warnings = []

    const found = /mdtrl1:[A-Za-z0-9+/=]+/.exec(issue.body ?? '')
    if (!found) {
      errors.push(
        'Im Issue steht kein Einreichungs-Code. Erwartet wird der Text aus `/routes submit`, ' +
        'der mit `mdtrl1:` beginnt.'
      )
    } else {
      try {
        const decoded = toRoute(decodeBlob(found[0]), lookup)
        route = decoded.route
        warnings = decoded.warnings
      } catch (err) {
        errors.push(`Der Einreichungs-Code ließ sich nicht verarbeiten: ${err.message}`)
      }
    }

    if (route) {
      const check = validateSubmission({ route, fields, season })
      errors = errors.concat(check.errors)
      warnings = warnings.concat(check.warnings)
      if (check.ok) Object.assign(route, check.patch)
    }

    // ---- abgelehnt ------------------------------------------------------
    if (errors.length > 0) {
      rejected += 1
      const { body, fingerprint } = buildRejection(errors, warnings)
      console.log(`  - #${issue.number}: ${errors.length} Mangel/Mängel`)
      for (const e of errors) console.log(`      ${e.replace(/\*\*/g, '')}`)

      if (dry) continue

      // Nur kommentieren, wenn diese Maengelliste noch nicht dort steht -
      // sonst schreibt die taegliche Pipeline jeden Tag dasselbe hin.
      if (!alreadyReported(issue.number, fingerprint)) {
        ghTry(['issue', 'comment', String(issue.number), '--body-file', '-'], body)
      }
      if (!issue.labels.includes(LABEL_NEEDS_FIX)) {
        ghTry(['issue', 'edit', String(issue.number), '--add-label', LABEL_NEEDS_FIX])
      }
      continue
    }

    // ---- aufgenommen ----------------------------------------------------
    // Wer einreicht, wird genannt: der GitHub-Name ist verlaesslicher als der
    // Charaktername aus dem Blob.
    route.author = issue.author ?? route.author
    route.url = `https://github.com/${process.env.GITHUB_REPOSITORY ?? 'Ego26/MDTRouteLibrary'}/issues/${issue.number}`
    route.submissionIssue = issue.number

    const file = join(outDir, `${route.id}.json`)
    const isNew = !existsSync(file)

    for (const w of warnings) console.log(`      Hinweis: ${w.replace(/\*\*/g, '')}`)
    console.log(`  ${isNew ? '+' : '='} #${issue.number} ${route.id} "${route.title}" (${route.dungeonEnglishName}, ${route.enemyForces}/${route.enemyForcesRequired})`)
    accepted += 1

    if (dry) continue

    writeFileSync(file, `${JSON.stringify(route, null, 2)}\n`)

    const note = warnings.length > 0
      ? `\n\nHinweise:\n${warnings.map((w) => `- ${w}`).join('\n')}`
      : ''
    ghTry(['issue', 'edit', String(issue.number), '--add-label', LABEL_ACCEPTED, '--remove-label', LABEL_NEEDS_FIX])
    ghTry(['issue', 'close', String(issue.number), '--comment',
      `Aufgenommen als \`${route.id}\`. Die Route erreicht ` +
      `${route.enemyForces} von ${route.enemyForcesRequired} Gegnerkräften und ist im nächsten ` +
      `Datenpaket enthalten. Danke!${note}`])
  }

  console.log(`${accepted} aufgenommen, ${rejected} zurückgestellt`)
}
