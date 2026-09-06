// Ein CBOR-Leser (RFC 8949), so klein wie moeglich.
//
// Gebraucht wird er fuer MDTs eigene Exportstrings: die packt MDT seit 6.2 mit
// C_EncodingUtil.SerializeCBOR (siehe MythicDungeonTools/Modules/Transmission.lua).
// Node bringt keinen CBOR-Leser mit, und eine fremde Bibliothek wollen wir hier
// nicht - das Repository kommt ohne node_modules aus, und der Release-Lauf soll
// nicht an einem npm-Ausfall haengen.
//
// Geschrieben wird nichts: wir lesen fremde Strings, wir erzeugen keine.
// Ausnahme ist encode() ganz unten, das ausschliesslich die Pruefung benutzt,
// um den Leser gegen selbst gebaute Werte zu halten.

/** Ein Zeiger, der beim Lesen mitwandert. */
class Reader {
  constructor(buf) {
    this.buf = buf
    this.at = 0
  }

  need(n) {
    if (this.at + n > this.buf.length) throw new Error('CBOR: Daten enden mitten im Wert')
    return this.at
  }

  u8() {
    const at = this.need(1)
    this.at += 1
    return this.buf[at]
  }

  bytes(n) {
    const at = this.need(n)
    this.at += n
    return this.buf.subarray(at, at + n)
  }
}

/**
 * Liest die Laengenangabe eines Kopfbytes.
 *
 * Die unteren fuenf Bit sind entweder der Wert selbst (0-23), die Anzahl
 * folgender Laengenbytes (24-27) oder die Ansage "unbestimmt lang" (31).
 *
 * @param {Reader} r
 * @param {number} info untere fuenf Bit des Kopfbytes
 * @returns {number|bigint|null} null heisst "unbestimmt lang"
 */
function readLength(r, info) {
  if (info < 24) return info
  if (info === 24) return r.u8()
  if (info === 25) {
    const b = r.bytes(2)
    return (b[0] << 8) | b[1]
  }
  if (info === 26) {
    const b = r.bytes(4)
    return b[0] * 0x1000000 + ((b[1] << 16) | (b[2] << 8) | b[3])
  }
  if (info === 27) {
    const b = r.bytes(8)
    let value = 0n
    for (const byte of b) value = (value << 8n) | BigInt(byte)
    // Alles, was in eine Zahl passt, kommt auch als Zahl zurueck - sonst
    // stolpert jeder Aufrufer ueber ein BigInt, das er nie erwartet hat.
    return value <= BigInt(Number.MAX_SAFE_INTEGER) ? Number(value) : value
  }
  if (info === 31) return null
  throw new Error(`CBOR: unzulaessige Laengenangabe ${info}`)
}

/** IEEE-754 mit halber Genauigkeit - Node kann das nicht von sich aus. */
function readHalf(bytes) {
  const bits = (bytes[0] << 8) | bytes[1]
  const sign = bits & 0x8000 ? -1 : 1
  const exponent = (bits >> 10) & 0x1f
  const fraction = bits & 0x3ff

  if (exponent === 0) return sign * 2 ** -24 * fraction
  if (exponent === 0x1f) return fraction ? Number.NaN : sign * Number.POSITIVE_INFINITY
  return sign * 2 ** (exponent - 25) * (1024 + fraction)
}

const BREAK = Symbol('break')

/**
 * Liest genau einen Wert.
 *
 * @param {Reader} r
 * @returns {*}
 */
function readValue(r) {
  const head = r.u8()
  const major = head >> 5
  const info = head & 0x1f

  switch (major) {
    // 0: nicht negative ganze Zahl
    case 0:
      return readLength(r, info)

    // 1: negative ganze Zahl, abgelegt als -1 - n
    case 1: {
      const n = readLength(r, info)
      return typeof n === 'bigint' ? -1n - n : -1 - n
    }

    // 2: Bytefolge
    case 2: {
      const n = readLength(r, info)
      if (n === null) return Buffer.concat(readChunks(r, 2))
      return Buffer.from(r.bytes(Number(n)))
    }

    // 3: Text
    case 3: {
      const n = readLength(r, info)
      if (n === null) return Buffer.concat(readChunks(r, 3)).toString('utf8')
      return r.bytes(Number(n)).toString('utf8')
    }

    // 4: Liste
    case 4: {
      const n = readLength(r, info)
      const out = []
      if (n === null) {
        for (;;) {
          const item = readValue(r)
          if (item === BREAK) break
          out.push(item)
        }
        return out
      }
      for (let i = 0; i < Number(n); i += 1) out.push(readValue(r))
      return out
    }

    // 5: Zuordnung. Kommt als einfaches Objekt zurueck, mit Zahlenschluesseln
    // als Zeichenketten - genau wie Lua-Tabellen in diesem Projekt sonst auch
    // gelesen werden.
    case 5: {
      const n = readLength(r, info)
      const out = {}
      if (n === null) {
        for (;;) {
          const key = readValue(r)
          if (key === BREAK) break
          out[String(key)] = readValue(r)
        }
        return out
      }
      for (let i = 0; i < Number(n); i += 1) {
        const key = readValue(r)
        out[String(key)] = readValue(r)
      }
      return out
    }

    // 6: Markierung. Wir kennen keine, also lesen wir den Inhalt und lassen
    // die Markierung fallen - besser als abzubrechen.
    case 6:
      readLength(r, info)
      return readValue(r)

    // 7: alles Uebrige
    case 7:
      if (info === 20) return false
      if (info === 21) return true
      if (info === 22) return null
      if (info === 23) return undefined
      if (info === 25) return readHalf(r.bytes(2))
      if (info === 26) return Buffer.from(r.bytes(4)).readFloatBE(0)
      if (info === 27) return Buffer.from(r.bytes(8)).readDoubleBE(0)
      if (info === 31) return BREAK
      // Einfache Werte 0-19 und 32-255 haben keine Entsprechung; als Zahl
      // durchreichen ist ehrlicher als sie zu verschlucken.
      return readLength(r, info)

    default:
      throw new Error(`CBOR: unbekannter Haupttyp ${major}`)
  }
}

/** Sammelt die Teile einer unbestimmt langen Byte- oder Textfolge. */
function readChunks(r, major) {
  const parts = []
  for (;;) {
    const head = r.buf[r.need(1)]
    if (head === 0xff) {
      r.at += 1
      return parts
    }
    if (head >> 5 !== major) throw new Error('CBOR: falscher Teiltyp in unbestimmt langer Folge')
    const part = readValue(r)
    parts.push(typeof part === 'string' ? Buffer.from(part, 'utf8') : part)
  }
}

/**
 * Liest einen CBOR-Wert aus einem Puffer.
 *
 * @param {Buffer} buffer
 * @returns {*}
 */
export function decode(buffer) {
  const r = new Reader(Buffer.from(buffer))
  const value = readValue(r)
  if (value === BREAK) throw new Error('CBOR: Abbruchmarke ohne offene Folge')
  return value
}

/**
 * Schreibt einen Wert als CBOR.
 *
 * Nur fuer die Pruefung da: sie haelt damit den Leser gegen selbst erzeugte
 * Werte. Im Betrieb wird nichts geschrieben.
 *
 * Mit textAsBytes werden Zeichenketten als Bytefolge abgelegt statt als Text -
 * genau so, wie Blizzards SerializeCBOR es tut, weil Lua zwischen beidem nicht
 * unterscheidet. An einem echten MDT-Export gemessen. Die Pruefung braucht das,
 * um die Verarbeitung gegen die Wirklichkeit zu halten statt gegen die
 * gutmuetige Variante.
 *
 * @param {*} value
 * @param {{textAsBytes?: boolean}} [options]
 * @returns {Buffer}
 */
export function encode(value, options = {}) {
  const parts = []
  const textMajor = options.textAsBytes ? 2 : 3

  const head = (major, n) => {
    if (n < 24) return parts.push(Buffer.from([(major << 5) | n]))
    if (n < 0x100) return parts.push(Buffer.from([(major << 5) | 24, n]))
    if (n < 0x10000) return parts.push(Buffer.from([(major << 5) | 25, n >> 8, n & 0xff]))
    const b = Buffer.alloc(5)
    b[0] = (major << 5) | 26
    b.writeUInt32BE(n, 1)
    return parts.push(b)
  }

  const write = (v) => {
    if (v === null) return parts.push(Buffer.from([0xf6]))
    if (v === undefined) return parts.push(Buffer.from([0xf7]))
    if (typeof v === 'boolean') return parts.push(Buffer.from([v ? 0xf5 : 0xf4]))

    if (typeof v === 'number') {
      if (Number.isSafeInteger(v)) return v >= 0 ? head(0, v) : head(1, -1 - v)
      const b = Buffer.alloc(9)
      b[0] = 0xfb
      b.writeDoubleBE(v, 1)
      return parts.push(b)
    }

    if (typeof v === 'string') {
      const bytes = Buffer.from(v, 'utf8')
      head(textMajor, bytes.length)
      return parts.push(bytes)
    }

    if (Buffer.isBuffer(v)) {
      head(2, v.length)
      return parts.push(v)
    }

    if (Array.isArray(v)) {
      head(4, v.length)
      for (const item of v) write(item)
      return undefined
    }

    const entries = Object.entries(v)
    head(5, entries.length)
    for (const [key, item] of entries) {
      write(key)
      write(item)
    }
    return undefined
  }

  write(value)
  return Buffer.concat(parts)
}
