// Zugang zu Warcraftlogs und die Suche nach dem Bericht zu einem Lauf.
//
// Warcraftlogs vergibt seine Zugangsdaten selbst: auf warcraftlogs.com/api/clients
// eine Anwendung anlegen, fertig. Kein Antrag, keine Freigabe, 3600 Punkte je
// Stunde. Genau das macht diesen Weg gangbar, wo Raider.IO und keystone.guru
// ihre Routen hinter einem Schluessel halten, den es nicht zu holen gibt.

import { readFileSync } from 'node:fs'

/** Liest einen Wert aus der Umgebung oder aus .env. */
export function env(name) {
  if (process.env[name]) return process.env[name].trim()
  try {
    const text = readFileSync('.env', 'utf8').replace(/^﻿/, '').replace(/\r\n?/g, '\n')
    for (const zeile of text.split('\n')) {
      const treffer = zeile.match(new RegExp('^\s*' + name + '\s*=\s*(.*)$'))
      if (treffer) return treffer[1].trim().replace(/^["']|["']$/g, '')
    }
  } catch {}
  return null
}

/** Meldet sich an und gibt eine Abfragefunktion zurueck. */
export async function anmelden() {
  const id = env('WCL_CLIENT_ID')
  const secret = env('WCL_CLIENT_SECRET')
  if (!id || !secret) throw new Error('WCL_CLIENT_ID oder WCL_CLIENT_SECRET fehlt in .env')

  const antwort = await fetch('https://www.warcraftlogs.com/oauth/token', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      Authorization: 'Basic ' + Buffer.from(id + ':' + secret).toString('base64'),
    },
    body: 'grant_type=client_credentials',
  })
  if (!antwort.ok) throw new Error('Anmeldung: HTTP ' + antwort.status)
  const marke = (await antwort.json()).access_token

  return async function gql(query, variables = {}) {
    for (let versuch = 1; versuch <= 4; versuch += 1) {
      const res = await fetch('https://www.warcraftlogs.com/api/v2/client', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: 'Bearer ' + marke },
        body: JSON.stringify({ query, variables }),
      })
      // 429 heisst bei Warcraftlogs fast immer: 3600 Punkte in dieser Stunde
      // verbraucht. Da hilft kein kurzes Nachfassen - der Zaehler springt
      // erst zur vollen Stunde zurueck. Also warten, bis er es tut.
      if (res.status === 429) {
        const wartezeit = Number(res.headers.get('retry-after')) * 1000
        await new Promise((f) => setTimeout(f, wartezeit > 0 ? wartezeit + 5000 : 300000))
        continue
      }
      if (res.status >= 500) {
        await new Promise((f) => setTimeout(f, versuch * 3000))
        continue
      }
      const body = await res.json()
      // Ein fehlender Charakter ist kein Fehler des Aufrufs - Warcraftlogs
      // meldet ihn als Fehler, meint aber "kenne ich nicht".
      if (body.errors) {
        const text = JSON.stringify(body.errors)
        if (/does not exist|not found|No character/i.test(text)) return null
        throw new Error(text.slice(0, 400))
      }
      return body.data
    }
    throw new Error('Warcraftlogs antwortet nicht')
  }
}

/**
 * Sucht den Warcraftlogs-Bericht zu einem Raider.IO-Lauf.
 *
 * Raider.IO nennt den Bericht nirgends - weder in den Ranglisten noch in den
 * Laufdetails. Aber es nennt den Kader mit Realm und Region und den Zeitpunkt.
 * Warcraftlogs fuehrt zu jedem Charakter seine letzten Berichte; wessen
 * Bericht den Zeitpunkt umschliesst, ist der gesuchte.
 *
 * Bestaetigt wird ueber die Laufzeit: der Kampf muss dieselbe Schluesselstufe
 * und dieselbe Dauer haben. Zwei Laeufe derselben Gruppe im selben Bericht
 * unterscheiden sich darin immer, und eine Uebereinstimmung auf die Sekunde
 * ist kein Zufall.
 */
export async function berichtFinden(gql, lauf, merker = new Map()) {
  const ziel = Date.parse(lauf.completed_at)
  if (!Number.isFinite(ziel)) return null

  const kader = (lauf.roster ?? []).filter((m) => m.name && m.realm && m.region)
  const schluessel = (m) => m.region + '/' + m.realm + '/' + m.name

  // Alle fuenf Charaktere in einer einzigen Anfrage, ueber Aliase. Einzeln
  // gefragt war das der Engpass: das Holen der Ereignisse dauert elf Sekunden,
  // die Suche davor dauerte eine Minute.
  const offen = kader.filter((m) => !merker.has(schluessel(m)))
  if (offen.length) {
    const teile = offen.map((m, i) =>
      'c' + i + ': character(name: $n' + i + ', serverSlug: $s' + i + ', serverRegion: $r' + i + ') ' +
      '{ recentReports(limit: 40) { data { code startTime endTime } } }')
    const kopf = offen.map((m, i) =>
      '$n' + i + ': String!, $s' + i + ': String!, $r' + i + ': String!').join(', ')
    const werte = {}
    for (const [i, m] of offen.entries()) {
      werte['n' + i] = m.name
      werte['s' + i] = m.realm
      werte['r' + i] = m.region
    }

    // Ein unbekannter Charakter laesst Warcraftlogs die ganze Anfrage als
    // Fehler melden. Dann eben einzeln - das trifft wenige Laeufe.
    let d = null
    try {
      d = await gql('query (' + kopf + ') { characterData { ' + teile.join(' ') + ' } }', werte)
    } catch {}

    if (d) {
      for (const [i, m] of offen.entries()) {
        merker.set(schluessel(m), d.characterData?.['c' + i]?.recentReports?.data ?? [])
      }
    } else {
      for (const [i, m] of offen.entries()) {
        const e = await gql(`query ($name: String!, $server: String!, $region: String!) {
          characterData { character(name: $name, serverSlug: $server, serverRegion: $region) {
            recentReports(limit: 40) { data { code startTime endTime } }
          } }
        }`, { name: m.name, server: m.realm, region: m.region }).catch(() => null)
        merker.set(schluessel(m), e?.characterData?.character?.recentReports?.data ?? [])
      }
    }
  }

  // Der Lauf endete waehrend des Berichts. Eine Stunde Zugabe, weil der
  // Zeitpunkt bei Raider.IO auf die Sekunde gerundet in UTC steht und der
  // Bericht erst nach dem letzten Kampf schliesst.
  const kandidaten = []
  for (const m of kader) {
    for (const b of merker.get(schluessel(m)) ?? []) {
      if (b.startTime <= ziel && ziel <= b.endTime + 3600000 && !kandidaten.includes(b.code)) {
        kandidaten.push(b.code)
      }
    }
  }
  if (!kandidaten.length) return null

  // Auch die Berichte in einem Zug, aus demselben Grund.
  const kopf = kandidaten.map((c, i) => '$c' + i + ': String!').join(', ')
  const teile = kandidaten.map((c, i) =>
    'b' + i + ': report(code: $c' + i + ') { fights(translate: false) { id keystoneLevel keystoneTime } }')
  const werte = {}
  for (const [i, c] of kandidaten.entries()) werte['c' + i] = c

  const d = await gql('query (' + kopf + ') { reportData { ' + teile.join(' ') + ' } }', werte)
    .catch(() => null)
  if (!d) return null

  for (const [i, c] of kandidaten.entries()) {
    for (const f of d.reportData?.['b' + i]?.fights ?? []) {
      if (f.keystoneLevel !== lauf.mythic_level) continue
      if (Math.abs((f.keystoneTime ?? 0) - lauf.clear_time_ms) > 2000) continue
      return { code: c, fight: f.id }
    }
  }
  return null
}
