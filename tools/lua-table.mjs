// Minimaler Parser fuer Lua-Tabellenliterale.
//
// Reicht genau fuer MDTs Dungeondateien: die sind generiert und benutzen nur
// Tabellen, Strings, Zahlen, Booleans und nil. Kein Anspruch auf einen
// vollstaendigen Lua-Parser - Funktionen oder Ausdruecke kommen dort nicht vor.

/**
 * Fehler mit Zeilenangabe, damit ein kaputtes MDT-Update schnell auffindbar ist.
 */
class LuaParseError extends Error {
  constructor(message, source, pos) {
    const line = source.slice(0, pos).split('\n').length
    super(`${message} (Zeile ${line})`)
    this.name = 'LuaParseError'
    this.line = line
  }
}

/**
 * Liest ein Lua-Tabellenliteral ab einer Position.
 *
 * @param {string} src Quelltext
 * @param {number} start Index der oeffnenden Klammer `{`
 * @returns {{ value: object, end: number }} Wert und Index nach der `}`
 */
export function parseTableAt(src, start) {
  const p = new Parser(src, start)
  const value = p.parseTable()
  return { value, end: p.pos }
}

class Parser {
  constructor(src, pos) {
    this.src = src
    this.pos = pos
  }

  error(msg) {
    throw new LuaParseError(msg, this.src, this.pos)
  }

  /** Ueberspringt Leerraum, Zeilen- und Blockkommentare. */
  skip() {
    const { src } = this
    for (;;) {
      while (this.pos < src.length && /\s/.test(src[this.pos])) this.pos++

      if (src.startsWith('--', this.pos)) {
        // Blockkommentar --[[ ... ]] oder --[=[ ... ]=]
        const block = /^--\[(=*)\[/.exec(src.slice(this.pos))
        if (block) {
          const close = `]${block[1]}]`
          const end = src.indexOf(close, this.pos + block[0].length)
          this.pos = end === -1 ? src.length : end + close.length
          continue
        }
        const nl = src.indexOf('\n', this.pos)
        this.pos = nl === -1 ? src.length : nl + 1
        continue
      }
      return
    }
  }

  expect(ch) {
    this.skip()
    if (this.src[this.pos] !== ch) this.error(`"${ch}" erwartet, gefunden "${this.src[this.pos]}"`)
    this.pos++
  }

  /** Liest einen Lua-String inklusive der ueblichen Escapes. */
  parseString() {
    const quote = this.src[this.pos]
    this.pos++
    let out = ''
    while (this.pos < this.src.length) {
      const ch = this.src[this.pos]
      if (ch === '\\') {
        const next = this.src[this.pos + 1]
        const simple = { n: '\n', t: '\t', r: '\r', '\\': '\\', '"': '"', "'": "'", a: '\x07', b: '\b', f: '\f', v: '\v' }
        if (next in simple) {
          out += simple[next]
          this.pos += 2
          continue
        }
        const dec = /^\\(\d{1,3})/.exec(this.src.slice(this.pos))
        if (dec) {
          out += String.fromCharCode(parseInt(dec[1], 10))
          this.pos += dec[0].length
          continue
        }
        out += next
        this.pos += 2
        continue
      }
      if (ch === quote) {
        this.pos++
        return out
      }
      out += ch
      this.pos++
    }
    this.error('String nicht geschlossen')
  }

  parseValue() {
    this.skip()
    const ch = this.src[this.pos]

    if (ch === '{') return this.parseTable()
    if (ch === '"' || ch === "'") return this.parseString()

    const literal = /^(true|false|nil)\b/.exec(this.src.slice(this.pos))
    if (literal) {
      this.pos += literal[0].length
      return literal[1] === 'true' ? true : literal[1] === 'false' ? false : null
    }

    const num = /^-?(?:0[xX][0-9a-fA-F]+|\d*\.?\d+(?:[eE][+-]?\d+)?)/.exec(this.src.slice(this.pos))
    if (num) {
      this.pos += num[0].length
      return Number(num[0])
    }

    // Bezeichner - als Rohtext durchreichen. MDT nutzt das fuer lokalisierte
    // Namen in der Form L["Schluessel"], deshalb muessen angehaengte
    // Index-Zugriffe mitgelesen werden, sonst verschluckt sich der Parser an
    // der schliessenden Klammer.
    const ident = /^[A-Za-z_][A-Za-z0-9_.]*/.exec(this.src.slice(this.pos))
    if (ident) {
      this.pos += ident[0].length
      const ref = { __ref: ident[0] }
      for (;;) {
        this.skip()
        if (this.src[this.pos] !== '[') break
        this.pos++
        ref.__index = this.parseValue()
        this.expect(']')
      }
      return ref
    }

    this.error(`Unerwartetes Zeichen "${ch}"`)
  }

  /**
   * Liest eine Tabelle. Ergebnis ist ein Objekt; Array-Eintraege landen unter
   * ihrem numerischen Schluessel, damit MDTs Luecken (z. B. [0]) erhalten
   * bleiben.
   */
  parseTable() {
    this.expect('{')
    const out = {}
    let arrayIndex = 1

    for (;;) {
      this.skip()
      const ch = this.src[this.pos]
      if (ch === undefined) this.error('Tabelle nicht geschlossen')
      if (ch === '}') {
        this.pos++
        return out
      }

      if (ch === '[') {
        // [schluessel] = wert
        this.pos++
        const key = this.parseValue()
        this.expect(']')
        this.expect('=')
        out[key] = this.parseValue()
      } else {
        const named = /^([A-Za-z_][A-Za-z0-9_]*)\s*=/.exec(this.src.slice(this.pos))
        if (named) {
          this.pos += named[0].length
          out[named[1]] = this.parseValue()
        } else {
          out[arrayIndex++] = this.parseValue()
        }
      }

      this.skip()
      if (this.src[this.pos] === ',' || this.src[this.pos] === ';') this.pos++
    }
  }
}

/**
 * Findet `<zuweisung> = {` und liest die Tabelle dahinter.
 *
 * @param {string} src Quelltext
 * @param {RegExp} assignment Muster mit `{` am Ende, global geflaggt
 * @returns {Array<{ match: RegExpExecArray, value: object }>}
 */
export function findTables(src, assignment) {
  const results = []
  let m
  assignment.lastIndex = 0
  while ((m = assignment.exec(src)) !== null) {
    const brace = src.indexOf('{', m.index + m[0].length - 1)
    if (brace === -1) continue
    const { value, end } = parseTableAt(src, brace)
    results.push({ match: m, value })
    assignment.lastIndex = end
  }
  return results
}
