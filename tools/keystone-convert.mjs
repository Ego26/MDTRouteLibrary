// Wandelt eine keystone.guru-Route in unser normalisiertes Routenformat.
//
// ---------------------------------------------------------------------------
// Die offene Frage: was ist `mdtIndex`?
// ---------------------------------------------------------------------------
// Die API liefert pro Gegner in einem Pull { npcId, mdtIndex, enemyForces }.
// MDT dagegen adressiert Gegner mit ZWEI Zahlen: dem Gegnerindex innerhalb des
// Dungeons und dem Klonindex innerhalb dieses Gegners
// (pulls[i][enemyIdx] = { cloneIdx, ... }).
//
// Zwei Lesarten sind moeglich:
//   "clone"  - mdtIndex ist der Klonindex, npcId bestimmt den Gegner.
//              Dafuer spricht, dass enemyForces pro Eintrag angegeben wird -
//              also je EIN Mob, nicht eine ganze Gegnergruppe.
//   "enemy"  - mdtIndex ist der Gegnerindex, der Klon bleibt offen.
//
// Voreingestellt ist "clone". Welche Lesart stimmt, laesst sich ohne API-Key
// nicht endgueltig klaeren - deshalb rechnet validateRoute() die Gegnerkraefte
// gegen und meldet die Trefferquote. Bei der falschen Lesart faellt sie sofort
// auf nahe null. Umschalten mit --interpretation enemy.

/**
 * Baut einen Index npcId -> Gegnereintraege eines MDT-Dungeons.
 *
 * @param {object} dungeon Dungeon aus mdt-dungeons.mjs
 * @returns {Map<number, object[]>}
 */
function indexEnemiesByNpc(dungeon) {
  const byNpc = new Map()
  for (const enemy of dungeon.enemies) {
    if (enemy.id == null) continue
    const list = byNpc.get(enemy.id)
    if (list) list.push(enemy)
    else byNpc.set(enemy.id, [enemy])
  }
  return byNpc
}

/**
 * Loest einen keystone-Gegner auf MDTs (enemyIdx, cloneIdx) auf.
 *
 * @param {object} pullEnemy { npcId, mdtIndex, enemyForces }
 * @param {Map<number, object[]>} byNpc
 * @param {object} dungeon
 * @param {'clone'|'enemy'} interpretation
 * @returns {{ enemy: number, clone: number, forces: number }|null}
 */
function resolveEnemy(pullEnemy, byNpc, dungeon, interpretation) {
  const { npcId, mdtIndex } = pullEnemy

  if (interpretation === 'enemy') {
    const entry = dungeon.enemies.find((e) => e.index === mdtIndex)
    if (!entry) return null
    // Ohne Klonangabe bleibt nur der erste Klon - bewusst verlustbehaftet.
    return { enemy: entry.index, clone: entry.cloneKeys?.[0] ?? 1, forces: entry.count }
  }

  const candidates = byNpc.get(npcId)
  if (!candidates || candidates.length === 0) return null

  // Der Klonindex zaehlt innerhalb eines Gegnereintrags. Bei mehreren
  // Eintraegen mit derselben NPC-ID laufen die Klone fortlaufend weiter.
  let remaining = mdtIndex
  for (const entry of candidates) {
    if (remaining <= entry.clones) {
      // MDT spricht Klone ueber ihren Tabellenschluessel an, und der ist nicht
      // fortlaufend. Der fortlaufende Zaehler von keystone.guru muss deshalb
      // erst uebersetzt werden, sonst zeigt der Import ins Leere.
      const clone = entry.cloneKeys?.[remaining - 1] ?? remaining
      return { enemy: entry.index, clone, forces: entry.count }
    }
    remaining -= entry.clones
  }
  return null
}

/**
 * Konvertiert eine Route der keystone.guru-API.
 *
 * @param {object} ksRoute Antwort von GET /api/v1/route/{route}
 * @param {object} dungeon Passender Dungeon aus mdt-dungeons.mjs
 * @param {object} [options]
 * @param {'clone'|'enemy'} [options.interpretation]
 * @returns {{ route: object, report: object }}
 */
export function convertRoute(ksRoute, dungeon, options = {}) {
  const interpretation = options.interpretation ?? 'clone'
  const byNpc = indexEnemiesByNpc(dungeon)

  const report = { resolved: 0, unresolved: 0, forcesComputed: 0, forcesDeclared: ksRoute.enemyForces ?? null }
  const pulls = []

  for (const ksPull of ksRoute.pulls ?? []) {
    // MDT haelt Klone eines Gegners zusammen: pulls[i][enemyIdx] = { klone }
    const grouped = new Map()

    for (const ksEnemy of ksPull.enemies ?? []) {
      const hit = resolveEnemy(ksEnemy, byNpc, dungeon, interpretation)
      if (!hit) {
        report.unresolved += 1
        continue
      }
      report.resolved += 1
      report.forcesComputed += hit.forces

      const clones = grouped.get(hit.enemy)
      if (clones) clones.add(hit.clone)
      else grouped.set(hit.enemy, new Set([hit.clone]))
    }

    if (grouped.size === 0) continue

    pulls.push({
      enemies: [...grouped.entries()]
        .map(([enemy, clones]) => ({ enemy, clones: [...clones].sort((a, b) => a - b) }))
        .sort((a, b) => a.enemy - b.enemy),
    })
  }

  const route = {
    id: `ks-${ksRoute.publicKey}`,
    source: 'keystone.guru',
    title: ksRoute.title ?? 'Untitled',
    author: ksRoute.author?.name ?? null,
    url: ksRoute.links?.view ?? null,
    challengeModeId: dungeon.challengeModeId,
    dungeonEnglishName: dungeon.englishName,
    mdtDungeonIdx: dungeon.mdtIndex,
    enemyForces: ksRoute.enemyForces ?? null,
    enemyForcesRequired: ksRoute.enemyForcesRequired ?? null,
    affixes: (ksRoute.affixGroups ?? []).flatMap((g) => (g.affixes ?? []).map((a) => a.name ?? a)),
    pulls,
  }

  return { route, report }
}

/**
 * Prueft eine konvertierte Route gegen die von keystone gemeldeten Werte.
 *
 * Der Vergleich der Gegnerkraefte ist der eigentliche Test der mdtIndex-Lesart:
 * stimmen die Summen, war die Aufloesung richtig.
 *
 * @param {object} route
 * @param {object} report
 * @returns {{ ok: boolean, issues: string[] }}
 */
export function validateRoute(route, report) {
  const issues = []

  if (route.pulls.length === 0) issues.push('keine aufloesbaren Pulls')
  if (report.unresolved > 0) {
    issues.push(`${report.unresolved} von ${report.unresolved + report.resolved} Gegnern nicht aufgeloest`)
  }

  if (report.forcesDeclared != null && report.forcesComputed > 0) {
    const delta = Math.abs(report.forcesComputed - report.forcesDeclared)
    const tolerance = Math.max(5, report.forcesDeclared * 0.02)
    if (delta > tolerance) {
      issues.push(`Gegnerkraefte weichen ab: berechnet ${report.forcesComputed}, gemeldet ${report.forcesDeclared}`)
    }
  }

  return { ok: issues.length === 0, issues }
}
