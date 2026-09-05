// Sucht lokale Funktionen, die vor ihrer Definition aufgerufen werden.
// In Lua ist das kein Fehler beim Laden, sondern erst zur Laufzeit ein nil -
// genau der Fehler, der uns bei updateDungeonDetail getroffen hat.

import { readFileSync } from 'node:fs'

const file = process.argv[2]
const lines = readFileSync(file, 'utf8').split('\n')

const defs = new Map() // Name -> Zeile der Definition
const forward = new Set() // vorab deklarierte Namen

lines.forEach((line, i) => {
  const def = /^local function ([A-Za-z_][A-Za-z0-9_]*)/.exec(line)
  if (def) defs.set(def[1], i + 1)

  const fwd = /^local ([A-Za-z_][A-Za-z0-9_]*)\s*$/.exec(line)
  if (fwd) forward.add(fwd[1])
})

let problems = 0
for (const [name, defLine] of defs) {
  if (forward.has(name)) continue
  const re = new RegExp('\\b' + name + '\\s*\\(')

  for (let i = 0; i < defLine - 1; i += 1) {
    const line = lines[i]
    if (line.trim().startsWith('--')) continue
    if (!re.test(line)) continue
    console.log(`  ! ${name}() Zeile ${i + 1} benutzt, definiert erst Zeile ${defLine}`)
    problems += 1
  }
}

console.log(problems === 0 ? '  keine gefunden' : `  ${problems} Stelle(n)`)
