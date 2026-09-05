-- Eigene Laeufe: welche Route, welche Stufe, welche Zeit.
--
-- Der Sinn ist die Rangliste. Wer drei Routen fuer denselben Dungeon
-- ausprobiert hat, will sehen, mit welcher er tatsaechlich am schnellsten war -
-- nicht, welche auf dem Papier die wenigsten Pulls hat.
--
-- Zuordnung: WoW sagt uns nur, dass ein Schluesselstein fertig ist, nicht mit
-- welcher Route. Also merken wir uns beim Start, welches Preset in MDT fuer
-- diesen Dungeon gerade ausgewaehlt ist, und schreiben das Ergebnis darauf.
-- Wer waehrend des Laufs umschaltet oder ohne MDT losrennt, bekommt eine
-- ungenaue Zuordnung - besser als gar keine, und ehrlicher als so zu tun, als
-- wuesste das Addon mehr, als es kann.
--
-- Gelesen wird MDTs Datenbank direkt, nicht ueber die API: die laedt MDTs
-- Oberflaeche bei Bedarf nach, und mitten in einem Schluesselstein hat
-- niemand Lust auf einen Laderuckler.

local _, ns = ...

local R = {}
ns.Runs = R

-- Mehr braucht niemand, und die SavedVariable soll nicht ins Uferlose wachsen.
local MAX_PER_DUNGEON = 200

local pendingKey   -- Routenschluessel des laufenden Schluesselsteins
local pendingLabel -- und sein Titel zum Zeitpunkt des Starts

--------------------------------------------------------------------------
-- Speicher
--------------------------------------------------------------------------

---Liefert die Lauf-Liste eines Dungeons, legt sie bei Bedarf an.
---@param challengeModeId number
---@param create boolean|nil
---@return table|nil
local function bucket(challengeModeId, create)
    local db = MDTRouteLibraryDB
    if type(db) ~= "table" or not challengeModeId then return nil end

    if not db.runs then
        if not create then return nil end
        db.runs = {}
    end

    local list = db.runs[challengeModeId]
    if not list and create then
        list = {}
        db.runs[challengeModeId] = list
    end
    return list
end

--------------------------------------------------------------------------
-- Schluessel
--------------------------------------------------------------------------

---Routenschluessel eines MDT-Presets.
---
---Community-Routen tragen ihre Id im Preset, dadurch zaehlen die Vorschau und
---die dauerhaft gespeicherte Kopie auf dasselbe Konto - es ist ja dieselbe
---Route. Eigene Presets haben oft keine UID (MDT vergibt sie erst beim
---Teilen), dann bleibt nur der Name.
---@param preset table
---@return string|nil key, string|nil label
local function keyForPreset(preset)
    if type(preset) ~= "table" then return nil, nil end

    local label = type(preset.text) == "string" and preset.text or nil

    if type(preset.mdtrl) == "table" and type(preset.mdtrl.id) == "string" then
        return preset.mdtrl.id, label
    end
    if type(preset.mdtrlOrigin) == "string" then
        return preset.mdtrlOrigin, label
    end

    local id = preset.uid or label
    if not id then return nil, nil end
    return "mdt:" .. tostring(id), label
end

---Routenschluessel einer Route aus unserer Anzeige.
---Muss dieselbe Antwort geben wie keyForPreset, sonst findet die Liste die
---Zeiten nicht wieder.
---@param route table
---@return string|nil
function R.KeyFor(route)
    if type(route) ~= "table" then return nil end
    if not route.own then return route.id end
    if type(route.originId) == "string" then return route.originId end

    local id = route.mdtUid or route.title
    if not id then return nil end
    return "mdt:" .. tostring(id)
end

--------------------------------------------------------------------------
-- Aufzeichnung
--------------------------------------------------------------------------

---Welches Preset ist in MDT gerade fuer diesen Dungeon ausgewaehlt?
---@param challengeModeId number
---@return string|nil key, string|nil label
local function activePreset(challengeModeId)
    local dungeon = ns.GetDungeon and ns.GetDungeon(challengeModeId)
    local db = ns.MDT.GetDB()
    if not dungeon or not db then return nil, nil end

    -- Der eingebackene Index ist ein Tipp. Ist MDTs Oberflaeche schon geladen,
    -- lassen wir ihn pruefen; sonst nehmen wir ihn wie er ist, statt MDT
    -- mitten im Lauf nachzuladen.
    local idx = dungeon.mdtDungeonIdx
    local api = _G.MythicDungeonToolsAPI
    if ns.MDT.IsReady() and api then
        idx = ns.MDT.ResolveDungeonIdx(api, {
            dungeonEnglishName = dungeon.englishName,
            mdtDungeonIdx = idx,
        }) or idx
    end
    if not idx then return nil, nil end

    local presetIdx = type(db.currentPreset) == "table" and db.currentPreset[idx] or nil
    local list = type(db.presets) == "table" and db.presets[idx] or nil
    local preset = type(list) == "table" and presetIdx and list[presetIdx] or nil
    if type(preset) ~= "table" or preset.value == 0 then return nil, nil end

    local key, label = keyForPreset(preset)

    -- Gegenprobe, soweit moeglich: gehoert die Route ueberhaupt zu diesem
    -- Dungeon? Schuetzt davor, dass ein veralteter Index auf die Presets eines
    -- anderen Dungeons zeigt.
    local known = key and ns.routeById and ns.routeById[key]
    if known and known.challengeModeId ~= challengeModeId then return nil, nil end

    return key, label
end

---Schreibt einen fertigen Lauf in die Ablage.
---@param challengeModeId number
---@param level number
---@param seconds number
---@param onTime boolean
local function record(challengeModeId, level, seconds, onTime)
    local list = bucket(challengeModeId, true)
    if not list then return end

    local key, label = pendingKey, pendingLabel
    if not key then
        -- Kein Startsignal gesehen (etwa nach /reload mitten im Lauf): dann
        -- eben jetzt nachsehen. Meist steht dasselbe Preset noch da.
        key, label = activePreset(challengeModeId)
    end

    table.insert(list, 1, {
        key    = key,
        label  = label,
        level  = level,
        time   = seconds,
        onTime = onTime or nil,
        when   = time(),
    })

    for i = #list, MAX_PER_DUNGEON + 1, -1 do list[i] = nil end

    ns.Print(ns.L["RUN_RECORDED"],
        label or ns.L["RUN_UNKNOWN_ROUTE"], level, R.FormatTime(seconds))
end

--------------------------------------------------------------------------
-- Abfragen
--------------------------------------------------------------------------

---mm:ss aus Sekunden.
---@param seconds number|nil
---@return string
function R.FormatTime(seconds)
    if not seconds or seconds <= 0 then return "–" end
    return ("%d:%02d"):format(math.floor(seconds / 60), seconds % 60)
end

---Alle Laeufe einer Route, neueste zuerst.
---@param challengeModeId number
---@param key string|nil
---@return table
function R.ForRoute(challengeModeId, key)
    local list = bucket(challengeModeId)
    if not list or not key then return {} end

    local out = {}
    for _, run in ipairs(list) do
        if run.key == key then out[#out + 1] = run end
    end
    return out
end

---Bester Lauf einer Route.
---
---"Best" heisst schnellste Zeit. Ein Lauf ueber der Zeit zaehlt trotzdem: er
---sagt genauso viel darueber, wie die Route sich anfuehlt, und wer nur
---gewertete Laeufe sehen will, sieht am Haekchen, welche in der Zeit waren.
---@param challengeModeId number
---@param key string|nil
---@return table|nil
function R.Best(challengeModeId, key)
    local best
    for _, run in ipairs(R.ForRoute(challengeModeId, key)) do
        if not best or (run.time or math.huge) < (best.time or math.huge) then best = run end
    end
    return best
end

---Rangliste eines Dungeons: je Route der beste Lauf, schnellste zuerst.
---@param challengeModeId number
---@return table Liste aus { key, label, best, count }
function R.Ranking(challengeModeId)
    local list = bucket(challengeModeId)
    if not list then return {} end

    local byKey, order = {}, {}
    for _, run in ipairs(list) do
        local key = run.key or "?"
        local entry = byKey[key]
        if not entry then
            entry = { key = run.key, label = run.label, count = 0 }
            byKey[key] = entry
            order[#order + 1] = entry
        end
        entry.count = entry.count + 1
        -- Der Titel kann sich geaendert haben; der neueste Lauf gewinnt, und
        -- der steht vorn in der Liste.
        entry.label = entry.label or run.label
        if not entry.best or (run.time or math.huge) < (entry.best.time or math.huge) then
            entry.best = run
        end
    end

    table.sort(order, function(a, b)
        return (a.best and a.best.time or math.huge) < (b.best and b.best.time or math.huge)
    end)
    return order
end

--------------------------------------------------------------------------
-- Ereignisse
--------------------------------------------------------------------------

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHALLENGE_MODE_START")
frame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
frame:RegisterEvent("CHALLENGE_MODE_RESET")

frame:SetScript("OnEvent", function(_, event)
    if event == "CHALLENGE_MODE_START" then
        -- Beim Start festhalten, welche Route gemeint ist. Danach kann der
        -- Spieler in MDT umschalten, ohne die Aufzeichnung zu verfaelschen.
        local map = C_ChallengeMode.GetActiveChallengeMapID()
        pendingKey, pendingLabel = nil, nil
        if map and ns.EnsureData and ns.EnsureData() then
            pendingKey, pendingLabel = activePreset(map)
        end
        return
    end

    if event == "CHALLENGE_MODE_RESET" then
        pendingKey, pendingLabel = nil, nil
        return
    end

    local mapId, level, ms, onTime, _, practice = C_ChallengeMode.GetCompletionInfo()
    -- Uebungslaeufe zaehlen nicht: sie haben keine Wertung und wuerden die
    -- Rangliste mit Zeiten fuellen, die niemand vergleichen kann.
    if mapId and level and ms and ms > 0 and not practice then
        if ns.EnsureData then ns.EnsureData() end
        record(mapId, level, math.floor(ms / 1000), onTime)
    end

    pendingKey, pendingLabel = nil, nil
end)
