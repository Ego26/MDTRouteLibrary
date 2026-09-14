// Findet Zeichenketten, die ueber ein Zeilenende hinauslaufen.
//
// In Lua ist das ein Syntaxfehler, und zwar einer, der die ganze Datei
// unbrauchbar macht: das Addon laedt nicht, und im Spiel fehlt wortlos die
// Sektion. Gemeldet wird er nur als "unfinished string near" mit einer
// Zeilennummer - ohne Hinweis darauf, wo die Zeichenkette angefangen hat.
//
// Entstanden ist so ein Fehler hier durch ein Anfuehrungszeichen zu viel und
// durch "\n", das beim Schreiben der Datei zu einem echten Zeilenumbruch
// wurde. Beides sieht man einer Datei nicht an, solange man nur Klammern
// zaehlt - der vorhandene Blockpruefer entfernt Zeichenketten ja gerade,
// bevor er zaehlt, und stolpert deshalb ueber keine.
//
// Aufruf: node tools/check-lua-strings.mjs Core/Browser.lua [...]

import { readFileSync } from 'node:fs'

/**
 * Sucht offene Zeichenketten in einer Datei.
 *
 * @param {string} src
 * @returns {Array<{ line: number, quote: string }>}
 */
export function findUnterminated(src) {
  const problems = []
  let line = 1
  let i = 0

  while (i < src.length) {
    const rest = src.slice(i)

    // Lange Klammern: [[ ... ]] und [=[ ... ]=], auch als Kommentar.
    const long = rest.match(/^(--)?\[(=*)\[/)
    if (long) {
      const close = `]${long[2]}]`
      const end = src.indexOf(close, i + long[0].length)
      const stop = end === -1 ? src.length : end + close.length
      for (let k = i; k < stop; k += 1) if (src[k] === '\n') line += 1
      i = stop
      continue
    }

    // Zeilenkommentar
    if (rest.startsWith('--')) {
      const nl = src.indexOf('\n', i)
      i = nl === -1 ? src.length : nl
      continue
    }

    if (src[i] === '"' || src[i] === "'") {
      const quote = src[i]
      const startedAt = line
      i += 1

      let closed = false
      while (i < src.length) {
        if (src[i] === '\\') {
          // Ein maskiertes Zeichen gehoert dazu, auch ein maskierter Umbruch.
          if (src[i + 1] === '\n') line += 1
          i += 2
          continue
        }
        if (src[i] === '\n') break // Hier haette sie enden muessen.
        if (src[i] === quote) {
          closed = true
          i += 1
          break
        }
        i += 1
      }

      if (!closed) problems.push({ line: startedAt, quote })
      continue
    }

    if (src[i] === '\n') line += 1
    i += 1
  }

  return problems
}

const files = process.argv.slice(2)
if (files.length === 0) {
  console.error('Aufruf: node tools/check-lua-strings.mjs <datei> [...]')
  process.exit(1)
}

let bad = 0
for (const file of files) {
  const problems = findUnterminated(readFileSync(file, 'utf8'))
  if (problems.length === 0) {
    console.log(`  ${file}: Zeichenketten schliessen`)
    continue
  }
  bad += problems.length
  for (const p of problems) {
    console.error(`  ${file}:${p.line}: Zeichenkette mit ${p.quote} wird nicht geschlossen`)
  }
}

if (bad > 0) process.exit(1)
