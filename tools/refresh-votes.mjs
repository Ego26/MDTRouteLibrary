// Holt die Zustimmung zu jeder Route aus ihrem Einreich-Issue.
//
// Das Addon kann nicht messen, welche Route gut ist: es darf nicht ins Netz,
// und Telemetrie waere ohnehin die falsche Antwort. Das naechstliegende
// Signal, das ohne Zutun entsteht, ist der Daumen am Einreich-Issue. Wer eine
// Route gelaufen ist und sie gut fand, klickt ihn - das kostet nichts und
// niemand muss dafuer moderieren.
//
// Warum nicht in build.mjs: der Build soll offline und wiederholbar sein.
// Derselbe Datenstand muss denselben Hash ergeben, sonst veroeffentlicht die
// Pipeline Updates ohne Inhalt. Netzzugriff gehoert deshalb hierher.
//
// Aufruf:
//   node tools/refresh-votes.mjs --routes data/routes [--dry-run]

import { execFileSync } from 'node:child_process'
import { readdirSync, readFileSync, writeFileSync, existsSync } from 'node:fs'
import { join } from 'node:path'
import { pathToFileURL } from 'node:url'

/**
 * Zaehlt die Daumen an einem Issue.
 *
 * Nur "+1". Herz und Rakete sind Zuspruch fuers Einreichen, nicht fuer die
 * Route - und ein Signal, das jeder anders meint, taugt nicht zum Sortieren.
 *
 * @param {number} issue
 * @returns {number|null} null, wenn das Issue nicht erreichbar ist
 */
export function countThumbsUp(issue) {
  try {
    const out = execFileSync('gh', [
      'api', '--paginate',
      `repos/{owner}/{repo}/issues/${issue}/reactions`,
      '--jq', '[.[] | select(.content == "+1")] | length',
    ], { encoding: 'utf8' })

    // --paginate liefert je Seite eine Zahl; die Summe ist das Ergebnis.
    return out.trim().split('\n').filter(Boolean).reduce((sum, n) => sum + Number(n), 0)
  } catch {
    return null
  }
}

function parseArgs(argv) {
  const args = {}
  for (let i = 0; i < argv.length; i += 1) {
    if (!argv[i].startsWith('--')) continue
    const next = argv[i + 1]
    args[argv[i].slice(2)] = next === undefined || next.startsWith('--') ? true : argv[++i]
  }
  return args
}

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  const args = parseArgs(process.argv.slice(2))
  const dir = args.routes ?? 'data/routes'

  if (!existsSync(dir)) {
    console.log(`${dir} gibt es nicht - nichts zu tun.`)
    process.exit(0)
  }

  const files = readdirSync(dir).filter((f) => f.endsWith('.json'))
  let changed = 0
  let skipped = 0

  for (const file of files) {
    const path = join(dir, file)
    const route = JSON.parse(readFileSync(path, 'utf8'))

    // Nur Community-Routen haben ein Issue. keystone.guru-Routen haben keins
    // und behalten ihre 0 - siehe Hinweis in build.mjs zur Rangfolge.
    if (!route.submissionIssue) {
      skipped += 1
      continue
    }

    const votes = countThumbsUp(route.submissionIssue)
    if (votes === null) {
      console.warn(`  ! ${route.id}: Issue #${route.submissionIssue} nicht erreichbar - alter Stand bleibt`)
      continue
    }

    if ((route.votes ?? 0) === votes) continue

    console.log(`  ${route.id}: ${route.votes ?? 0} -> ${votes}`)
    route.votes = votes
    changed += 1
    if (!args['dry-run']) writeFileSync(path, `${JSON.stringify(route, null, 2)}\n`)
  }

  console.log(`${changed} von ${files.length - skipped} Routen mit Issue aktualisiert`)
}
