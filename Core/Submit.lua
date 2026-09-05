-- Einreichen eigener Routen.
--
-- Ein Addon kann nichts hochladen - es gibt keine Netzwerk-API in WoW. Der Weg
-- nach draussen ist die Zwischenablage: wir packen die in MDT geoeffnete Route
-- in einen Textblock, den der Nutzer mit Strg+C kopiert und in eine Einreichung
-- auf GitHub einfuegt (.github/ISSUE_TEMPLATE/route-submission.yml).
--
-- Bewusst NICHT MDTs eigener Exportstring: der ist CBOR-kodiert und braucht im
-- Build-Skript einen CBOR-Decoder. Unser Blob ist JSON, mit Deflate gepackt und
-- Base64-kodiert - das liest tools/parse-submission.mjs ohne Zusatzabhaengigkeit.
--
-- Was NICHT im Blob steckt: die NPC-IDs der Gegner. MDT gibt seine Gegnertabelle
-- nach aussen nicht frei. Die ergaenzt tools/parse-submission.mjs offline aus
-- den MDT-Quelldateien anhand von Dungeonname und Gegnerindex.

local _, ns = ...

local S = {}
ns.Submit = S

local FORMAT_VERSION = 1

---Liest das aktuell in MDT gewaehlte Preset.
---@return table|nil preset, number|nil dungeonIdx
local function getCurrentPreset()
    local db = ns.MDT.GetDB()
    if not db then return nil end

    local dungeonIdx = db.currentDungeonIdx
    if not dungeonIdx then return nil end

    local list = db.presets[dungeonIdx]
    if type(list) ~= "table" then return nil end

    local presetIdx = db.currentPreset and db.currentPreset[dungeonIdx]
    if not presetIdx then return nil end

    local preset = list[presetIdx]
    if type(preset) ~= "table" or type(preset.value) ~= "table" then return nil end

    return preset, dungeonIdx
end

S.GetCurrentPreset = getCurrentPreset

---Wandelt MDTs Pull-Tabelle in unser Format.
---MDT legt pro Pull { color = "rrggbb", [enemyIdx] = { cloneIdx, ... } } ab.
---@param pulls table
---@return table normalized, number enemyCount
local function normalizePulls(pulls)
    local out = {}
    local total = 0

    -- Ueber die belegten Indizes gehen, nicht ueber 1..#pulls: alte Presets
    -- koennen Luecken haben, und die Einreichung waere dann unvollstaendig.
    local keys = {}
    for key in pairs(pulls) do
        if type(key) == "number" then keys[#keys + 1] = key end
    end
    table.sort(keys)

    for _, key in ipairs(keys) do
        local pull = pulls[key]
        if type(pull) == "table" then
            local enemies = {}
            for enemyIdx, clones in pairs(pull) do
                if type(enemyIdx) == "number" and type(clones) == "table" then
                    local list = {}
                    for _, cloneIdx in ipairs(clones) do
                        list[#list + 1] = cloneIdx
                    end
                    if #list > 0 then
                        table.sort(list)
                        enemies[#enemies + 1] = { enemy = enemyIdx, clones = list }
                        total = total + #list
                    end
                end
            end

            -- Stabile Reihenfolge, damit derselbe Pull denselben Blob ergibt.
            table.sort(enemies, function(a, b) return a.enemy < b.enemy end)

            out[#out + 1] = {
                color   = type(pull.color) == "string" and pull.color or nil,
                enemies = enemies,
            }
        end
    end

    return out, total
end

S.NormalizePulls = normalizePulls

---Liefert das MDT-Preset zu einer eigenen Route aus dem Browser.
---@param route table
---@return table|nil preset, number|nil dungeonIdx
function S.GetPresetForRoute(route)
    if type(route) ~= "table" or not route.own then return nil end

    local db = ns.MDT.GetDB()
    if not db or type(db.presets) ~= "table" then return nil end

    local list = db.presets[route.mdtDungeonIdx]
    local preset = type(list) == "table" and list[route.mdtPresetIdx]
    if type(preset) ~= "table" or type(preset.value) ~= "table" then return nil end

    -- Gegenprobe ueber den Namen: die Liste kann sich verschoben haben.
    if preset.text ~= route.title then return nil end

    return preset, route.mdtDungeonIdx
end

---Packt eine Route zum Einreichen.
---@return string|nil blob, string|nil err
---@param preset table|nil Bestimmtes Preset; ohne Angabe das in MDT geoeffnete
---@param dungeonIdx number|nil MDT-Dungeonindex zu diesem Preset
function S.BuildBlob(preset, dungeonIdx)
    -- Ohne Vorgabe das nehmen, was in MDT offen ist. Mit Vorgabe genau die
    -- Route, die der Nutzer in der Liste angeklickt hat - alles andere waere
    -- ueberraschend.
    if not preset then
        preset, dungeonIdx = getCurrentPreset()
    end
    if not preset or not dungeonIdx then return nil, ns.L["SUBMIT_NO_PRESET"] end

    local pulls, enemyCount = normalizePulls(preset.value.pulls or {})
    if #pulls == 0 or enemyCount == 0 then return nil, ns.L["SUBMIT_EMPTY"] end

    local api = _G.MythicDungeonToolsAPI
    local englishName = api and api:GetDungeonName(dungeonIdx, true) or nil

    local name, realm = UnitFullName("player")
    local _, _, _, tocVersion = GetBuildInfo()

    local payload = {
        format    = FORMAT_VERSION,
        addon     = ns.version,
        createdAt = date("%Y-%m-%d"),
        interface = tocVersion,

        -- Der Index ist nur ein Hinweis; verbindlich ist der englische Name.
        dungeon = {
            mdtIndex    = dungeonIdx,
            englishName = englishName,
        },

        -- Wird im Dialog offengelegt, damit die Angabe niemanden ueberrascht.
        author = {
            character = name and realm and (name .. "-" .. realm) or name,
        },

        route = {
            title    = preset.text,
            -- MDTs "Dungeon Level"-Regler: sagt, fuer welche Schluesselstufe
            -- die Route gedacht ist.
            keyLevel = type(preset.difficulty) == "number" and preset.difficulty or nil,
            sublevel = preset.value.currentSublevel or 1,
            pulls    = pulls,
        },
    }

    local json = ns.ToJSON(payload)
    local packed, err = ns.PackString(json)
    if not packed then return nil, err end

    return ns.SUBMIT_PREFIX .. packed
end
