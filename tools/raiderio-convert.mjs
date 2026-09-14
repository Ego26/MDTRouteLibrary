// Macht aus einem Raider.IO-Lauf eine Route, die MDT versteht.
//
// Das Problem: die API nennt je Gegner nur Name, Kraeftewert und Todeszeit.
// Welcher der neun "Sandswept Hunter" im Dungeon gemeint war, steht nirgends.
// MDT braucht aber genau das - eine Route ist eine Liste von Klonschluesseln.
//
// Also rekonstruieren wir sie. Die Grundlage ist stark:
//   * Die Reihenfolge der Pulls steht fest (aus den Todeszeiten).
//   * Jeder Klon stirbt hoechstens einmal, die Zuordnung ist also eine
//     Zuweisung ohne Wiederholung.
//   * Eine Gruppe laeuft einen zusammenhaengenden Weg. Wer gerade am Eingang
//     stand, pullt als naechstes nicht die Gegner vor dem letzten Boss.
//
// Daraus wird ein gieriges Verfahren: Pull fuer Pull den Satz noch freier
// Klone waehlen, der eng beieinander und nah am zuletzt besuchten Ort liegt.
//
// Das ist eine Rekonstruktion, keine Aufzeichnung. Die Route traegt deshalb
// reconstructed = true, und das Addon sagt es dem Nutzer. Wo Klone dicht
// beieinanderstehen, kann die Zuordnung danebenliegen; die Reihenfolge der
// Pulls und ihre Zusammensetzung stimmen in jedem Fall.

/** Quadrierter Abstand - Wurzeln braucht niemand, der nur vergleicht. */
function dist2(a, b) {
  const dx = a.x - b.x
  const dy = a.y - b.y
  return dx * dx + dy * dy
}

/**
 * Ein Ebenenwechsel kostet mehr als jeder Weg innerhalb einer Ebene.
 * Die Karte ist 840 x 555 gross, die laengste Strecke also rund 1000.
 */
const SUBLEVEL_PENALTY = 4000 * 4000

/** Abstand mit Aufschlag fuer die falsche Unterebene. */
function cost(from, to) {
  return dist2(from, to) + (from.sublevel === to.sublevel ? 0 : SUBLEVEL_PENALTY)
}

/**
 * Ordnet den Pulls eines Laufs die Klonschluessel zu.
 *
 * @param {Array<{enemies: Array<{enemy:number,npc:number,count:number}>}>} pulls
 * @param {object} dungeon Dungeon aus mdt-dungeons.mjs
 * @returns {{ pulls: object[], report: object }}
 */
export function assignClones(pulls, dungeon) {
  const byIndex = new Map(dungeon.enemies.map((e) => [e.index, e]))

  // Noch nicht vergebene Klone je Gegnerindex.
  const free = new Map()
  for (const enemy of dungeon.enemies) {
    free.set(enemy.index, new Set(enemy.cloneKeys ?? []))
  }

  const posOf = (index, clone) => byIndex.get(index)?.clonePos?.[clone] ?? null

  const report = { shortfall: 0, dropped: 0, spread: 0, pulls: 0 }
  let current = null
  const out = []

  for (const pull of pulls) {
    // Was steht ueberhaupt noch zur Auswahl?
    const wanted = []
    for (const entry of pull.enemies ?? []) {
      const pool = free.get(entry.enemy)
      const candidates = pool
        ? [...pool].map((clone) => ({ clone, pos: posOf(entry.enemy, clone) })).filter((c) => c.pos)
        : []

      if (candidates.length === 0) {
        report.dropped += entry.count
        continue
      }
      if (entry.count > candidates.length) report.shortfall += entry.count - candidates.length

      wanted.push({ entry, candidates, take: Math.min(entry.count, candidates.length) })
    }
    if (wanted.length === 0) continue

    // Ein Ankerpunkt fuer den Pull. Beim ersten gibt es keinen Vorgaenger -
    // dann faengt der am staerksten gebundene Gegner an, denn wo der steht,
    // ist am wenigsten Auslegungssache.
    let anchor
    if (current) {
      let best = null
      for (const group of wanted) {
        for (const candidate of group.candidates) {
          const c = cost(current, candidate.pos)
          if (!best || c < best.c) best = { c, pos: candidate.pos }
        }
      }
      anchor = best.pos
    } else {
      anchor = [...wanted].sort((a, b) => a.candidates.length - b.candidates.length)[0].candidates[0].pos
    }

    // Zwei Durchgaenge: erst um den Anker herum waehlen, dann um den
    // Schwerpunkt des Ergebnisses noch einmal. Das zieht Pulls zusammen, bei
    // denen der Anker am Rand lag.
    let picked = null
    for (let pass = 0; pass < 2; pass += 1) {
      picked = wanted.map((group) => ({
        entry: group.entry,
        clones: [...group.candidates]
          .sort((a, b) => cost(anchor, a.pos) - cost(anchor, b.pos))
          .slice(0, group.take),
      }))

      let sx = 0
      let sy = 0
      let n = 0
      const levels = new Map()
      for (const group of picked) {
        for (const c of group.clones) {
          sx += c.pos.x
          sy += c.pos.y
          n += 1
          levels.set(c.pos.sublevel, (levels.get(c.pos.sublevel) ?? 0) + 1)
        }
      }
      if (n === 0) break

      const sublevel = [...levels.entries()].sort((a, b) => b[1] - a[1])[0][0]
      const centre = { x: sx / n, y: sy / n, sublevel }
      if (pass === 0) anchor = centre
      else current = centre
    }
    if (!picked) continue

    // Erst jetzt verbrauchen - waehrend der Durchgaenge waere es zu frueh.
    const enemies = []
    const all = []
    for (const group of picked) {
      if (group.clones.length === 0) continue
      const pool = free.get(group.entry.enemy)
      const keys = []
      for (const c of group.clones) {
        pool.delete(c.clone)
        keys.push(c.clone)
        all.push(c.pos)
      }
      keys.sort((a, b) => a - b)
      enemies.push({ enemy: group.entry.enemy, npc: group.entry.npc, clones: keys })
    }
    if (enemies.length === 0) continue

    // Wie weit lagen die Gegner eines Pulls auseinander? Ein Mass dafuer, wie
    // gut die Rekonstruktion getroffen hat - echte Pulls sind eng.
    let widest = 0
    for (let i = 0; i < all.length; i += 1) {
      for (let j = i + 1; j < all.length; j += 1) {
        widest = Math.max(widest, dist2(all[i], all[j]))
      }
    }
    report.spread += Math.sqrt(widest)
    report.pulls += 1

    enemies.sort((a, b) => a.enemy - b.enemy)
    out.push({ enemies })
  }

  if (report.pulls > 0) report.spread = Math.round(report.spread / report.pulls)
  return { pulls: out, report }
}

/** mm:ss aus Sekunden. */
function clock(seconds) {
  const m = Math.floor(seconds / 60)
  return `${m}:${String(seconds - m * 60).padStart(2, '0')}`
}

/**
 * Macht aus einem geholten Lauf eine fertige Route.
 *
 * @param {object} run Ausgabe von raiderio-sync.mjs
 * @param {object} dungeon Dungeon aus mdt-dungeons.mjs
 * @returns {{ route: object|null, report: object }}
 */
export function convertRun(run, dungeon) {
  const { pulls, report } = assignClones(run.pulls ?? [], dungeon)
  if (pulls.length === 0) return { route: null, report }

  // Gegnerkraefte nach MDTs Tabelle - dieselbe Rechnung, die das Addon spaeter
  // anzeigt und die MDT selbst anstellt.
  const byIndex = new Map(dungeon.enemies.map((e) => [e.index, e]))
  let forces = 0
  for (const pull of pulls) {
    for (const entry of pull.enemies) {
      forces += (byIndex.get(entry.enemy)?.count ?? 0) * entry.clones.length
    }
  }
  report.forces = forces
  report.required = run.enemyForcesRequired ?? dungeon.totalCount

  const tank = (run.roster ?? []).find((member) => member.role === 'tank')

  return {
    route: {
      id: run.id,
      source: 'raider.io',
      // Der Titel steht in einer Zeile und muss den Lauf unterscheidbar
      // machen: Stufe und Zeit tun das. Der Dungeonname steht ohnehin in der
      // Gruppenueberschrift darueber.
      title: `+${run.keyLevel} · ${clock(run.clearSeconds)}`,
      // In der Autorenspalte steht sonst, wer die Route gebaut hat. Hier ist
      // das niemand - aber wer getankt hat, praegt eine Route am staerksten.
      author: tank && tank.spec ? `${tank.spec} ${tank.class}` : null,
      url: run.url,
      challengeModeId: run.challengeModeId,
      dungeonEnglishName: run.dungeonEnglishName,
      mdtDungeonIdx: run.mdtDungeonIdx,
      sublevel: 1,
      // Damit der vorhandene Stufenfilter greift, ohne Sonderfall.
      keyLevelMin: run.keyLevel,
      keyLevel: run.keyLevel,
      clearSeconds: run.clearSeconds,
      onTime: run.onTime || undefined,
      rank: run.rank ?? undefined,
      // Nur ein Rang aus der Weltrangliste ist ein Weltrang. Der untere
      // Bereich kommt notfalls aus einer kuerzeren Liste, und das Addon soll
      // dann nicht das Falsche behaupten.
      region: run.region && run.region !== 'world' ? run.region : undefined,
      completedAt: run.completedAt ?? undefined,
      roster: run.roster && run.roster.length > 0 ? run.roster : undefined,
      enemyForces: forces,
      enemyForcesRequired: run.enemyForcesRequired,
      // Ehrlich bleiben: die Klonzuordnung ist gerechnet, nicht gemessen.
      reconstructed: true,
      pulls,
    },
    report,
  }
}
