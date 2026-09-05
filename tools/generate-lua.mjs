// Erzeugt das LoadOnDemand-Datenaddon MDTRouteLibrary_Data aus normalisierten Routen.
//
// Die Ausgabe ist bewusst deterministisch: gleiche Routen ergeben Zeichen fuer
// Zeichen dieselben Dateien. Nur so kann die taegliche Pipeline per Hash
// entscheiden, ob es ueberhaupt etwas zu veroeffentlichen gibt - sonst bekaeme
// der Nutzer jeden Tag ein Update ohne neuen Inhalt.

import { createHash } from 'node:crypto'
import { mkdirSync, writeFileSync, rmSync, existsSync, readdirSync } from 'node:fs'
import { join } from 'node:path'

const HEADER = '-- Erzeugt von tools/generate-lua.mjs. Nicht von Hand bearbeiten.\n'

/** Lua-Bezeichner brauchen keine Klammern, alles andere schon. */
const IDENT = /^[A-Za-z_][A-Za-z0-9_]*$/

/**
 * Schreibt einen Wert als Lua-Literal.
 *
 * @param {any} value
 * @param {number} indent
 * @returns {string}
 */
function toLua(value, indent = 0) {
  const pad = '    '.repeat(indent)
  const padInner = '    '.repeat(indent + 1)

  if (value === null || value === undefined) return 'nil'
  if (typeof value === 'boolean') return value ? 'true' : 'false'
  if (typeof value === 'number') return Number.isFinite(value) ? String(value) : 'nil'
  if (typeof value === 'string') {
    return `"${value.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n/g, '\\n').replace(/\r/g, '\\r')}"`
  }

  if (Array.isArray(value)) {
    if (value.length === 0) return '{}'
    // Kurze Zahlenlisten (Klonindizes) bleiben in einer Zeile - das spart in
    // den generierten Dateien sehr viel Hoehe.
    if (value.every((v) => typeof v === 'number')) return `{ ${value.join(', ')} }`
    const items = value.map((v) => `${padInner}${toLua(v, indent + 1)},`).join('\n')
    return `{\n${items}\n${pad}}`
  }

  const keys = Object.keys(value).filter((k) => value[k] !== undefined && value[k] !== null)
  if (keys.length === 0) return '{}'
  const items = keys
    .map((k) => {
      // JavaScript kennt nur Stringschluessel. Eine reine Zahl muss in Lua
      // aber ein Zahlenschluessel werden, sonst schlaegt npcs[270306] fehl.
      let key
      if (/^\d+$/.test(k)) key = `[${k}]`
      else if (IDENT.test(k)) key = k
      else key = `["${k}"]`
      return `${padInner}${key} = ${toLua(value[k], indent + 1)},`
    })
    .join('\n')
  return `{\n${items}\n${pad}}`
}

/** Dateiname aus dem englischen Dungeonnamen. */
function dungeonKey(name) {
  return (name ?? 'Unknown').replace(/[^A-Za-z0-9]/g, '')
}

/**
 * Baut alle Dateien des Datenaddons im Speicher.
 *
 * @param {object[]} routes Normalisierte Routen
 * @param {object} meta { build, season, mdtVersion, sources }
 * @returns {{ files: Map<string,string>, hash: string, stats: object }}
 */
export function buildDataAddon(routes, meta) {
  const byDungeon = new Map()
  for (const route of [...routes].sort((a, b) => a.id.localeCompare(b.id))) {
    const key = dungeonKey(route.dungeonEnglishName)
    const list = byDungeon.get(key)
    if (list) list.push(route)
    else byDungeon.set(key, [route])
  }

  const files = new Map()
  const routeFiles = [...byDungeon.keys()].sort()

  for (const key of routeFiles) {
    const lines = [HEADER, 'local R = MDTRouteLibrary\n']
    for (const route of byDungeon.get(key)) {
      lines.push(`R:RegisterRoute(${toLua(route, 0)})\n`)
    }
    files.set(join('Routes', `${key}.lua`), lines.join('\n'))
  }

  // Dungeon-Stammdaten: Kurzname und Icon-Quelle fuer die Leiste oben,
  // NPC-Namen fuer die Pull-Liste im Detailbereich.
  const dungeons = meta.dungeons ?? []
  if (dungeons.length > 0) {
    const lines = [HEADER, 'local R = MDTRouteLibrary\n']
    for (const dungeon of dungeons) {
      lines.push(`R:RegisterDungeon(${toLua(dungeon, 0)})\n`)
    }
    files.set('Dungeons.lua', lines.join('\n'))
  }

  const manifest = {
    build: meta.build,
    season: meta.season ?? null,
    mdtVersion: meta.mdtVersion ?? null,
    routeCount: routes.length,
    dungeonCount: byDungeon.size,
    sources: meta.sources ?? [],
  }
  files.set('Manifest.lua', `${HEADER}\nlocal R = MDTRouteLibrary\n\nR:SetManifest(${toLua(manifest, 0)})\n`)

  const toc = [
    '## Interface: ' + (meta.interface ?? '120100'),
    '## Title: MDT Route Library |cff8a8a8aDaten|r',
    '## Notes: Route data for MDT Route Library. Loads on demand.',
    '## Notes-deDE: Routendaten für MDT Route Library. Wird bei Bedarf geladen.',
    '## Author: Ego26',
    '## Version: @project-version@',
    '## RequiredDeps: MDTRouteLibrary',
    '## LoadOnDemand: 1',
    '## X-Category: Mythic+',
    '',
    '# Erzeugt von tools/generate-lua.mjs. Nicht von Hand bearbeiten.',
    '# Das Manifest zuerst: die Routen beziehen sich auf seinen Buildstand.',
    'Manifest.lua',
    // Dungeon-Stammdaten vor den Routen: die Oberflaeche schlaegt darin
    // Kurznamen und NPC-Namen nach.
    ...(dungeons.length > 0 ? ['Dungeons.lua'] : []),
    ...routeFiles.map((key) => `Routes\\${key}.lua`),
    '',
  ].join('\n')
  files.set('MDTRouteLibrary_Data.toc', toc)

  // Hash ueber den Inhalt - ohne das Manifest, denn dessen Buildstempel
  // aendert sich taeglich und wuerde jeden Vergleich wertlos machen.
  const hash = createHash('sha256')
  for (const name of [...files.keys()].sort()) {
    if (name === 'Manifest.lua') continue
    hash.update(name)
    hash.update(files.get(name))
  }

  return {
    files,
    hash: hash.digest('hex').slice(0, 12),
    stats: { routes: routes.length, dungeons: byDungeon.size },
  }
}

/**
 * Schreibt das Datenaddon auf die Platte.
 *
 * @param {string} target Ordner MDTRouteLibrary_Data
 * @param {Map<string,string>} files
 */
export function writeDataAddon(target, files) {
  // Alles entfernen, was dieser Lauf nicht mehr erzeugt. Sonst bleibt eine
  // Datei liegen, die in der TOC gar nicht mehr steht - tote Fracht im Paket,
  // und beim Wechsel der Season sogar Routen aus der vorigen.
  const routesDir = join(target, 'Routes')
  if (existsSync(routesDir)) rmSync(routesDir, { recursive: true })

  if (existsSync(target)) {
    for (const entry of readdirSync(target)) {
      if (entry === 'Routes') continue
      if (!files.has(entry)) rmSync(join(target, entry), { recursive: true, force: true })
    }
  }

  for (const [name, content] of files) {
    const path = join(target, name)
    mkdirSync(join(path, '..'), { recursive: true })
    writeFileSync(path, content, 'utf8')
  }
}
