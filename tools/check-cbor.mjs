// Prueft den CBOR-Leser gegen die Beispiele aus RFC 8949, Anhang A.
//
// Warum eigens geprueft: der Leser ist selbst geschrieben, weil das Repository
// ohne node_modules auskommt. Ein Fehler darin faellt sonst erst auf, wenn
// jemand eine echte Route einreicht und sie stillschweigend falsch ankommt -
// ein verrutschter Klonindex sieht aus wie eine schlecht gebaute Route, nicht
// wie ein Programmfehler.
//
// Die Vektoren stammen aus dem Standard selbst, nicht aus meinem eigenen
// Schreiber - sonst pruefte sich der Leser nur gegen die eigene Auffassung.
//
// Aufruf:
//   node tools/check-cbor.mjs

import { decode, encode } from './cbor.mjs'

let failed = 0

function check(label, got, want) {
  const ok = JSON.stringify(got) === JSON.stringify(want)
  if (!ok) failed += 1
  console.log(`  ${ok ? 'ok  ' : 'FEHL'}  ${label}${ok ? '' : `   erwartet ${JSON.stringify(want)}, bekam ${JSON.stringify(got)}`}`)
}

/** Liest einen Vektor in Hex-Schreibweise, wie ihn der Standard notiert. */
function fromHex(hex) {
  return Buffer.from(hex.replace(/\s+/g, ''), 'hex')
}

// ---- RFC 8949, Anhang A -------------------------------------------------
console.log('Ganze Zahlen')
check('0', decode(fromHex('00')), 0)
check('1', decode(fromHex('01')), 1)
check('10', decode(fromHex('0a')), 10)
check('23', decode(fromHex('17')), 23)
check('24', decode(fromHex('1818')), 24)
check('100', decode(fromHex('1864')), 100)
check('1000', decode(fromHex('1903e8')), 1000)
check('1000000', decode(fromHex('1a000f4240')), 1000000)
check('1000000000000', decode(fromHex('1b000000e8d4a51000')), 1000000000000)
check('-1', decode(fromHex('20')), -1)
check('-10', decode(fromHex('29')), -10)
check('-100', decode(fromHex('3863')), -100)
check('-1000', decode(fromHex('3903e7')), -1000)

console.log('Gleitkomma')
check('0.0 (halb)', decode(fromHex('f90000')), 0)
check('1.0 (halb)', decode(fromHex('f93c00')), 1)
check('1.5 (halb)', decode(fromHex('f93e00')), 1.5)
check('-4.0 (halb)', decode(fromHex('f9c400')), -4)
check('100000.0 (einfach)', decode(fromHex('fa47c35000')), 100000)
check('1.1 (doppelt)', decode(fromHex('fb3ff199999999999a')), 1.1)
check('Unendlich', decode(fromHex('f97c00')), Number.POSITIVE_INFINITY)
check('NaN', Number.isNaN(decode(fromHex('f97e00'))), true)

console.log('Einfache Werte')
check('false', decode(fromHex('f4')), false)
check('true', decode(fromHex('f5')), true)
check('null', decode(fromHex('f6')), null)
check('undefined', decode(fromHex('f7')), undefined)

console.log('Text und Bytes')
check('leerer Text', decode(fromHex('60')), '')
check('"a"', decode(fromHex('6161')), 'a')
check('"IETF"', decode(fromHex('6449455446')), 'IETF')
check('"\\u00fc" (mehrbytig)', decode(fromHex('62c3bc')), 'ü')
check('"\\u6c34"', decode(fromHex('63e6b0b4')), '水')
check('Bytefolge', [...decode(fromHex('4401020304'))], [1, 2, 3, 4])
check('Text in Teilen', decode(fromHex('7f657374726561646d696e67ff')), 'streaming')

console.log('Listen und Zuordnungen')
check('leere Liste', decode(fromHex('80')), [])
check('[1,2,3]', decode(fromHex('83010203')), [1, 2, 3])
check('verschachtelt', decode(fromHex('8301820203820405')), [1, [2, 3], [4, 5]])
check('leere Zuordnung', decode(fromHex('a0')), {})
check('{1:2, 3:4}', decode(fromHex('a201020304')), { 1: 2, 3: 4 })
check('{"a":1,"b":[2,3]}', decode(fromHex('a26161016162820203')), { a: 1, b: [2, 3] })
check('["a",{"b":"c"}]', decode(fromHex('826161a161626163')), ['a', { b: 'c' }])
check('Liste unbestimmt lang', decode(fromHex('9fff')), [])
check('Liste unbestimmt, gefuellt', decode(fromHex('9f018202039f0405ffff')), [1, [2, 3], [4, 5]])
check('Zuordnung unbestimmt lang', decode(fromHex('bf61610161629f0203ffff')), { a: 1, b: [2, 3] })
check('lange Liste', decode(fromHex('98190102030405060708090a0b0c0d0e0f101112131415161718181819')).length, 25)

console.log('Markierungen werden übergangen')
// Markierung 0 (Zeitstempel als Text) um "2013-03-21T20:04:00Z"
check('Inhalt kommt durch', decode(fromHex('c074323031332d30332d32315432303a30343a30305a')), '2013-03-21T20:04:00Z')

console.log('Abgeschnittene Daten werden bemerkt')
for (const [label, hex] of [['Zahl ohne Bytes', '19'], ['Text zu kurz', '6449455'], ['Liste zu kurz', '8301']]) {
  let threw = false
  try {
    decode(fromHex(hex.length % 2 ? `${hex}0` : hex))
  } catch {
    threw = true
  }
  check(label, threw, true)
}

// ---- Hin und zurueck ----------------------------------------------------
// Der Schreiber ist nur fuer diese Pruefung da. Er belegt nicht, dass wir
// Blizzards Ausgabe verstehen - das koennen nur die Vektoren oben und ein
// echter MDT-String. Er faengt aber Fehler in zusammengesetzten Strukturen,
// wie sie ein Preset hat.
console.log('Hin und zurück')
{
  const preset = {
    text: 'Altar of Fangs – Meta 18+',
    difficulty: 18,
    uid: 'aBc123',
    value: {
      currentDungeonIdx: 161,
      currentSublevel: 1,
      pulls: {
        1: { color: 'ff0000', 3: [1, 2, 3], 7: [1] },
        2: { color: '00ff00', 4: [2, 5, 23] },
      },
    },
  }
  const back = decode(encode(preset))
  check('Preset überlebt', JSON.stringify(back), JSON.stringify(preset))
  check('Umlaute überleben', decode(encode('Grün – schön')), 'Grün – schön')
  check('tiefe Verschachtelung', decode(encode({ a: { b: { c: [1, { d: 2 }] } } })), { a: { b: { c: [1, { d: 2 }] } } })
  check('negative Zahlen', decode(encode([-1, -100, -1000])), [-1, -100, -1000])
  check('grosse Zahlen', decode(encode(123456789)), 123456789)
}

console.log('Blizzards Schreibweise')
{
  // Lua unterscheidet Text und Bytes nicht. Blizzards SerializeCBOR legt
  // deshalb jede Zeichenkette als Bytefolge ab - an einem echten MDT-Export
  // gemessen. Der Leser muss sie als Buffer liefern, nicht als String, damit
  // die Umwandlung in mdt-string.mjs greift.
  const asBytes = encode({ text: 'Tactyks PUG Friendly', n: 22 }, { textAsBytes: true })
  const back = decode(asBytes)
  check('Schluessel werden zu Text', Object.keys(back).sort().join(','), 'n,text')
  check('Wert bleibt Bytefolge', Buffer.isBuffer(back.text), true)
  check('Bytefolge ist lesbar', back.text.toString('utf8'), 'Tactyks PUG Friendly')
  check('Zahlen bleiben Zahlen', back.n, 22)

  // Zum Vergleich der uebliche Weg.
  check('als Text bleibt Text', typeof decode(encode({ text: 'x' })).text, 'string')
}

console.log(failed ? `\n${failed} Prüfungen fehlgeschlagen` : '\nAlle Prüfungen bestanden')
process.exit(failed ? 1 : 0)
