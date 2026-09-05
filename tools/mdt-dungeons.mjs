// Liest MDTs Dungeonkatalog aus den Addon-Quelldateien.
//
// Warum offline und nicht im Spiel: MDT gibt seine Gegnertabelle nach aussen
// nicht frei. Wir brauchen sie aber, um keystone.guru-Routen auf MDT-Indizes
// abzubilden und um Einreichungen mit NPC-IDs anzureichern. Also parsen wir
// beim Bauen genau die Dateien, die MDT im Spiel selbst laedt.
//
// Aufruf:
//   node tools/mdt-dungeons.mjs --mdt "<Pfad zu MythicDungeonTools>" [--out datei.json]

import { readFileSync, readdirSync, writeFileSync, existsSync, statSync } from 'node:fs'
import { join } from 'node:path'
import { pathToFileURL } from 'node:url'
import { findTables, parseTableAt } from './lua-table.mjs'

/** Ordner, in denen MDT seine Dungeondaten ablegt (neueste zuerst). */
const DATA_DIRS = ['Midnight', 'TheWarWithin', 'Dragonflight', 'Shadowlands', 'BattleForAzeroth', 'Legion']

/**
 * Liest eine einzelne Dungeondatei.
 *
 * @param {string} file Pfad zur Lua-Datei
 * @returns {object|null} Dungeon oder null, wenn die Datei keiner ist
 */
export function parseDungeonFile(file) {
  const src = readFileSync(file, 'utf8')

  const idxMatch = /local\s+dungeonIndex\s*=\s*(\d+)/.exec(src)
  if (!idxMatch) return null
  const mdtIndex = Number(idxMatch[1])

  const dungeon = {
    mdtIndex,
    file: file.split(/[\\/]/).pop(),
    englishName: null,
    challengeModeId: null,
    totalCount: null,
    enemies: [],
  }

  // MDT.mapInfo[dungeonIndex] = { ... }
  const mapInfo = findTables(src, /MDT\.mapInfo\[dungeonIndex\]\s*=\s*\{/g)[0]
  if (mapInfo) {
    dungeon.englishName = mapInfo.value.englishName ?? null
    // shortName steht als L["...ShortName"] da; der Parser gibt uns den Schluessel.
    dungeon.shortNameKey = mapInfo.value.shortName?.__index ?? null
    // MDT nennt das Feld "mapID"; es traegt die ChallengeMode-ID des Dungeons.
    dungeon.challengeModeId = typeof mapInfo.value.mapID === 'number' ? mapInfo.value.mapID : null
  }

  const total = findTables(src, /MDT\.dungeonTotalCount\[dungeonIndex\]\s*=\s*\{/g)[0]
  if (total && typeof total.value.normal === 'number') dungeon.totalCount = total.value.normal

  // MDT.dungeonEnemies[dungeonIndex] = { [1] = { ... }, ... }
  const enemiesStart = src.indexOf('MDT.dungeonEnemies[dungeonIndex]')
  if (enemiesStart !== -1) {
    const brace = src.indexOf('{', enemiesStart)
    const { value } = parseTableAt(src, brace)
    for (const [key, enemy] of Object.entries(value)) {
      if (!enemy || typeof enemy !== 'object') continue
      const clones = enemy.clones && typeof enemy.clones === 'object' ? Object.keys(enemy.clones).length : 0
      dungeon.enemies.push({
        index: Number(key),
        id: enemy.id ?? null,
        name: enemy.name ?? null,
        count: enemy.count ?? 0,
        clones,
        isBoss: enemy.isBoss === true,
        // Fuer die Vorschau beim Ueberfahren: displayId speist das 3D-Modell,
        // der Rest fuellt die Infozeilen - dieselben Angaben, die MDT zeigt.
        // Zauber: MDT legt die ID als Schluessel ab und im Wert die
        // Eigenschaften - unterbrechbar, Magie, Fluch, Gift, Krankheit,
        // Blutung, Raserei. Genau die zeigt MDT im Gegner-Panel an.
        spells: enemy.spells && typeof enemy.spells === 'object'
          ? Object.entries(enemy.spells)
              .map(([id, attrs]) => {
                const spell = { id: Number(id) }
                for (const key of ['interruptible', 'magic', 'curse', 'poison', 'disease', 'bleed', 'enrage']) {
                  if (attrs && attrs[key] === true) spell[key] = true
                }
                return spell
              })
              .filter((sp) => Number.isFinite(sp.id))
              .sort((a, b) => a.id - b.id)
          : [],
        displayId: enemy.displayId ?? null,
        creatureType: enemy.creatureType ?? null,
        level: enemy.level ?? null,
        health: enemy.health ?? null,
      })
    }
    dungeon.enemies.sort((a, b) => a.index - b.index)
  }

  return dungeon
}

/**
 * Liest alle Dungeons einer MDT-Installation.
 *
 * @param {string} mdtPath Pfad zum Ordner MythicDungeonTools
 * @returns {{ mdtVersion: string|null, dungeons: object[] }}
 */
export function readDungeons(mdtPath) {
  if (!existsSync(mdtPath)) throw new Error(`MDT-Pfad nicht gefunden: ${mdtPath}`)

  let mdtVersion = null
  const toc = join(mdtPath, 'MythicDungeonTools.toc')
  if (existsSync(toc)) {
    const m = /^##\s*Version:\s*(.+)$/m.exec(readFileSync(toc, 'utf8'))
    if (m) mdtVersion = m[1].trim()
  }

  // Kurznamen ("FANG", "NALO", ...) stehen nicht in den Dungeondateien, sondern
  // als Lokalisierungsschluessel. Wir loesen sie gegen enUS auf - die Icon-
  // Leiste im Browser zeigt sie genauso an wie MDTs eigene Dungeonauswahl.
  const shortNames = {}
  const localeFile = join(mdtPath, "Locales", "enUS.lua")
  if (existsSync(localeFile)) {
    const src = readFileSync(localeFile, "utf8")
    const re = /L\["([^"]+)"\]\s*=\s*"([^"]*)"/g
    let m
    while ((m = re.exec(src)) !== null) shortNames[m[1]] = m[2]
  }

  const dungeons = []
  for (const dir of DATA_DIRS) {
    const full = join(mdtPath, dir)
    if (!existsSync(full) || !statSync(full).isDirectory()) continue

    for (const name of readdirSync(full)) {
      if (!name.endsWith('.lua')) continue
      try {
        const dungeon = parseDungeonFile(join(full, name))
        if (dungeon && dungeon.englishName) {
          dungeon.expansion = dir
          const key = dungeon.shortNameKey
          dungeon.shortName = (key && shortNames[key]) || dungeon.englishName.slice(0, 4).toUpperCase()
          delete dungeon.shortNameKey
          dungeons.push(dungeon)
        }
      } catch (err) {
        console.warn(`  ! ${dir}/${name}: ${err.message}`)
      }
    }
  }

  dungeons.sort((a, b) => a.mdtIndex - b.mdtIndex)
  return { mdtVersion, dungeons, seasons: readSeasons(mdtPath) }
}

/**
 * Liest MDTs Saison-Listen.
 *
 * MDT pflegt sie in Modules/DungeonSelect.lua als Paare aus Name und
 * Dungeonindizes. Wir brauchen sie, um zu wissen, welche acht Dungeons zur
 * laufenden Season gehoeren - sonst raet die Pipeline, welche Routen ueberhaupt
 * relevant sind.
 *
 * @param {string} mdtPath
 * @returns {Array<{ name: string, dungeonIndices: number[] }>} neueste zuerst
 */
export function readSeasons(mdtPath) {
  const file = join(mdtPath, 'Modules', 'DungeonSelect.lua')
  if (!existsSync(file)) return []

  const src = readFileSync(file, 'utf8')
  const seasons = []

  // tinsert(MDT.seasonList, L["..."])  gefolgt von
  // tinsert(MDT.dungeonSelectionToIndex, { 160, 161, ... })
  const re = /tinsert\(MDT\.seasonList,\s*L\["([^"]+)"\]\)\s*tinsert\(MDT\.dungeonSelectionToIndex,\s*\{([^}]*)\}\)/g
  let m
  while ((m = re.exec(src)) !== null) {
    const indices = m[2]
      .split(',')
      .map((part) => Number(part.trim()))
      .filter((n) => Number.isFinite(n))
    seasons.push({ name: m[1], dungeonIndices: indices })
  }

  return seasons
}

/**
 * Baut Nachschlagetabellen ueber challengeModeId und englischen Namen.
 *
 * @param {object[]} dungeons
 */
export function buildLookup(dungeons) {
  const byChallengeMode = new Map()
  const byName = new Map()
  for (const d of dungeons) {
    if (d.challengeModeId != null) byChallengeMode.set(d.challengeModeId, d)
    if (d.englishName) byName.set(d.englishName.toLowerCase(), d)
  }
  return { byChallengeMode, byName }
}

// ---------------------------------------------------------------- CLI

function parseArgs(argv) {
  const args = {}
  for (let i = 0; i < argv.length; i += 1) {
    if (!argv[i].startsWith('--')) continue
    // Ein Flag ohne Wert (am Ende oder vor dem naechsten --) ist ein true.
    const next = argv[i + 1]
    args[argv[i].slice(2)] = next === undefined || next.startsWith('--') ? true : argv[++i]
  }
  return args
}

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  const args = parseArgs(process.argv.slice(2))
  if (!args.mdt) {
    console.error('Aufruf: node tools/mdt-dungeons.mjs --mdt "<Pfad zu MythicDungeonTools>" [--out datei.json]')
    process.exit(1)
  }

  const result = readDungeons(args.mdt)
  console.log(`MDT ${result.mdtVersion ?? '?'} - ${result.dungeons.length} Dungeons`)
  for (const d of result.dungeons) {
    const forces = d.enemies.reduce((sum, e) => sum + e.count * e.clones, 0)
    console.log(
      `  [${String(d.mdtIndex).padStart(3)}] cm=${String(d.challengeModeId ?? '-').padStart(4)}` +
        ` ${(d.englishName ?? '?').padEnd(28)} ${String(d.enemies.length).padStart(3)} Gegner` +
        `  Kraefte ${forces}/${d.totalCount ?? '?'}`
    )
  }

  if (result.seasons.length > 0) {
    const byIdx = new Map(result.dungeons.map((d) => [d.mdtIndex, d]))
    console.log('')
    for (const season of result.seasons) {
      const names = season.dungeonIndices.map((i) => byIdx.get(i)?.shortName ?? '?').join(' ')
      console.log(`  ${season.name.padEnd(20)} (${season.dungeonIndices.length}) ${names}`)
    }
  }

  if (args.out) {
    writeFileSync(args.out, JSON.stringify(result, null, 2))
    console.log(`\ngeschrieben: ${args.out}`)
  }
}
