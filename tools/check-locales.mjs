// Prueft die Sprachdateien auf kaputte Stringliterale.
//
// Anlass: ein Einfuegeskript hat "%s" unmaskiert in einen Wert geschrieben.
// Lua liest ""%s" text" als '""  %  s("text")' - also einen Aufruf von s,
// und meldet "attempt to call a nil value". Der Fehler ist im Quelltext kaum
// zu sehen, deshalb diese Pruefung.

import { readFileSync } from 'node:fs'

const VALID = /^"(?:[^"\\]|\\.)*"$/

let problems = 0

for (const file of process.argv.slice(2)) {
  const lines = readFileSync(file, 'utf8').split('\n')
  const name = file.split(/[\\/]/).pop()

  lines.forEach((line, index) => {
    const match = /^\s*\["[^"]+"\]\s*=\s*(.*?),\s*$/.exec(line)
    if (!match) return

    if (!VALID.test(match[1])) {
      console.log(`  ${name}:${index + 1}  ${line.trim()}`)
      problems += 1
    }
  })
}

console.log(problems === 0 ? '  keine kaputten Werte' : `  ${problems} kaputte Werte`)
process.exit(problems === 0 ? 0 : 1)
