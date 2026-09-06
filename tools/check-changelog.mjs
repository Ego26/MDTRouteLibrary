// Prueft den Erzeuger der Release-Notes.
//
// Warum eigens geprueft: schreibt tools/changelog.mjs keine Datei, faellt der
// BigWigs-Packager auf seine eigene Erzeugung aus Commit-Texten zurueck - und
// dann steht im Release-Text alles, was in den Commits steht. Das faellt nur
// auf, wenn man es hinterher liest. Hier faellt es vorher auf.
//
// Aufruf:
//   node tools/check-changelog.mjs

import {
  unreleasedBody, insertSection, buildNotes, diffRoutes, routeLine, levelRange, escapeMarkdown,
} from './changelog.mjs'

let failed = 0

function check(label, got, want) {
  const ok = got === want
  if (!ok) failed += 1
  console.log(`  ${ok ? 'ok  ' : 'FEHL'}  ${label}${ok ? '' : `   erwartet ${JSON.stringify(want)}, bekam ${JSON.stringify(got)}`}`)
}

function route(over = {}) {
  return {
    id: 'r1', title: 'Meta Route', author: 'Ego26', kind: 'Meta',
    dungeonEnglishName: 'Den of Nalorakk', keyLevelMin: 10, keyLevelMax: 16,
    enemyForces: 731, enemyForcesRequired: 729,
    pulls: Array.from({ length: 15 }, () => ({})),
    ...over,
  }
}

console.log('Stufenbereich')
check('von bis', levelRange({ keyLevelMin: 10, keyLevelMax: 16 }), '+10 to +16')
check('gleich', levelRange({ keyLevelMin: 12, keyLevelMax: 12 }), '+12')
check('nur ab', levelRange({ keyLevelMin: 18, keyLevelMax: null }), '+18 and up')
check('nur bis', levelRange({ keyLevelMin: null, keyLevelMax: 12 }), 'up to +12')
check('egal', levelRange({ keyLevelMin: null, keyLevelMax: null }), null)

console.log('Markdown entschaerfen')
check('Sternchen', escapeMarkdown('a*b'), 'a\\*b')
check('Unterstrich', escapeMarkdown('a_b'), 'a\\_b')
check('Klammern', escapeMarkdown('[a]'), '\\[a\\]')
check('harmlos bleibt', escapeMarkdown('Its a honor!'), 'Its a honor!')

console.log('Routenzeile')
check('vollstaendig', routeLine(route()),
  '- **Meta Route** — Den of Nalorakk, +10 to +16, Meta, by Ego26 (15 pulls)')
check('ein Pull', routeLine(route({ pulls: [{}] })),
  '- **Meta Route** — Den of Nalorakk, +10 to +16, Meta, by Ego26 (1 pull)')
check('ohne Autor', routeLine(route({ author: null })),
  '- **Meta Route** — Den of Nalorakk, +10 to +16, Meta (15 pulls)')
check('Titel wird entschaerft', routeLine(route({ title: 'Pull *hier*' })).startsWith('- **Pull \\*hier\\***'), true)

console.log('Routen vergleichen')
{
  const before = [route({ id: 'a' }), route({ id: 'b' })]
  const after = [route({ id: 'a' }), route({ id: 'c', dungeonEnglishName: 'Altar of Fangs' })]
  const d = diffRoutes(before, after)
  check('neu erkannt', d.added.map((r) => r.id).join(','), 'c')
  check('entfernt erkannt', d.removed.map((r) => r.id).join(','), 'b')
  check('unveraendert bleibt still', d.changed.length, 0)
}
{
  // Was der Nutzer sieht, zaehlt als Aenderung ...
  const d = diffRoutes([route()], [route({ keyLevelMax: 20 })])
  check('Stufenbereich zaehlt', d.changed.length, 1)
  // ... interne Felder nicht. Sonst stuende bei jedem erneuten Aufnehmen
  // derselben Route eine Zeile im Changelog.
  const e = diffRoutes([route()], [route({ acceptedAt: '2026-09-09', submissionIssue: 7 })])
  check('interne Felder zaehlen nicht', e.changed.length, 0)
}
{
  const many = Array.from({ length: 30 }, (_, i) => route({ id: `r${i}`, title: `Route ${String(i).padStart(2, '0')}` }))
  const notes = buildNotes({ added: many })
  check('Liste wird gekappt', (notes.match(/^- /gm) ?? []).length, 26)
  check('Rest wird gezaehlt', notes.includes('…and 5 more.'), true)
}

console.log('Handgeschriebener Teil')
{
  const text = '# Changelog\n\n## Unreleased\n\n<!-- Hinweis -->\n\n- Zoom bleibt erhalten.\n\n## 2026.09.06.1\n\nalt\n'
  check('Eintraege gelesen', unreleasedBody(text), '- Zoom bleibt erhalten.')
  check('Kommentar entfernt', unreleasedBody(text).includes('Hinweis'), false)
  check('leerer Block', unreleasedBody('# Changelog\n\n## Unreleased\n\n## 1.0\n\nalt\n'), '')
  check('kein Block', unreleasedBody('# Changelog\n\n## 1.0\n\nalt\n'), '')
}

console.log('Abschnitt einsetzen')
{
  const text = '# Changelog\n\n## Unreleased\n\n- Zoom bleibt erhalten.\n\n## 2026.09.06.1\n\nalt\n'
  const notes = buildNotes({ manual: unreleasedBody(text), added: [route({ id: 'n1' })] })
  const next = insertSection(text, '2026.09.07.1', notes)

  check('Unreleased ist danach leer', unreleasedBody(next), '')
  check('neuer Abschnitt da', next.includes('## 2026.09.07.1'), true)
  check('alter Abschnitt bleibt', next.includes('## 2026.09.06.1'), true)
  check('alter Inhalt bleibt', next.trimEnd().endsWith('alt'), true)
  check('Reihenfolge stimmt', next.indexOf('## 2026.09.07.1') < next.indexOf('## 2026.09.06.1'), true)
  check('handgeschriebenes uebernommen', next.includes('- Zoom bleibt erhalten.'), true)
  check('Route uebernommen', next.includes('### New route'), true)
  check('Ueberschriften gezaehlt', (next.match(/^## /gm) ?? []).length, 3)
}

console.log('Notdurft, wenn nichts vorliegt')
check('gar nichts', buildNotes({}).trim(), 'Maintenance release. No changes to routes or dungeon data.')
check('neue MDT-Version', buildNotes({ mdtVersion: '6.2.16', previousMdt: '6.2.15' }).trim(),
  'Dungeon data rebuilt against Mythic Dungeon Tools 6.2.16.')
check('Notdurft nur ohne Inhalt', buildNotes({ manual: '- Etwas.', mdtVersion: '6.2.16', previousMdt: '6.2.15' }).trim(), '- Etwas.')

console.log(failed ? `\n${failed} Prüfungen fehlgeschlagen` : '\nAlle Prüfungen bestanden')
process.exit(failed ? 1 : 0)
