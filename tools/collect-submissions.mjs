// Holt freigegebene Routen-Einreichungen aus GitHub-Issues.
//
// Der Ablauf einer Einreichung:
//   1. Spieler baut die Route in MDT, tippt /routes submit, kopiert den Blob.
//   2. Er oeffnet ein Issue nach .github/ISSUE_TEMPLATE/route-submission.yml.
//   3. Jemand prueft die Route und setzt das Label "approved".
//   4. Dieses Skript holt alle so markierten Issues, dekodiert sie, schreibt
//      sie nach data/routes/ und schliesst das Issue.
//
// Schritt 3 ist Absicht und nicht wegzulassen: ungeprueft kaemen kaputte,
// doppelte und boeswillige Routen ins Addon.
//
// Braucht die GitHub-CLI (in Actions vorhanden) oder GH_TOKEN.
//
// Aufruf:
//   node tools/collect-submissions.mjs --mdt .mdt --out data/routes [--dry-run]

import { execFileSync } from 'node:child_process'
import { writeFileSync, mkdirSync, existsSync } from 'node:fs'
import { join } from 'node:path'
import { pathToFileURL } from 'node:url'
import { readDungeons, buildLookup } from './mdt-dungeons.mjs'
import { decodeBlob, toRoute } from './parse-submission.mjs'

const LABEL_APPROVED = 'approved'
const LABEL_SUBMISSION = 'route-submission'

/** Ruft die GitHub-CLI auf und gibt JSON zurueck. */
function gh(args) {
  const out = execFileSync('gh', args, { encoding: 'utf8', maxBuffer: 32 * 1024 * 1024 })
  return out.trim() ? JSON.parse(out) : null
}

/**
 * Listet alle offenen, freigegebenen Einreichungen.
 *
 * @returns {Array<{number:number,title:string,body:string,author:string}>}
 */
export function listApproved() {
  const issues = gh([
    'issue', 'list',
    '--state', 'open',
    '--label', LABEL_SUBMISSION,
    '--label', LABEL_APPROVED,
    '--limit', '100',
    '--json', 'number,title,body,author',
  ])
  return (issues ?? []).map((i) => ({ ...i, author: i.author?.login ?? null }))
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

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  const args = parseArgs(process.argv.slice(2))
  if (!args.mdt) {
    console.error('Aufruf: node tools/collect-submissions.mjs --mdt <MDT-Pfad> --out data/routes [--dry-run]')
    process.exit(1)
  }

  const outDir = args.out ?? 'data/routes'
  const { dungeons } = readDungeons(args.mdt)
  const lookup = buildLookup(dungeons)

  let issues = []
  try {
    issues = listApproved()
  } catch (err) {
    // Ohne GitHub-Zugriff ist das kein Fehler: der Build laeuft dann eben nur
    // mit den bereits eingecheckten Routen weiter.
    console.warn(`GitHub nicht erreichbar (${err.message}) - ueberspringe Einreichungen.`)
    process.exit(0)
  }

  console.log(`${issues.length} freigegebene Einreichungen`)
  mkdirSync(outDir, { recursive: true })

  let accepted = 0
  for (const issue of issues) {
    const found = /mdtrl1:[A-Za-z0-9+/=]+/.exec(issue.body ?? '')
    if (!found) {
      console.warn(`  ! #${issue.number}: kein Blob gefunden`)
      continue
    }

    try {
      const { route, warnings } = toRoute(decodeBlob(found[0]), lookup)

      // Wer einreicht, wird genannt - der GitHub-Name ist verlaesslicher als
      // der Charaktername aus dem Blob.
      route.author = issue.author ?? route.author
      route.url = `https://github.com/${process.env.GITHUB_REPOSITORY ?? 'Ego26/MDTRouteLibrary'}/issues/${issue.number}`
      route.submissionIssue = issue.number

      const file = join(outDir, `${route.id}.json`)
      const isNew = !existsSync(file)

      for (const w of warnings) console.warn(`  ! #${issue.number}: ${w}`)
      console.log(`  ${isNew ? '+' : '='} #${issue.number} ${route.id} "${route.title}" (${route.dungeonEnglishName})`)

      if (!args['dry-run']) {
        writeFileSync(file, `${JSON.stringify(route, null, 2)}\n`)
        gh(['issue', 'close', String(issue.number), '--comment',
          `Übernommen als \`${route.id}\`. Die Route ist im nächsten Datenpaket enthalten. Danke!`])
      }
      accepted += 1
    } catch (err) {
      console.warn(`  ! #${issue.number}: ${err.message}`)
      if (!args['dry-run']) {
        try {
          gh(['issue', 'comment', String(issue.number), '--body',
            `Die Einreichung ließ sich nicht verarbeiten: ${err.message}\n\nBitte den Blob erneut mit \`/routes submit\` erzeugen und einfügen.`])
          gh(['issue', 'edit', String(issue.number), '--remove-label', LABEL_APPROVED])
        } catch {
          // Kommentieren ist nur Komfort - der Build soll deswegen nicht scheitern.
        }
      }
    }
  }

  console.log(`${accepted} Einreichungen übernommen`)
}
