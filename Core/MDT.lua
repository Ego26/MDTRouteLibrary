-- Anbindung an Mythic Dungeon Tools.
--
-- Warum dieser Weg:
--   * MDT ist zweigeteilt. "MythicDungeonTools" laedt immer, die eigentliche
--     Oberflaeche "MythicDungeonTools_UI" nur bei Bedarf. Die Dungeondaten und
--     die Preset-Datenbank leben im UI-Teil.
--   * MythicDungeonToolsAPI:GetDungeonName() laedt den UI-Teil bei Bedarf nach.
--     Beim Login aufgerufen wuerde das MDTs Lazy Loading aushebeln - deshalb
--     haengen wir uns per RegisterUIInitializer ein. Der Callback laeuft genau
--     dann, wenn MDT seine Oberflaeche ohnehin gerade anhaengt, und zwar nach
--     dem Laden aller Dungeondaten (MythicDungeonTools/Core/Lifecycle.lua).
--   * ImportPreset ist nicht oeffentlich exportiert, GetDB ist es. Wir tragen
--     die Routen deshalb direkt in die Preset-Liste ein; MDT normalisiert sie
--     danach selbst und entfernt dabei Gegner, die es nicht mehr gibt.

local _, ns = ...

local M = {}
ns.MDT = M

local DEFAULT_PULL_COLOR = "228b22"
local DEFAULT_DIFFICULTY = 10
local MAX_DUNGEON_IDX    = 250

-- Zeichenvorrat von MDTs eigenen UIDs (Modules/Transmission.lua).
local UID_CHARS  = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789()"
local UID_LENGTH = 11

local nameToIdx  -- englischer Dungeonname (klein) -> MDT-Index
local uiReady = false
local lastResult

--------------------------------------------------------------------------
-- Zustand
--------------------------------------------------------------------------

---Ist MDT installiert (unabhaengig davon, ob es geladen ist)?
function M.IsInstalled()
    return C_AddOns.GetAddOnInfo(ns.MDT_ADDON) ~= nil
end

---Hat sich MDTs Oberflaeche bereits bei uns gemeldet?
function M.IsReady()
    return uiReady
end

---Ergebnis der letzten Installation.
function M.GetLastResult()
    return lastResult
end

---Liefert MDTs Datenbank mit der Preset-Liste.
---
---MDT-Kern und MDT-UI haben getrennte Namensraumtabellen. GetDB() wurde vom
---Kern exportiert und liefert dessen Sicht; die Presets legt aber erst der
---UI-Teil an. Beide sollten auf dieselbe MythicDungeonToolsDB.global zeigen -
---verlassen wollen wir uns darauf nicht, deshalb der zweite Weg ueber die
---SavedVariable direkt.
---@return table|nil
function M.GetDB()
    local api = _G.MythicDungeonToolsAPI
    if api and type(api.GetDB) == "function" then
        local db = api:GetDB()
        if type(db) == "table" and type(db.presets) == "table" then return db end
    end

    local saved = _G.MythicDungeonToolsDB
    local db = type(saved) == "table" and saved.global or nil
    if type(db) == "table" and type(db.presets) == "table" then return db end

    return nil
end

--------------------------------------------------------------------------
-- UID
--------------------------------------------------------------------------

---Deterministische UID aus der Routen-ID.
---Gleiche Route, gleiche UID - damit MDT beim Teilen sauber dedupliziert.
---@param id string
---@return string
local function makeUID(id)
    -- FNV-1a ueber 32 Bit. Reicht voellig: die UID muss stabil sein, nicht sicher.
    --
    -- Die Multiplikation laeuft in zwei 16-Bit-Haelften. Direkt gerechnet waere
    -- hash * 16777619 groesser als 2^53 und Lua-Zahlen (Doubles) wuerden
    -- Stellen verlieren - die UID waere dann zwar immer noch stabil, aber
    -- nicht mehr das, was FNV-1a vorsieht.
    local PRIME = 16777619
    local hash = 2166136261

    for i = 1, #id do
        hash = bit.bxor(hash, id:byte(i))
        local low  = hash % 65536
        local high = math.floor(hash / 65536)
        hash = (low * PRIME + ((high * PRIME) % 65536) * 65536) % 4294967296
    end

    local chars = {}
    local n = #UID_CHARS
    for i = 1, UID_LENGTH do
        local pick = (hash % n) + 1
        chars[i] = UID_CHARS:sub(pick, pick)
        hash = math.floor(hash / n)
        if hash == 0 then hash = (i * 2654435761) % 4294967296 end
    end
    return table.concat(chars)
end

M.MakeUID = makeUID

--------------------------------------------------------------------------
-- Dungeon-Aufloesung
--------------------------------------------------------------------------

---Baut einmalig die Zuordnung englischer Dungeonname -> MDT-Index.
---@param api table
local function buildNameIndex(api)
    nameToIdx = {}
    for idx = 1, MAX_DUNGEON_IDX do
        local english = api:GetDungeonName(idx, true)
        if type(english) == "string" and english ~= "" then
            nameToIdx[english:lower()] = idx
        end
    end
end

---Ermittelt den MDT-Dungeonindex einer Route.
---Der beim Bauen eingebackene Index ist nur ein Tipp: MDT nummeriert seine
---Dungeons zwischen Versionen um, verbindlich ist immer der englische Name.
---@param api table
---@param route table
---@return number|nil
local function resolveDungeonIdx(api, route)
    local english = route.dungeonEnglishName
    if not english then return nil end
    local wanted = english:lower()

    -- Schneller Weg: der eingebackene Index stimmt noch.
    local hint = route.mdtDungeonIdx
    if hint then
        local name = api:GetDungeonName(hint, true)
        if type(name) == "string" and name:lower() == wanted then
            return hint
        end
    end

    if not nameToIdx then buildNameIndex(api) end
    return nameToIdx[wanted]
end

M.ResolveDungeonIdx = resolveDungeonIdx

--------------------------------------------------------------------------
-- Preset-Bau
--------------------------------------------------------------------------

---Baut aus einer Route ein MDT-Preset.
---Die Struktur folgt MDT:ValidateImportPreset (Modules/Presets.lua).
---@param route table
---@param dungeonIdx number
---@return table
function M.BuildPreset(route, dungeonIdx)
    local pulls = {}

    for i, pull in ipairs(route.pulls) do
        local mdtPull = { color = pull.color or DEFAULT_PULL_COLOR }
        for _, enemy in ipairs(pull.enemies or {}) do
            -- MDT erwartet pulls[i][enemyIdx] = { cloneIdx, cloneIdx, ... }
            local clones = mdtPull[enemy.enemy]
            if not clones then
                clones = {}
                mdtPull[enemy.enemy] = clones
            end
            for _, cloneIdx in ipairs(enemy.clones or {}) do
                clones[#clones + 1] = cloneIdx
            end
        end
        pulls[i] = mdtPull
    end

    return {
        text    = route.title,
        uid     = makeUID(route.id),
        objects = {},
        colorPaletteInfo = { autoColoring = true, colorPaletteIdx = 4 },
        -- MDTs "Dungeon Level"-Regler kennt nur einen Wert. Bei einem
        -- Bereich nehmen wir die Untergrenze: damit ist die Route auf jeden
        -- Fall gueltig, nur eventuell vorsichtiger als noetig.
        difficulty = route.keyLevelMin or route.keyLevel or route.difficulty or DEFAULT_DIFFICULTY,

        -- Eigene Markierung: daran erkennen wir beim naechsten Update, welche
        -- Presets von uns stammen. Presets des Nutzers fassen wir nie an.
        mdtrl = {
            id     = route.id,
            build  = ns.manifest and ns.manifest.build or "unknown",
            source = route.source,
            url    = route.url,
        },

        value = {
            currentDungeonIdx = dungeonIdx,
            currentPull       = 1,
            currentSublevel   = route.sublevel or 1,
            selection         = { 1 },
            pulls             = pulls,
        },
    }
end

---Erzeugt einen MDT-Importstring zu einer Route (Copy-Paste-Weg).
---Funktioniert auch ohne geladene MDT-Oberflaeche und faellt dann auf den
---eingebackenen Dungeonindex zurueck.
---@param route table
---@return string|nil importString, string|nil err
function M.BuildImportString(route)
    local api = _G.MythicDungeonToolsAPI
    local idx
    if uiReady and api then
        idx = resolveDungeonIdx(api, route)
    end
    idx = idx or route.mdtDungeonIdx
    if not idx then return nil, "Dungeonindex unbekannt" end

    return ns.ToMDTString(M.BuildPreset(route, idx))
end

--------------------------------------------------------------------------
-- Installation in MDTs Preset-Datenbank
--------------------------------------------------------------------------

---Entfernt aus einer Preset-Liste alle Eintraege, die von uns stammen.
---@param list table
---@return number removed
local function removeOwnPresets(list)
    local removed = 0
    for i = #list, 1, -1 do
        local preset = list[i]
        -- "egoRoutes" ist die Markierung aus der Zeit vor der Umbenennung.
        -- Wer das Addon schon vorher hatte, soll die Reste trotzdem loswerden.
        if type(preset) == "table" and (preset.mdtrl or preset.egoRoutes) then
            tremove(list, i)
            removed = removed + 1
        end
    end
    return removed
end

---Entfernt alle Presets, die von uns stammen.
---
---Laeuft bei jedem Laden. Damit verschwinden sowohl Vorschauplaetze aus der
---letzten Sitzung als auch Altlasten aus der Zeit, in der wir noch alle Routen
---ungefragt eingetragen haben.
---@return table result Felder: removed, dungeons
function M.CleanupPresets()
    local result = { removed = 0, dungeons = 0 }
    lastResult = result

    local db = M.GetDB()
    if not db then return result end

    for idx, list in pairs(db.presets) do
        if type(list) == "table" then
            local removed = removeOwnPresets(list)
            if removed > 0 then
                result.removed = result.removed + removed
                result.dungeons = result.dungeons + 1

                -- Die Auswahl des Nutzers kann jetzt ins Leere zeigen.
                local current = db.currentPreset and db.currentPreset[idx]
                if current and current > #list - 1 then
                    db.currentPreset[idx] = 1
                end
            end
        end
    end

    return result
end

---Schreibt eine Route als Preset nach MDT.
---
---@param route table
---@param keep boolean|nil true = dauerhaft als normales Preset des Nutzers
---@return number|nil dungeonIdx, number|nil presetIdx, string|nil err
function M.PutPreset(route, keep)
    local api = _G.MythicDungeonToolsAPI
    local db = M.GetDB()
    if not api or not db then return nil, nil, ns.L["NO_MDT"] end

    local dungeonIdx = resolveDungeonIdx(api, route)
    if not dungeonIdx then return nil, nil, ns.L["BROWSER_NO_DUNGEON"] end

    local list = db.presets[dungeonIdx]
    if type(list) ~= "table" or #list < 1 then return nil, nil, ns.L["NO_MDT"] end

    local preset = M.BuildPreset(route, dungeonIdx)

    if keep then
        -- Dauerhaft: unsere Verwaltungsmarkierung weg, damit das Aufraeumen
        -- beim naechsten Laden die Kopie in Ruhe laesst. Uebrig bleibt nur ein
        -- Herkunftsvermerk - daran erkennt die Liste spaeter, dass diese
        -- Community-Route bereits in MDT liegt, und zeigt sie nur einmal.
        preset.mdtrl = nil
        preset.mdtrlOrigin = route.id

        -- Namen eindeutig machen, wie MDT es beim Anlegen auch tut.
        local base, name, n = preset.text, preset.text, 2
        local taken = true
        while taken do
            taken = false
            for _, existing in ipairs(list) do
                if type(existing) == "table" and existing.text == name then
                    taken = true
                    break
                end
            end
            if taken then
                name = base .. " " .. n
                n = n + 1
            end
        end
        preset.text = name

        tinsert(list, #list, preset)
        return dungeonIdx, #list - 1
    end

    -- Vorschau: es gibt genau einen Platz je Dungeon, der wiederverwendet wird.
    preset.mdtrl.preview = true
    preset.text = ns.L["PREVIEW_PREFIX"] .. " " .. (route.title or route.id)

    for i, existing in ipairs(list) do
        if type(existing) == "table" and existing.mdtrl and existing.mdtrl.preview then
            list[i] = preset
            return dungeonIdx, i
        end
    end

    tinsert(list, #list, preset)
    return dungeonIdx, #list - 1
end

--------------------------------------------------------------------------
-- Einklinken
--------------------------------------------------------------------------

---Meldet uns bei MDT an. Der Callback laeuft, sobald MDT seine Oberflaeche
---anhaengt - ohne dass wir das Nachladen selbst ausloesen.
---@return boolean hooked
function M.Hook()
    local api = _G.MythicDungeonToolsAPI
    if not api or type(api.RegisterUIInitializer) ~= "function" then return false end

    api:RegisterUIInitializer(function(pluginAPI)
        uiReady   = true
        nameToIdx = nil -- Dungeonliste kann sich zwischen Sessions geaendert haben

        -- Zuerst die Sektion anmelden: MDT baut sein Hauptfenster erst danach,
        -- und nur registrierte Sektionen bekommen einen Content-Frame.
        ns.Browser.Register(pluginAPI)

        -- Erst jetzt die Routendaten nachladen: vorher braucht sie niemand.
        if not ns.EnsureData() then return end

        -- Nichts ungefragt eintragen. Nur wegraeumen, was von uns stammt:
        -- Vorschauplaetze der letzten Sitzung und Altlasten aus der Zeit, als
        -- wir noch alle Routen automatisch installiert haben.
        local result = M.CleanupPresets()
        if result.removed > 0 then
            ns.Print(ns.L["CLEANED_UP"], result.removed)
        end

        ns.CheckDataAge()
    end)

    return true
end
