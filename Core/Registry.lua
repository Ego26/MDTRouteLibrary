-- Registry: nimmt Routen aus MDTRouteLibrary_Data entgegen und haelt sie bereit.
--
-- Routen werden bewusst NICHT mit MDT-Dungeonindizes ausgeliefert, sondern mit
-- der challengeModeId und dem englischen Dungeonnamen. MDT vergibt seine
-- Indizes intern neu (siehe Midnight/*.lua), ein eingebackener Index waere
-- nach dem naechsten MDT-Update falsch. Aufgeloest wird erst zur Laufzeit,
-- siehe Core/MDT.lua.

local _, ns = ...

local REQUIRED = { "id", "title", "challengeModeId", "pulls" }

---Prueft die Pflichtfelder einer Route.
---@param route table
---@return boolean ok, string|nil reason
local function validate(route)
    -- Diese Gruende landen nur im Chat, wenn ein Datenpaket kaputt ist.
    -- Englisch, weil sie im Zweifel in einem Fehlerbericht auftauchen.
    if type(route) ~= "table" then return false, "not a table" end
    for _, field in ipairs(REQUIRED) do
        if route[field] == nil then return false, "missing field: " .. field end
    end
    if type(route.pulls) ~= "table" or #route.pulls == 0 then
        return false, "no pulls"
    end
    return true
end

---Traegt eine Route ein. Wird von den generierten Dateien in
---MDTRouteLibrary_Data/Routes aufgerufen.
---@param route table
function ns.RegisterRoute(route)
    local ok, reason = validate(route)
    if not ok then
        ns.Warn(ns.L["ROUTE_REJECTED"], tostring(route and route.id), reason)
        return
    end

    if ns.routeById[route.id] then return end -- doppelte Auslieferung ignorieren

    ns.routes[#ns.routes + 1] = route
    ns.routeById[route.id] = route
end

---Setzt die Metadaten des Datenpakets (Buildzeitpunkt, Season, Quelle).
---@param manifest table
function ns.SetManifest(manifest)
    ns.manifest = manifest
end

---Traegt die Stammdaten eines Dungeons ein: Kurzname fuer die Icon-Leiste und
---die NPC-Namen fuer die Pull-Liste. Wird von MDTRouteLibrary_Data aufgerufen.
---@param dungeon table
function ns.RegisterDungeon(dungeon)
    if type(dungeon) ~= "table" or not dungeon.challengeModeId then return end

    ns.dungeons[#ns.dungeons + 1] = dungeon
    ns.dungeonById[dungeon.challengeModeId] = dungeon
end

---Liefert die Stammdaten eines Dungeons.
---@param challengeModeId number
---@return table|nil
function ns.GetDungeon(challengeModeId)
    return ns.dungeonById[challengeModeId]
end

---Stammdaten eines NPCs im Kontext eines Dungeons.
---Enthaelt Name, displayId fuer das 3D-Modell, Stufe, Typ, Leben und die
---Gegnerkraefte pro Mob - alles, was die Vorschau beim Ueberfahren zeigt.
---@param challengeModeId number
---@param npcId number
---@return table|nil
function ns.GetNpc(challengeModeId, npcId)
    local dungeon = ns.dungeonById[challengeModeId]
    return dungeon and dungeon.npcs and dungeon.npcs[npcId] or nil
end

---Gegnertabelle eines Dungeons: MDT-Gegnerindex -> { npc, count, clones }.
---Damit lassen sich auch fremde MDT-Presets bewerten.
---@param challengeModeId number
---@return table|nil
function ns.GetDungeonEnemies(challengeModeId)
    local dungeon = ns.dungeonById[challengeModeId]
    return dungeon and dungeon.enemies or nil
end

---Rechnet die Gegnerkraefte einer MDT-Pull-Tabelle aus.
---MDT legt pro Pull { color = "...", [enemyIdx] = { cloneIdx, ... } } ab.
---@param challengeModeId number
---@param pulls table
---@return number forces
function ns.CountForces(challengeModeId, pulls)
    local enemies = ns.GetDungeonEnemies(challengeModeId)
    if not enemies or type(pulls) ~= "table" then return 0 end

    local total = 0
    -- ipairs waere falsch: alte MDT-Presets haben Luecken in der Pull-Liste
    -- (oder einen Eintrag auf Index 0), und dann zaehlten wir nur den Anfang.
    for key, pull in pairs(pulls) do
        if type(key) == "number" and type(pull) == "table" then
            for enemyIdx, clones in pairs(pull) do
                local enemy = type(enemyIdx) == "number" and enemies[enemyIdx]
                if enemy and type(clones) == "table" then
                    total = total + (enemy.count or 0) * #clones
                end
            end
        end
    end
    return total
end

---Wandelt MDTs Pull-Tabelle in unser Routenformat.
---
---MDT legt pro Pull { color = "...", [enemyIdx] = { cloneIdx, ... } } ab; unsere
---Oberflaeche erwartet enemies-Listen mit NPC-Id und die laufenden
---Gegnerkraefte. Wird fuer die eigenen Routen des Nutzers gebraucht, die MDT
---selbst haelt.
---@param challengeModeId number
---@param pulls table MDT-Pulls
---@return table
function ns.BuildOwnPulls(challengeModeId, pulls)
    local enemies = ns.GetDungeonEnemies(challengeModeId)
    local out, running = {}, 0

    -- Erst die tatsaechlich belegten Indizes sammeln. "#pulls" ist bei alten
    -- Presets mit Luecken unbrauchbar und meldete sonst "1 Pull".
    local keys = {}
    for key in pairs(pulls) do
        if type(key) == "number" then keys[#keys + 1] = key end
    end
    table.sort(keys)

    for _, key in ipairs(keys) do
        local pull = pulls[key]
        if type(pull) == "table" then
            local list, forces, boss = {}, 0, false

            for enemyIdx, clones in pairs(pull) do
                local enemy = type(enemyIdx) == "number" and enemies and enemies[enemyIdx]
                if enemy and type(clones) == "table" and #clones > 0 then
                    local copy = {}
                    for k, cloneIdx in ipairs(clones) do copy[k] = cloneIdx end
                    table.sort(copy)

                    forces = forces + (enemy.count or 0) * #copy
                    list[#list + 1] = { enemy = enemyIdx, npc = enemy.npc, clones = copy }

                    local npc = ns.GetNpc(challengeModeId, enemy.npc)
                    if npc and npc.isBoss then boss = true end
                end
            end

            table.sort(list, function(a, b) return a.enemy < b.enemy end)
            running = running + forces

            out[#out + 1] = {
                color = type(pull.color) == "string" and pull.color or nil,
                enemies = list,
                forces = forces,
                cumulative = running,
                boss = boss or nil,
            }
        end
    end

    return out
end

---Name eines NPCs im Kontext eines Dungeons.
---@param challengeModeId number
---@param npcId number
---@return string
function ns.GetNpcName(challengeModeId, npcId)
    local npc = ns.GetNpc(challengeModeId, npcId)
    return (npc and npc.name) or ("NPC " .. tostring(npcId))
end

---Alle Routen zu einer challengeModeId.
---@param challengeModeId number
---@return table
function ns.GetRoutesForDungeon(challengeModeId)
    local result = {}
    for _, route in ipairs(ns.routes) do
        if route.challengeModeId == challengeModeId then
            result[#result + 1] = route
        end
    end
    return result
end

--------------------------------------------------------------------------
-- Oeffentliche Schnittstelle
--------------------------------------------------------------------------

local api = ns.api

-- MDTRouteLibrary_Data ist ein eigenstaendiges Addon und hat damit einen eigenen
-- Namensraum. Es traegt seine Routen deshalb ueber diese globale Tabelle ein.

---Traegt eine Route ein. Wird von MDTRouteLibrary_Data aufgerufen.
function api:RegisterRoute(route)
    return ns.RegisterRoute(route)
end

---Setzt die Metadaten des Datenpakets. Wird von MDTRouteLibrary_Data aufgerufen.
function api:SetManifest(manifest)
    return ns.SetManifest(manifest)
end

---Traegt die Stammdaten eines Dungeons ein. Wird von MDTRouteLibrary_Data aufgerufen.
function api:RegisterDungeon(dungeon)
    return ns.RegisterDungeon(dungeon)
end

---Liefert alle geladenen Routen.
function api:GetRoutes()
    return ns.routes
end

---Liefert eine Route anhand ihrer ID.
function api:GetRoute(id)
    return ns.routeById[id]
end

---Liefert die Metadaten des Datenpakets.
function api:GetManifest()
    return ns.manifest
end

---Liefert die Addonversion.
function api:GetVersion()
    return ns.version
end
