-- Routen-Browser als eigene Sektion in MDTs Fenster.
--
-- MDT erlaubt fremden Addons ueber pluginAPI:RegisterNavigationSection eine
-- eigene Sektion mit Icon in der Seitenleiste. MDT legt dafuer zwei Frames an
-- und blendet sie passend ein und aus:
--   * den Content-Frame  - deckt MDTs Kartenbereich ab (unsere Routenliste)
--   * den SidePanel-Frame - deckt MDTs rechte Spalte ab (unsere Details)
-- Nur mit beiden nutzen wir die volle Fensterbreite; deshalb steht
-- createSidePanelFrame hier bewusst auf true.
--
-- Warum in MDT und nicht in einem eigenen Fenster: der Wert eines
-- Routenbrowsers ist die Kartenvorschau, und die zeichnet MDT bereits. Ein
-- Klick auf eine Route wechselt in die Kartenansicht und laedt sie dort -
-- kein nachgebauter Kartenrenderer noetig.

local _, ns = ...

local B = {}
ns.Browser = B

local SECTION_KEY = "mdtRouteLibrary"

local T = ns.Theme

-- Eigenes Emblem. Die kleine Fassung ist auf 32 Pixel gerechnet, weil WoW
-- ohne Mipmaps filtert und eine 128er-Grafik auf Leistengroesse rauschen
-- wuerde. Erzeugt von tools/convert-textures.ps1 aus branding/png.
local ICON        = "Interface\\AddOns\\MDTRouteLibrary\\Media\\Textures\\logo-small"
local ICON_COORDS = { 0, 1, 0, 1 }

local ROW_HEIGHT     = 34
local HEADER_HEIGHT  = 24
local PULLROW_HEIGHT = 16
local SPELL_ICON     = 16
local PADDING        = 14
local DUNGEON_BUTTON = 42

-- Spaltenbreiten der Routenliste. Kopfzeile und Zeilen richten sich beide
-- danach, sonst stehen die Ueberschriften irgendwo.
local COL_FAV     = 26
local COL_PERCENT = 62
local COL_FORCES  = 76
local COL_PULLS   = 54
local COL_LEVEL   = 62  -- "+10-18" braucht mehr Platz als "+10"

local pluginAPI
local ui           -- gebaute Oberflaeche
local entries = {} -- flache Liste aus Kopfzeilen und Routen
local selectedId
local filterText = ""
local filterDungeon -- challengeModeId oder nil fuer "alle"
local filterMode = "all" -- "all" | "community" | "mine"
-- Filterkriterien. 0 heisst jeweils "egal".
local filters = {
    favourites = false,
    minPercent = 0,  -- Mindestanteil der feindlichen Kraefte
    minLevel   = 0,  -- Schluesselstufe ab
    maxPulls   = 0,  -- hoechstens so viele Pulls
}

---Wie viele Kriterien sind gesetzt? Steht als Zahl am Filterknopf.
---@return number
local function activeFilterCount()
    local n = 0
    if filters.favourites then n = n + 1 end
    if filters.minPercent > 0 then n = n + 1 end
    if filters.minLevel > 0 then n = n + 1 end
    if filters.maxPulls > 0 then n = n + 1 end
    return n
end

-- Eingeklappte Bereiche und Dungeongruppen, Schluessel wie "section:community".
local collapsed = {}

-- Wie viele Routen je Abschnitt auf eine Seite passen.
local PAGE_SIZE = 10
local PAGER_HEIGHT = 28

-- Aktuelle Seite je Abschnitt.
local pages = {}

-- Auswahl muss auch eigene Routen finden. ns.routeById kennt nur das
-- Datenpaket; die Routen aus MDT stehen dort nie drin.
local displayById = {}

-- Angehakte eigene Routen (Routen-ID -> true). Nur im Modus "mine" benutzt.
local checked = {}

-- Vorwaertsdeklaration: wird schon beim Loeschen und Anzeigen gebraucht,
-- steht aber erst weiter unten.
local savedPreset

-- Zuletzt geloeschte Presets, fuer "Rueckgaengig". Bewusst nur im Speicher:
-- ein Neuladen der Oberflaeche gilt als "Entscheidung steht".
local trash = {}

-- Letzter bekannter Stand von MDTs Presets, siehe presetFingerprint().
local lastFingerprint

-- Vorwaertsdeklaration: updateDetail() ruft die Dungeonuebersicht auf, die
-- weiter unten steht. Ohne das waere der Aufruf zur Laufzeit ein nil.
local updateDungeonDetail

--------------------------------------------------------------------------
-- Kennzahlen
--------------------------------------------------------------------------

---Anteil der Gegnerkraefte, den eine Route abdeckt.
---Das ist die Zahl, die in Mythic+ zaehlt: unter 100 % reicht die Route nicht.
---@param route table
---@return number|nil percent
local function forcesPercent(route)
    local have, need = route.enemyForces, route.enemyForcesRequired
    if not have or not need or need <= 0 then return nil end
    return have / need * 100
end

B.ForcesPercent = forcesPercent

---Farbcode zum Prozentwert.
---@param percent number|nil
---@return string
local function percentColor(percent)
    if not percent then return T:Hex("textMuted") end
    if percent >= 100 then return T:Hex("success") end -- reicht
    if percent >= 90 then return T:Hex("warning") end  -- knapp
    return T:Hex("danger")                             -- zu wenig
end

---Formatiert den Prozentwert einer Route.
---@param route table
---@return string
local function percentText(route)
    local percent = forcesPercent(route)
    if not percent then return T:Text("textMuted", "?") end
    return ("%s%.1f %%|r"):format(percentColor(percent), percent)
end

B.PercentText = percentText

---Beschriftung der Stufenspalte.
---Ein Bereich, wenn beide Grenzen bekannt sind, sonst die einzelne Angabe.
---@param route table
---@return string
local function levelText(route)
    local min, max = route.keyLevelMin, route.keyLevelMax

    if min and max and max > min then
        return ("%s+%d–%d|r"):format(T:Hex("accent"), min, max)
    end

    local single = min or max or route.keyLevel or route.difficulty
    if not single then return "" end
    return ("%s+%d|r"):format(T:Hex("accent"), single)
end

---Hoechste Stufe, fuer die eine Route gedacht ist. Fuer den Filter.
---@param route table
---@return number|nil
local function levelCeiling(route)
    return route.keyLevelMax or route.keyLevelMin or route.keyLevel or route.difficulty
end

---Fasst die Gegner eines Pulls zusammen: "3x Bloodletter, 2x Living Venom".
---@param route table
---@param pull table
---@return string
local function pullSummary(route, pull)
    local counts, order = {}, {}
    for _, entry in ipairs(pull.enemies or {}) do
        local npc = entry.npc
        if npc then
            if not counts[npc] then
                counts[npc] = 0
                order[#order + 1] = npc
            end
            counts[npc] = counts[npc] + #(entry.clones or {})
        end
    end

    local parts = {}
    for _, npc in ipairs(order) do
        parts[#parts + 1] = ("%dx %s"):format(counts[npc], ns.GetNpcName(route.challengeModeId, npc))
    end
    return table.concat(parts, ", ")
end

B.PullSummary = pullSummary

--------------------------------------------------------------------------
-- Gegnervorschau
--------------------------------------------------------------------------

-- Beim Ueberfahren eines Pulls zeigen wir dasselbe wie MDT: ein 3D-Modell des
-- Gegners plus die harten Zahlen. Das Modell kommt ueber die displayId, die im
-- Datenpaket steckt - es gibt keine Portraittexturen fuer NPCs, die man
-- ausliefern koennte.

-- Zauberarten wie in MDTs Gegner-Panel. Die Farben folgen den ueblichen
-- Konventionen: Magie blau, Fluch violett, Gift gruen, Krankheit braun.
local DISPEL_TYPES = {
    { key = "magic",   label = "MAGIC",   r = 0.20, g = 0.60, b = 1.00 },
    { key = "curse",   label = "CURSE",   r = 0.64, g = 0.32, b = 0.92 },
    { key = "poison",  label = "POISON",  r = 0.30, g = 0.85, b = 0.30 },
    { key = "disease", label = "DISEASE", r = 0.72, g = 0.55, b = 0.25 },
    { key = "bleed",   label = "BLEED",   r = 0.85, g = 0.18, b = 0.18 },
    { key = "enrage",  label = "ENRAGE",  r = 1.00, g = 0.50, b = 0.00 },
}

local preview

---Baut den Vorschaurahmen beim ersten Aufruf.
---@return table
local function ensurePreview()
    if preview then return preview end

    local frame = CreateFrame("Frame", "MDTRouteLibraryEnemyPreview", UIParent, "TooltipBorderedFrameTemplate")
    frame:SetSize(250, 168)
    -- Eine Stufe unter TOOLTIP, damit Blizzards Zaubertooltip darueber liegt.
    frame:SetFrameStrata("FULLSCREEN_DIALOG")
    -- Rein informativ: anklicken muss man hier nichts, die Zauber haengen an
    -- den Zeilen selbst. Ohne Maus kommt sie auch niemandem in die Quere.
    frame:EnableMouse(false)
    frame:Hide()

    frame.model = CreateFrame("PlayerModel", nil, frame)
    frame.model:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
    frame.model:SetSize(96, 128)

    frame.name = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.name:SetPoint("TOPLEFT", frame.model, "TOPRIGHT", 10, -2)
    frame.name:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
    frame.name:SetJustifyH("LEFT")
    frame.name:SetWordWrap(true)

    frame.lines = {}
    local anchor = frame.name
    for i = 1, 5 do
        local line = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        line:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -4)
        line:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
        line:SetJustifyH("LEFT")
        frame.lines[i] = line
        anchor = line
    end

    preview = frame
    return frame
end

---Formatiert Lebenspunkte kurz (29.9m statt 29900000).
---@param health number|nil
---@return string
local function shortHealth(health)
    if not health or health <= 0 then return "?" end
    if health >= 1e9 then return ("%.1fb"):format(health / 1e9) end
    if health >= 1e6 then return ("%.1fm"):format(health / 1e6) end
    if health >= 1e3 then return ("%.0fk"):format(health / 1e3) end
    return tostring(health)
end

---Zeigt Modell und Werte eines Gegners.
---@param owner table Zeile, an der die Vorschau haengt
---@param challengeModeId number
---@param npcId number
---@param amount number|nil Anzahl in diesem Pull
local function showEnemyPreview(owner, challengeModeId, npcId, amount)
    local npc = ns.GetNpc(challengeModeId, npcId)
    if not npc then return end

    local dungeon = ns.GetDungeon(challengeModeId)
    local need = dungeon and dungeon.totalCount

    local frame = ensurePreview()
    frame:ClearAllPoints()
    -- Links neben die Zeile: die Detailspalte sitzt rechts am Fensterrand,
    -- nach rechts waere kein Platz mehr.
    frame:SetPoint("TOPRIGHT", owner, "TOPLEFT", -6, 8)

    if npc.displayId then
        frame.model:SetDisplayInfo(npc.displayId)
        frame.model:SetPortraitZoom(0.55)
        frame.model:Show()
    else
        frame.model:Hide()
    end

    frame.name:SetText(("%s%s|r"):format(npc.isBoss and T:Hex("accent") or T:Hex("textPrimary"), npc.name or "?"))

    local share = (npc.count and need and need > 0) and (npc.count / need * 100) or nil
    local info = {
        ("%s %s %s"):format(ns.L["PREVIEW_LEVEL"], tostring(npc.level or "?"), npc.creatureType or ""),
        ("NPC-ID: " .. T:Hex("textSecondary") .. "%d|r"):format(npcId),
        -- MDT skaliert das Leben nach Schluesselstufe und Affix; wir haben nur
        -- den Basiswert, deshalb steht das auch so dran.
        ("%s " .. T:Hex("textSecondary") .. "%s|r"):format(ns.L["PREVIEW_HEALTH"], shortHealth(npc.health)),
        share and ("%s " .. T:Hex("textSecondary") .. "%d (%.2f %%)|r"):format(ns.L["PREVIEW_FORCES"], npc.count, share)
            or ("%s " .. T:Hex("textSecondary") .. "%s|r"):format(ns.L["PREVIEW_FORCES"], tostring(npc.count or "?")),
        amount and ("%s " .. T:Hex("textSecondary") .. "%dx|r"):format(ns.L["PREVIEW_IN_PULL"], amount) or "",
    }

    for i, line in ipairs(frame.lines) do
        line:SetText(info[i] or "")
    end

    frame.owner = owner
    frame:Show()
end

---Blendet die Vorschau aus.
local function hidePreview()
    if preview then preview:Hide() end
end

--------------------------------------------------------------------------
-- Aktionen
--------------------------------------------------------------------------

---Sucht in MDTs Preset-Liste den Eintrag zu einer Route.
---@param db table
---@param dungeonIdx number
---@param routeId string
---@return number|nil
local function findPresetIndex(db, dungeonIdx, routeId)
    local list = db.presets and db.presets[dungeonIdx]
    if type(list) ~= "table" then return nil end

    for i, preset in ipairs(list) do
        if type(preset) == "table" and preset.mdtrl and preset.mdtrl.id == routeId then
            return i
        end
    end
    return nil
end

---Wechselt MDT auf den Dungeon einer Route und waehlt sie aus.
---
---MDT haengt den Dungeonindex als Feld an seine global benannten
---Dungeon-Buttons (DungeonSelect.lua: `button.dungeonIdx = dungeonIdx`).
---Damit kommen wir ohne Zugriff auf MDTs private Tabellen aus: passenden
---Button suchen und klicken, wie es der Nutzer auch taete.
---@param route table
function B.ShowOnMap(route)
    local api = _G.MythicDungeonToolsAPI
    local db  = ns.MDT.GetDB()
    if not api or not db then return end

    local dungeonIdx = ns.MDT.ResolveDungeonIdx(api, route)
    if not dungeonIdx then
        ns.Warn(ns.L["BROWSER_NO_DUNGEON"])
        return
    end

    -- Eigene Routen liegen bereits in MDT. Community-Routen kommen erst jetzt
    -- hinein - in einen Vorschauplatz, der beim naechsten Mal ueberschrieben
    -- wird. So bleibt die Preset-Auswahl des Nutzers sauber.
    local presetIdx
    local savedDungeon, savedIdx = savedPreset(route)
    if savedIdx then
        dungeonIdx, presetIdx = savedDungeon, savedIdx
    else
        local idx, slot, err = ns.MDT.PutPreset(route, false)
        if not idx then
            ns.Warn(err or ns.L["BROWSER_NO_DUNGEON"])
            return
        end
        dungeonIdx, presetIdx = idx, slot
    end

    if not presetIdx then
        ns.Warn(ns.L["BROWSER_NOT_INSTALLED"])
        return
    end

    -- Erst in die Kartenansicht: dort blendet MDT die Dungeon-Buttons ein.
    if pluginAPI then pluginAPI:SetCurrentSection("maps") end

    -- Auswahl vorab setzen. Wechselt MDT gleich den Dungeon, liest es sie
    -- beim Aufbau des Dropdowns selbst aus - dann brauchen wir kein zweites
    -- Anstossen, das mit MDTs asynchronem Kartenaufbau kollidieren koennte.
    if db.currentPreset then db.currentPreset[dungeonIdx] = presetIdx end

    if db.currentDungeonIdx ~= dungeonIdx then
        for i = 1, 30 do
            local button = _G["MDTDungeonButton" .. i]
            if button and button.dungeonIdx == dungeonIdx then
                button:Click()
                return
            end
        end
        -- Der Dungeon gehoert zu einer anderen Saison-Auswahl.
        ns.Warn(ns.L["BROWSER_WRONG_SEASON"])
        return
    end

    -- Schon im richtigen Dungeon: MDTs Dropdown selbst ausloesen.
    local frame = _G.MDTFrame
    local group = frame and frame.sidePanel and frame.sidePanel.WidgetGroup
    local dropdown = group and group.PresetDropDown
    if dropdown and dropdown.Fire then
        dropdown:SetValue(presetIdx)
        dropdown:Fire("OnValueChanged", presetIdx)
    end
end

---Zeigt den MDT-Importstring einer Route zum Kopieren.
---@param route table
function B.CopyString(route)
    local str, err = ns.MDT.BuildImportString(route)
    if not str then
        ns.Warn(err or ns.L["COPY_FAILED"])
        return
    end
    ns.UI.ShowCopyDialog(route.title or route.id, ns.L["COPY_HELP"], str)
end

--------------------------------------------------------------------------
-- Eigene Routen aus MDT
--------------------------------------------------------------------------

---Liest die Presets, die der Nutzer selbst in MDT angelegt hat.
---
---Erkennbar sind sie daran, was sie NICHT haben: unsere MDTRouteLibrary-Markierung.
---MDTs eigene Platzhalter ("Default" ohne Pulls, "<New Preset>" mit value == 0)
---fallen ebenfalls raus.
---@return table Routen im selben Format wie unsere eigenen
local function collectOwnRoutes()
    local api = _G.MythicDungeonToolsAPI
    local db  = ns.MDT.GetDB()
    if not api or not db or type(db.presets) ~= "table" then return {} end

    local result = {}
    for _, dungeon in ipairs(ns.dungeons) do
        local idx = dungeon.mdtDungeonIdx
        -- Der eingebackene Index ist nur ein Tipp; verbindlich ist der Name.
        local name = api:GetDungeonName(idx, true)
        if type(name) ~= "string" or name:lower() ~= (dungeon.englishName or ""):lower() then
            idx = nil
            for i = 1, 250 do
                local candidate = api:GetDungeonName(i, true)
                if type(candidate) == "string" and candidate:lower() == (dungeon.englishName or ""):lower() then
                    idx = i
                    break
                end
            end
        end

        local list = idx and db.presets[idx]
        if type(list) == "table" then
            for presetIdx, preset in ipairs(list) do
                local value = type(preset) == "table" and preset.value

                -- 1:1 mit MDTs Auswahlliste. Ausgenommen ist nur der
                -- Platzhalter "<New Preset>", den MDT mit value == 0 markiert -
                -- der ist keine Route, sondern ein Menueeintrag.
                local isPlaceholder = value == 0 or value == nil
                local pulls = (type(value) == "table" and type(value.pulls) == "table") and value.pulls or {}

                if not isPlaceholder and not preset.mdtrl then
                    local forces = ns.CountForces(dungeon.challengeModeId, pulls)
                    result[#result + 1] = {
                        id = "mdt-" .. tostring(idx) .. "-" .. tostring(presetIdx),
                        own = true,
                        mdtPresetIdx = presetIdx,
                        mdtDungeonIdx = idx,
                        source = "MDT",
                        -- Aus welcher Community-Route stammt diese Kopie?
                        originId = type(preset.mdtrlOrigin) == "string"
                            and preset.mdtrlOrigin or nil,
                        title = preset.text or "?",
                        -- MDT merkt sich, wer ein Preset angelegt hat, und zeigt
                        -- den Namen im Dropdown davor. Uebernehmen wir.
                        -- MDT legt createdBy als Tabelle ab: { name, classIdx }.
                        author = (type(preset.createdBy) == "table"
                            and type(preset.createdBy.name) == "string")
                            and preset.createdBy.name or nil,
                        challengeModeId = dungeon.challengeModeId,
                        dungeonEnglishName = dungeon.englishName,
                        -- MDTs "Dungeon Level"-Regler landet in preset.difficulty.
                        difficulty = type(preset.difficulty) == "number" and preset.difficulty or nil,
                        enemyForces = forces,
                        enemyForcesRequired = dungeon.totalCount,
                        pulls = ns.BuildOwnPulls(dungeon.challengeModeId, pulls),
                    }
                end
            end
        end
    end

    return result
end

--------------------------------------------------------------------------
-- Eigene Routen loeschen
--------------------------------------------------------------------------

---Alle gerade angezeigten Routen, die sich loeschen lassen.
---MDTs "Default" auf Index 1 gehoert nicht dazu - das laesst auch MDT nicht zu.
---@return table Liste von Routen
local function deletableRoutes()
    local list = {}
    for _, route in pairs(displayById) do
        local _, presetIdx = savedPreset(route)
        if presetIdx and presetIdx > 1 then list[#list + 1] = route end
    end
    return list
end

---Wo liegt diese Route in MDT - egal ob eigene oder gespeicherte Kopie?
---@param route table
---@return number|nil dungeonIdx, number|nil presetIdx, string|nil title
function savedPreset(route)
    if route.own then return route.mdtDungeonIdx, route.mdtPresetIdx, route.title end
    if route.saved then return route.saved.mdtDungeonIdx, route.saved.mdtPresetIdx, route.saved.title end
    return nil
end

---Ist eine Route als Favorit markiert?
---@param id string
---@return boolean
local function isFavourite(id)
    return MDTRouteLibraryDB and MDTRouteLibraryDB.favourites and MDTRouteLibraryDB.favourites[id] == true
end

---Schaltet den Favoritenstatus um.
---@param id string
local function toggleFavourite(id)
    MDTRouteLibraryDB = MDTRouteLibraryDB or {}
    MDTRouteLibraryDB.favourites = MDTRouteLibraryDB.favourites or {}
    MDTRouteLibraryDB.favourites[id] = (not MDTRouteLibraryDB.favourites[id]) or nil
end

---Zaehlt die angehakten Routen.
---@return number
local function countChecked()
    local n = 0
    for _ in pairs(checked) do n = n + 1 end
    return n
end

---Beschriftung eines Presets in MDTs Dropdown.
---
---Nachgebaut aus MDT:GetPresetDropdownText: Ersteller in Klassenfarbe, dann
---der Name. Die Funktion selbst ist nicht exportiert, das Format aber simpel.
---@param preset table
---@return string
local function presetDropdownText(preset)
    local text = preset.text or ""
    local createdBy = preset.createdBy

    if type(createdBy) == "table" and type(createdBy.name) == "string" and createdBy.classIdx then
        local _, classFile = GetClassInfo(createdBy.classIdx)
        if classFile then
            local _, _, _, hex = GetClassColor(classFile)
            if hex then
                return WrapTextInColorCode(createdBy.name, hex) .. " - " .. text
            end
        end
        return createdBy.name .. " - " .. text
    end

    return text
end

---Baut MDTs Preset-Dropdown neu auf.
---
---Der naheliegende Weg - Klick auf den Dungeon-Button - hilft hier nicht:
---MDT:UpdateToDungeon steigt sofort aus, wenn der Dungeon schon aktiv ist
---(MapView.lua: "if dungeonIdx == db.currentDungeonIdx then return end").
---Genau das ist beim Loeschen und Wiederherstellen der Normalfall, und deshalb
---blieb die Liste in MDT unveraendert stehen.
---
---Fuer andere Dungeons ist nichts zu tun: dort baut MDT das Dropdown ohnehin
---neu, sobald der Nutzer hinwechselt.
---@param dungeonIdx number
---@return boolean refreshed
local function refreshMDT(dungeonIdx)
    local db = ns.MDT.GetDB()
    if not db or db.currentDungeonIdx ~= dungeonIdx then return false end

    local frame = _G.MDTFrame
    local group = frame and frame.sidePanel and frame.sidePanel.WidgetGroup
    local dropdown = group and group.PresetDropDown
    if not dropdown or not dropdown.SetList then return false end

    local list = db.presets and db.presets[dungeonIdx]
    if type(list) ~= "table" then return false end

    local entries = {}
    for index, preset in pairs(list) do
        if type(preset) == "table" then
            entries[index] = presetDropdownText(preset)
        end
    end

    dropdown:SetList(entries)
    dropdown:SetValue((db.currentPreset and db.currentPreset[dungeonIdx]) or 1)
    if dropdown.ClearFocus then dropdown:ClearFocus() end

    return true
end

---Loescht die angehakten Routen aus MDTs Datenbank.
---
---Absteigend nach Index loeschen, sonst verschieben sich die folgenden
---Eintraege waehrend des Durchlaufs. Index 1 bleibt unangetastet - das ist
---MDTs "Default", das auch MDT selbst nicht loescht.
---@return number deleted, number requested
local function deleteChecked()
    local db = ns.MDT.GetDB()
    if not db or type(db.presets) ~= "table" then return 0, 0 end

    -- Nach Dungeon buendeln und dabei merken, was wir loeschen wollten.
    local byDungeon, requested = {}, 0
    for id in pairs(checked) do
        local route = displayById[id]
        local dungeonIdx, presetIdx, title = savedPreset(route or {})
        if dungeonIdx and presetIdx and presetIdx > 1 then
            local bucket = byDungeon[dungeonIdx]
            if not bucket then
                bucket = {}
                byDungeon[dungeonIdx] = bucket
            end
            -- Namen mitnehmen: damit laesst sich hinterher pruefen, ob der
            -- richtige Eintrag verschwunden ist.
            bucket[#bucket + 1] = { index = presetIdx, text = title }
            requested = requested + 1
        end
    end

    -- Nur die letzte Loeschung laesst sich zurueckholen. Mehr Stufen waeren
    -- Speicher fuer einen Fall, den es in der Praxis nicht gibt.
    wipe(trash)

    local deleted = 0
    for dungeonIdx, items in pairs(byDungeon) do
        local list = db.presets[dungeonIdx]
        if type(list) == "table" then
            local before = #list

            table.sort(items, function(a, b) return a.index > b.index end)
            for _, item in ipairs(items) do
                local preset = list[item.index]
                -- Nur loeschen, wenn an der Stelle wirklich das steht, was wir
                -- meinen. Sonst hat sich die Liste zwischendurch verschoben.
                if type(preset) == "table" and preset.text == item.text then
                    tremove(list, item.index)
                    -- Aufheben statt verwerfen: Loeschen ist sonst endgueltig,
                    -- und ein Fehlklick kostet Arbeit von Stunden.
                    trash[#trash + 1] = {
                        dungeonIdx = dungeonIdx,
                        index = item.index,
                        preset = preset,
                    }
                end
            end

            deleted = deleted + (before - #list)

            -- Auswahl des Nutzers kann jetzt ins Leere zeigen.
            local current = db.currentPreset and db.currentPreset[dungeonIdx]
            if current and current > #list - 1 then
                db.currentPreset[dungeonIdx] = 1
            end

            refreshMDT(dungeonIdx)
        end
    end

    wipe(checked)
    -- Eigene Aenderung: Fingerabdruck nachziehen, sonst loest die Ueberwachung
    -- gleich darauf ein zweites Neuzeichnen aus.
    lastFingerprint = nil
    return deleted, requested
end

---Holt die zuletzt geloeschten Routen zurueck.
---
---Eingefuegt wird aufsteigend nach dem alten Index, damit die Reihenfolge
---wieder stimmt. Hat sich die Liste zwischenzeitlich verkuerzt, landet der
---Eintrag vor MDTs "<New Preset>"-Platzhalter statt daneben.
---@return number restored
local function restoreDeleted()
    local db = ns.MDT.GetDB()
    if not db or type(db.presets) ~= "table" or #trash == 0 then return 0 end

    table.sort(trash, function(a, b) return a.index < b.index end)

    local restored = 0
    local touched = {}
    for _, item in ipairs(trash) do
        local list = db.presets[item.dungeonIdx]
        if type(list) == "table" then
            local index = math.max(2, math.min(item.index, #list))
            tinsert(list, index, item.preset)
            restored = restored + 1
            touched[item.dungeonIdx] = true
        end
    end

    wipe(trash)
    for dungeonIdx in pairs(touched) do refreshMDT(dungeonIdx) end

    lastFingerprint = nil
    return restored
end

StaticPopupDialogs["MDTRL_DELETE"] = {
    text = "%d Route(n) aus MDT loeschen? Das laesst sich nicht rueckgaengig machen.",
    button1 = YES,
    button2 = NO,
    OnAccept = function()
        local deleted, requested = deleteChecked()
        ns.Print(ns.L["DELETE_DONE"], deleted)
        if deleted > 0 then ns.Print(ns.L["DELETE_UNDO_HINT"]) end
        -- Wenn weniger verschwunden ist als angefordert, nicht so tun, als
        -- waere alles gut gegangen.
        if deleted < requested then
            ns.Warn(ns.L["DELETE_PARTIAL"], requested - deleted)
        end
        B.Refresh()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

--------------------------------------------------------------------------
-- Abgleich mit MDT
--------------------------------------------------------------------------

-- Wer in MDT einen Importstring einfuegt, soll die Route sofort hier sehen.
-- MDT sendet dafuer kein Ereignis, also pruefen wir selbst - aber billig:
-- nur Anzahl der Presets und Anzahl der Pulls, ohne Tabellen zu bauen.

---Billiger Fingerabdruck von MDTs Preset-Datenbank.
---@return string
local function presetFingerprint()
    local db = ns.MDT.GetDB()
    if not db or type(db.presets) ~= "table" then return "" end

    local parts = {}
    for _, dungeon in ipairs(ns.dungeons) do
        local list = db.presets[dungeon.mdtDungeonIdx]
        if type(list) == "table" then
            local pulls = 0
            for _, preset in ipairs(list) do
                local value = type(preset) == "table" and preset.value
                if type(value) == "table" and type(value.pulls) == "table" then
                    pulls = pulls + #value.pulls
                end
            end
            parts[#parts + 1] = ("%d:%d:%d"):format(dungeon.mdtDungeonIdx, #list, pulls)
        end
    end
    return table.concat(parts, "|")
end

---Prueft, ob sich MDTs Presets geaendert haben, und zeichnet dann neu.
---@return boolean changed
local function syncWithMDT()
    local fingerprint = presetFingerprint()
    if fingerprint == lastFingerprint then return false end

    lastFingerprint = fingerprint
    return true
end

--------------------------------------------------------------------------
-- Routenliste
--------------------------------------------------------------------------

---Baut die flache Anzeigeliste: pro Dungeon eine Kopfzeile, darunter die Routen.
local function rebuildEntries()
    wipe(entries)
    wipe(displayById)

    local needle = filterText:lower()
    local byDungeon = {}
    local order = {}

    -- Eigene Presets immer einlesen: auch im Community-Modus muss die Liste
    -- wissen, welche Route bereits in MDT liegt.
    local ownRoutes = collectOwnRoutes()
    local byOrigin = {}
    for _, route in ipairs(ownRoutes) do
        if route.originId then byOrigin[route.originId] = route end
    end

    -- Eine gespeicherte Community-Route erscheint nur einmal - als die
    -- Community-Route, die sie ist, aber mit dem Vermerk, dass sie in MDT
    -- liegt. Loescht der Nutzer sie dort, faellt der Vermerk weg.
    local source = {}
    for _, route in ipairs(ns.routes) do
        route.saved = byOrigin[route.id]
        if filterMode ~= "mine" or route.saved then
            source[#source + 1] = route
        end
    end

    if filterMode ~= "community" then
        for _, route in ipairs(ownRoutes) do
            -- Kopien nicht doppelt: die stecken schon im Original.
            if not route.originId then source[#source + 1] = route end
        end
    end

    local needle = filterText:lower()

    -- Drei Toepfe. Ein Favorit steht nur oben und nicht noch einmal weiter
    -- unten - sonst waere er doppelt und die Liste wieder unruhig.
    local buckets = {
        favourites = {},
        community = {},
        mine = {},
    }

    for _, route in ipairs(source) do
        local matchesDungeon = not filterDungeon or route.challengeModeId == filterDungeon
        local haystack = ((route.title or "") .. " " .. (route.author or "") .. " " ..
            (route.dungeonEnglishName or "")):lower()

        local percent = forcesPercent(route)
        -- Fuer den Filter zaehlt die Obergrenze: eine Route fuer +2 bis +9
        -- soll bei "ab +18" nicht auftauchen, eine fuer +10 bis +20 schon.
        local level = levelCeiling(route)
        local pulls = #(route.pulls or {})

        -- Routen ohne Angabe fallen nur raus, wenn nach dem Kriterium
        -- tatsaechlich gefiltert wird.
        local passesPercent = filters.minPercent == 0
            or (percent ~= nil and percent >= filters.minPercent)
        local passesFavourite = not filters.favourites or isFavourite(route.id)
        local passesLevel = filters.minLevel == 0 or (level ~= nil and level >= filters.minLevel)
        local passesPulls = filters.maxPulls == 0 or pulls <= filters.maxPulls

        if matchesDungeon and passesPercent and passesFavourite and passesLevel and passesPulls
            and (needle == "" or haystack:find(needle, 1, true)) then
            local bucket
            if isFavourite(route.id) then
                bucket = buckets.favourites
            elseif route.own then
                bucket = buckets.mine
            else
                bucket = buckets.community
            end
            bucket[#bucket + 1] = route
            displayById[route.id] = route
        end
    end

    ---Haengt einen Bereich samt seiner Dungeongruppen an die Anzeige.
    ---@param key string
    ---@param label string
    ---@param list table
    local function addSection(key, label, list)
        if #list == 0 then return end

        -- Erst den ganzen Abschnitt sortieren, dann die Seite herausschneiden.
        -- Andersherum liefen die Seiten quer durch die Dungeongruppen.
        table.sort(list, function(a, b)
            local nameA = a.dungeonEnglishName or ""
            local nameB = b.dungeonEnglishName or ""
            if nameA ~= nameB then return nameA < nameB end
            return (forcesPercent(a) or 0) > (forcesPercent(b) or 0)
        end)

        local sectionKey = "section:" .. key
        local pageCount = math.max(1, math.ceil(#list / PAGE_SIZE))

        -- Seite festhalten, aber nie ins Leere zeigen lassen: Filter koennen
        -- die Liste jederzeit verkuerzen.
        local page = math.min(pages[sectionKey] or 1, pageCount)
        pages[sectionKey] = page

        entries[#entries + 1] = {
            section = true,
            key = sectionKey,
            text = label,
            count = #list,
            collapsed = collapsed[sectionKey] or false,
        }
        if collapsed[sectionKey] then return end

        local first = (page - 1) * PAGE_SIZE + 1
        local last = math.min(#list, page * PAGE_SIZE)

        local byDungeon, order = {}, {}
        for index = first, last do
            local route = list[index]
            local dungeon = route.dungeonEnglishName or "?"
            if not byDungeon[dungeon] then
                byDungeon[dungeon] = {}
                order[#order + 1] = dungeon
            end
            local bucket = byDungeon[dungeon]
            bucket[#bucket + 1] = route
        end

        for _, dungeon in ipairs(order) do

            local groupKey = sectionKey .. ":" .. dungeon
            local ids = {}
            for _, route in ipairs(byDungeon[dungeon]) do ids[#ids + 1] = route.id end

            entries[#entries + 1] = {
                header = true,
                key = groupKey,
                text = dungeon,
                count = #byDungeon[dungeon],
                ids = ids,
                collapsed = collapsed[groupKey] or false,
            }
            if not collapsed[groupKey] then
                for _, route in ipairs(byDungeon[dungeon]) do
                    entries[#entries + 1] = { route = route }
                end
            end
        end

        -- Blaetterung unter die Ergebnisse, nicht in die Ueberschrift: dort
        -- sucht man sie, wenn man am Ende der Liste angekommen ist.
        if pageCount > 1 then
            entries[#entries + 1] = {
                pager = true,
                key = sectionKey,
                page = page,
                pageCount = pageCount,
                first = first,
                last = last,
                total = #list,
            }
        end
    end

    addSection("favourites", ns.L["SECTION_FAVOURITES"], buckets.favourites)
    if filterMode ~= "mine" then
        addSection("community", ns.L["SECTION_COMMUNITY"], buckets.community)
    end
    if filterMode ~= "community" then
        addSection("mine", ns.L["SECTION_MINE"], buckets.mine)
    end
end

---Erzeugt oder recycelt eine Zeile der Routenliste.
---@param index number
---@return table
local function acquireRow(index)
    local row = ui.rows[index]
    if row then return row end

    row = CreateFrame("Button", nil, ui.content)
    row:SetHeight(ROW_HEIGHT)

    -- Band fuer Abschnittsueberschriften: hebt Favoriten / Community /
    -- Meine Routen von den Dungeongruppen darunter ab.
    row.band = row:CreateTexture(nil, "BACKGROUND", nil, -2)
    row.band:SetAllPoints()
    row.band:SetColorTexture(T:Color("bgOverlay", 1))
    row.band:Hide()

    row.bandAccent = row:CreateTexture(nil, "BACKGROUND", nil, -1)
    row.bandAccent:SetPoint("TOPLEFT")
    row.bandAccent:SetPoint("BOTTOMLEFT")
    row.bandAccent:SetWidth(3)
    row.bandAccent:SetColorTexture(T:Color("accent", 0.9))
    row.bandAccent:Hide()

    row.highlight = row:CreateTexture(nil, "BACKGROUND")
    row.highlight:SetAllPoints()
    row.highlight:SetColorTexture(T:Color("bgHover", 0.9))
    row.highlight:Hide()

    row.selected = row:CreateTexture(nil, "BACKGROUND")
    row.selected:SetAllPoints()
    row.selected:SetColorTexture(T:Color("accent", 0.20))
    row.selected:Hide()

    row:SetScript("OnEnter", function(self)
        if not self.isHeader then self.highlight:Show() end
    end)
    row:SetScript("OnLeave", function(self)
        if not self.isHeader and self.routeId ~= selectedId then self.highlight:Hide() end
    end)

    -- Auswahlkaestchen: nur bei eigenen Routen sichtbar.
    row.check = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
    row.check:SetSize(20, 20)
    row.check:SetPoint("LEFT", row, "LEFT", 4, 0)
    row.check:SetScript("OnClick", function(self)
        local parent = self:GetParent()
        local on = self:GetChecked() and true or nil

        if parent.isHeader then
            -- Kopfzeile: die ganze Dungeon-Gruppe umschalten.
            for _, id in ipairs(parent.groupIds or {}) do checked[id] = on end
        elseif parent.routeId then
            checked[parent.routeId] = on
        end

        B.Refresh()
    end)
    row.check:Hide()

    -- Seitenwechsel. Sitzt in der Abschnittskopfzeile, weil dort auch die
    -- Anzahl steht - eine eigene Leiste waere ein zweiter Ort fuer dieselbe
    -- Information.
    row.pageLabel = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.pageLabel:SetPoint("RIGHT", row, "RIGHT", -64, 0)
    row.pageLabel:SetJustifyH("RIGHT")

    row.prev = T:Button(row, "<", 22)
    row.prev:SetHeight(18)
    row.prev:SetPoint("RIGHT", row, "RIGHT", -34, 0)
    row.prev:SetScript("OnClick", function(self)
        local parent = self:GetParent()
        if not parent.pageKey then return end
        pages[parent.pageKey] = math.max(1, (pages[parent.pageKey] or 1) - 1)
        B.Refresh()
    end)
    row.prev:Hide()

    row.next = T:Button(row, ">", 22)
    row.next:SetHeight(18)
    row.next:SetPoint("RIGHT", row, "RIGHT", -8, 0)
    row.next:SetScript("OnClick", function(self)
        local parent = self:GetParent()
        if not parent.pageKey then return end
        pages[parent.pageKey] = (pages[parent.pageKey] or 1) + 1
        B.Refresh()
    end)
    row.next:Hide()

    -- Favoritenherz. Rein lokal: ein Addon kann nichts nach draussen senden,
    -- also ist das die eigene Merkliste, keine Community-Wertung.
    row.fav = CreateFrame("Button", nil, row)
    row.fav:SetSize(20, 20)
    row.fav:SetPoint("RIGHT", row, "RIGHT", -6, 0)
    row.fav.texture = row.fav:CreateTexture(nil, "ARTWORK")
    row.fav.texture:SetAllPoints()
    row.fav:SetScript("OnClick", function(self)
        local parent = self:GetParent()
        if not parent.routeId then return end
        toggleFavourite(parent.routeId)
        B.Refresh()
    end)
    row.fav:Hide()

    -- Warnsymbol fuer Routen, die keine 100 % erreichen.
    row.warn = row:CreateTexture(nil, "OVERLAY")
    row.warn:SetSize(14, 14)
    row.warn:SetPoint("LEFT", row, "LEFT", 10, 6)
    row.warn:SetAtlas("services-icon-warning")
    row.warn:Hide()

    row.title = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.title:SetPoint("TOPLEFT", row, "TOPLEFT", 12, -4)
    row.title:SetJustifyH("LEFT")

    row.meta = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.meta:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 12, 5)
    row.meta:SetJustifyH("LEFT")

    -- Von rechts nach links aufgebaut, damit die Spalten fest stehen und zur
    -- Ueberschrift passen.
    row.percent = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.percent:SetPoint("RIGHT", row, "RIGHT", -(COL_FAV + 6), 0)
    row.percent:SetJustifyH("RIGHT")
    row.percent:SetWidth(COL_PERCENT)

    row.forces = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.forces:SetPoint("RIGHT", row.percent, "LEFT", -6, 0)
    row.forces:SetJustifyH("RIGHT")
    row.forces:SetWidth(COL_FORCES)

    row.pulls = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.pulls:SetPoint("RIGHT", row.forces, "LEFT", -6, 0)
    row.pulls:SetJustifyH("RIGHT")
    row.pulls:SetWidth(COL_PULLS)

    row.level = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.level:SetPoint("RIGHT", row.pulls, "LEFT", -6, 0)
    row.level:SetJustifyH("RIGHT")
    row.level:SetWidth(COL_LEVEL)

    -- Bleibt als Anker fuer Titel und Meta erhalten.
    row.stats = row.level

    -- Lange Titel duerfen nicht in die Zahlenspalten laufen.
    row.title:SetPoint("RIGHT", row.stats, "LEFT", -10, 0)
    row.title:SetWordWrap(false)
    row.meta:SetPoint("RIGHT", row.stats, "LEFT", -10, 0)
    row.meta:SetWordWrap(false)

    row:SetScript("OnClick", function(self)
        if self.isHeader then
            -- Kopfzeilen klappen ihren Bereich auf und zu.
            if self.groupKey then
                collapsed[self.groupKey] = (not collapsed[self.groupKey]) or nil
                B.Refresh()
            end
            return
        end
        if not self.routeId then return end
        selectedId = self.routeId
        B.Refresh()
    end)
    row:SetScript("OnDoubleClick", function(self)
        if self.isHeader or not self.route then return end
        B.ShowOnMap(self.route)
    end)
    row:RegisterForClicks("LeftButtonUp")

    ui.rows[index] = row
    return row
end

--------------------------------------------------------------------------
-- Detailbereich (MDTs rechte Spalte)
--------------------------------------------------------------------------

---Erzeugt oder recycelt eine Zeile der Pull-Liste.
---@param index number
---@return table
local function acquirePullRow(index)
    local row = ui.detail.pullRows[index]
    if row then return row end

    row = CreateFrame("Frame", nil, ui.detail.content)
    row:SetHeight(PULLROW_HEIGHT)
    row:EnableMouse(true)

    row.highlight = row:CreateTexture(nil, "BACKGROUND")
    row.highlight:SetAllPoints()
    row.highlight:SetColorTexture(T:Color("bgHover", 0.9))
    row.highlight:Hide()

    row:SetScript("OnEnter", function(self)
        if not self.npcId then return end
        self.highlight:Show()
        showEnemyPreview(self, self.challengeModeId, self.npcId, self.amount)
    end)
    row:SetScript("OnLeave", function(self)
        self.highlight:Hide()
        hidePreview()
    end)

    row.index = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.index:SetPoint("TOPLEFT", row, "TOPLEFT", 2, -1)
    row.index:SetWidth(34)
    row.index:SetJustifyH("LEFT")

    -- Prozente zuerst: der Name haengt sich rechts daran und wird dadurch
    -- abgeschnitten statt darueber zu laufen.
    row.percent = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    row.percent:SetPoint("TOPRIGHT", row, "TOPRIGHT", -4, -1)
    row.percent:SetJustifyH("RIGHT")
    row.percent:SetWidth(46)

    -- Mehrzeilig: ein Pull kann etliche verschiedene Gegner enthalten, und
    -- abgeschnitten waere die Liste wertlos.
    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.text:SetPoint("TOPLEFT", row, "TOPLEFT", 38, -1)
    row.text:SetPoint("RIGHT", row.percent, "LEFT", -6, 0)
    row.text:SetJustifyH("LEFT")
    row.text:SetWordWrap(true)

    -- Zaubersymbole gehoeren an das Add, zu dem sie zaehlen - nicht in einen
    -- gemeinsamen Kasten, wo die Zuordnung verlorengeht.
    row.icons = {}
    for i = 1, 8 do
        local icon = CreateFrame("Button", nil, row)
        icon:SetSize(SPELL_ICON, SPELL_ICON)

        icon.interrupt = icon:CreateTexture(nil, "BACKGROUND")
        icon.interrupt:SetPoint("TOPLEFT", -1, 1)
        icon.interrupt:SetPoint("BOTTOMRIGHT", 1, -1)
        icon.interrupt:SetColorTexture(1, 1, 1, 0.95)
        icon.interrupt:Hide()

        icon.texture = icon:CreateTexture(nil, "ARTWORK")
        icon.texture:SetAllPoints()
        icon.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        icon.dispel = icon:CreateTexture(nil, "OVERLAY")
        icon.dispel:SetSize(6, 6)
        icon.dispel:SetPoint("BOTTOMRIGHT", 1, -1)
        icon.dispel:Hide()

        icon:SetScript("OnEnter", function(self)
            if not self.spellId then return end
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
            GameTooltip:SetSpellByID(self.spellId)

            if self.interruptible then
                GameTooltip:AddLine(ns.L["SPELL_INTERRUPTIBLE"], 0.4, 1, 0.4)
            end
            for _, dispel in ipairs(DISPEL_TYPES) do
                if self[dispel.key] then
                    GameTooltip:AddLine(ns.L["SPELL_" .. dispel.label], dispel.r, dispel.g, dispel.b)
                    for _, hint in ipairs(ns.GetDispelHint(dispel.key)) do
                        GameTooltip:AddLine(hint.text, 0.8, 0.8, 0.8, true)
                    end
                end
            end
            GameTooltip:Show()
        end)
        icon:SetScript("OnLeave", function() GameTooltip:Hide() end)

        icon:Hide()
        row.icons[i] = icon
    end

    ui.detail.pullRows[index] = row
    return row
end

---Setzt eine Zeile auf einen Gegner samt seiner Zauber.
---@param row table
---@param challengeModeId number
---@param npcId number
---@param amount number Anzahl im Pull
---@param hideAmount boolean|nil Ohne "3x" davor (Dungeonuebersicht)
---@return number height
local function fillAddRow(row, challengeModeId, npcId, amount, hideAmount)
    local npc = ns.GetNpc(challengeModeId, npcId)
    local name = (npc and npc.name) or ("NPC " .. tostring(npcId))

    row.npcId = npcId
    row.challengeModeId = challengeModeId
    row.amount = amount

    row.index:SetText("")
    local forces = (npc and npc.count or 0) * amount
    row.percent:SetText(forces > 0 and (T:Hex("textMuted") .. "%d|r"):format(forces) or "")
    local colour = (npc and npc.isBoss) and T:Hex("accent") or T:Hex("textPrimary")
    if hideAmount then
        row.text:SetText(("%s%s|r"):format(colour, name))
    else
        row.text:SetText(("%s%dx %s|r"):format(colour, amount, name))
    end

    local height = row.text:GetStringHeight() + 4

    local spells = (npc and npc.spells) or {}
    local shown = 0
    for i, icon in ipairs(row.icons) do
        local spell = spells[i]

        icon.spellId, icon.interruptible = nil, nil
        for _, dispel in ipairs(DISPEL_TYPES) do icon[dispel.key] = nil end

        if type(spell) == "table" and spell.id then
            shown = shown + 1
            icon.spellId = spell.id
            icon.interruptible = spell.interruptible
            icon.texture:SetTexture(C_Spell.GetSpellTexture(spell.id) or 134400)
            icon.interrupt:SetShown(spell.interruptible == true)

            local marked = false
            for _, dispel in ipairs(DISPEL_TYPES) do
                icon[dispel.key] = spell[dispel.key]
                if spell[dispel.key] and not marked then
                    icon.dispel:SetColorTexture(dispel.r, dispel.g, dispel.b, 1)
                    icon.dispel:Show()
                    marked = true
                end
            end
            if not marked then icon.dispel:Hide() end

            icon:ClearAllPoints()
            icon:SetPoint("TOPLEFT", row, "TOPLEFT", 38 + (shown - 1) * (SPELL_ICON + 3), -height)
            icon:Show()
        else
            icon:Hide()
        end
    end

    if shown > 0 then height = height + SPELL_ICON + 4 end
    return height
end

---Fuellt den Detailbereich rechts.
---@param route table|nil
local function updateDetail(route)
    local d = ui.detail

    -- Keine Route gewaehlt, aber ein Dungeon: dann die Dungeonuebersicht.
    if not route and filterDungeon then
        local dungeon = ns.GetDungeon(filterDungeon)
        if dungeon then
            updateDungeonDetail(dungeon)
            return
        end
    end

    if not route then
        d.dungeon:SetText("")
        d.title:SetText("")
        d.author:SetText("")
        d.percent:SetText("")
        d.forces:SetText("")
        d.affixes:SetText("")
        for _, row in ipairs(d.pullRows) do row:Hide() end
        d.content:SetHeight(1)
        d.hint:Show()
        return
    end

    d.hint:Hide()
    d.dungeon:SetText(route.dungeonEnglishName or "")
    d.title:SetText(route.title or route.id)

    local author = route.author and ns.L["BY_AUTHOR"]:format(route.author) or ""
    local source = route.source and (T:Hex("textMuted") .. " · " .. route.source .. "|r") or ""
    d.author:SetText(author .. source)

    -- Beschriftung neben die Zahl (im Dungeonmodus steht sie darunter).
    d.forces:ClearAllPoints()
    d.forces:SetPoint("LEFT", d.percent, "RIGHT", 10, -2)
    d.forces:SetPoint("RIGHT", d.frame, "RIGHT", -PADDING, 0)

    d.percent:SetText(percentText(route))
    if route.enemyForces and route.enemyForcesRequired then
        d.forces:SetText(("%d / %d"):format(route.enemyForces, route.enemyForcesRequired))
    else
        d.forces:SetText("")
    end

    d.affixes:ClearAllPoints()
    d.affixes:SetPoint("TOPLEFT", d.percent, "BOTTOMLEFT", 2, -6)
    d.affixes:SetPoint("RIGHT", d.frame, "RIGHT", -PADDING, 0)

    local affixes = (route.affixes and #route.affixes > 0) and table.concat(route.affixes, ", ") or "-"
    d.affixes:SetText(("%d %s · %s"):format(#route.pulls, ns.L["COL_PULLS"], affixes))

    -- Pull-Liste: Ueberschrift je Pull, darunter die Gegner einzeln mit ihren
    -- Zaubern. Eine Sammelzeile pro Pull war zu gedraengt, und die Zauber
    -- liessen sich keinem Add mehr zuordnen.
    local need = route.enemyForcesRequired
    local y, rowIndex = 0, 0

    local function place(row, height)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", d.content, "TOPLEFT", 0, -y)
        row:SetPoint("TOPRIGHT", d.content, "TOPRIGHT", 0, -y)
        row:SetHeight(height)
        row:Show()
        y = y + height
    end

    for i, pull in ipairs(route.pulls) do
        rowIndex = rowIndex + 1
        local header = acquirePullRow(rowIndex)

        -- Ueberschriften zeigen keine Vorschau und keine Zauber.
        header.npcId = nil
        for _, icon in ipairs(header.icons) do icon:Hide() end

        header.index:SetText((T:Hex("textSecondary") .. "%d|r"):format(i))
        header.text:SetText(("%s%s%s|r"):format(
            pull.boss and T:Hex("accent") or T:Hex("textSecondary"),
            ns.L["PULL"],
            pull.boss and "  !" or ""))

        if pull.cumulative and need and need > 0 then
            header.percent:SetText((T:Hex("textSecondary") .. "%.1f %%|r"):format(pull.cumulative / need * 100))
        else
            header.percent:SetText("")
        end

        place(header, PULLROW_HEIGHT + 3)

        -- Gegner des Pulls zusammenfassen, haeufigste zuerst.
        local counts, order = {}, {}
        for _, entry in ipairs(pull.enemies or {}) do
            local npcId = entry.npc
            if npcId then
                if not counts[npcId] then
                    counts[npcId] = 0
                    order[#order + 1] = npcId
                end
                counts[npcId] = counts[npcId] + #(entry.clones or {})
            end
        end
        table.sort(order, function(x, z) return counts[x] > counts[z] end)

        for _, npcId in ipairs(order) do
            rowIndex = rowIndex + 1
            local row = acquirePullRow(rowIndex)
            place(row, fillAddRow(row, route.challengeModeId, npcId, counts[npcId]))
        end
    end

    for i = rowIndex + 1, #d.pullRows do
        d.pullRows[i]:Hide()
    end
    hidePreview()
    d.content:SetHeight(math.max(y, 1))
end

--------------------------------------------------------------------------
-- Dungeon-Uebersicht
--------------------------------------------------------------------------

---Sekunden als m:ss.
---@param seconds number|nil
---@return string
local function formatTime(seconds)
    if not seconds or seconds <= 0 then return "?" end
    return ("%d:%02d"):format(math.floor(seconds / 60), seconds % 60)
end

---Zaehlt, in wie vielen Routen jeder Gegner vorkommt.
---
---Das ist unsere ehrliche Annaeherung an eine Heatmap: keystone.guru rechnet
---seine aus zehntausenden hochgeladenen Laeufen, an die wir nicht kommen.
---Woran wir kommen, ist der Konsens der ausgelieferten Routen - welche Packs
---praktisch jede Route mitnimmt und welche nur einzelne.
---@param challengeModeId number
---@return table eintraege, number routen
local function dungeonConsensus(challengeModeId)
    local routes, seenPerRoute = 0, {}
    local counts = {}

    for _, route in ipairs(ns.routes) do
        if route.challengeModeId == challengeModeId then
            routes = routes + 1
            wipe(seenPerRoute)
            for _, pull in ipairs(route.pulls or {}) do
                for _, entry in ipairs(pull.enemies or {}) do
                    -- Pro Route nur einmal zaehlen, egal wie oft der Gegner
                    -- in verschiedenen Pulls auftaucht.
                    local key = entry.npc
                    if key and not seenPerRoute[key] then
                        seenPerRoute[key] = true
                        counts[key] = (counts[key] or 0) + 1
                    end
                end
            end
        end
    end

    local list = {}
    for npcId, count in pairs(counts) do
        local npc = ns.GetNpc(challengeModeId, npcId)
        list[#list + 1] = {
            npc = npcId,
            name = (npc and npc.name) or ("NPC " .. npcId),
            count = count,
            forces = npc and npc.count or 0,
            isBoss = npc and npc.isBoss,
        }
    end

    table.sort(list, function(a, b)
        if a.count ~= b.count then return a.count > b.count end
        return (a.forces or 0) > (b.forces or 0)
    end)

    return list, routes
end

---Fuellt die rechte Spalte mit Informationen zum gewaehlten Dungeon.
---@param dungeon table
function updateDungeonDetail(dungeon)
    local d = ui.detail
    local cmId = dungeon.challengeModeId

    d.hint:Hide()
    for _, row in ipairs(d.pullRows) do row:Hide() end

    local name, _, timeLimit = C_ChallengeMode.GetMapUIInfo(cmId)
    d.dungeon:SetText(ns.L["DETAIL_DUNGEON"])
    d.title:SetText(name or dungeon.englishName or "?")
    d.author:SetText(("%s %s · %d %s"):format(
        ns.L["DETAIL_TIMER"], formatTime(timeLimit), dungeon.totalCount or 0, ns.L["DETAIL_FORCES"]))

    -- Bestleistung der laufenden Season, falls vorhanden.
    local best = ""
    if C_MythicPlus and C_MythicPlus.GetSeasonBestForMap then
        local intime, overtime = C_MythicPlus.GetSeasonBestForMap(cmId)
        local run = intime or overtime
        if type(run) == "table" and run.level then
            best = ("+%d  %s%s|r"):format(
                run.level,
                intime and T:Hex("success") or T:Hex("warning"),
                run.durationSec and (" " .. formatTime(math.floor(run.durationSec))) or "")
        end
    end
    d.percent:SetText(best ~= "" and best or T:Text("textMuted", "–"))

    -- Unter die Zahl: "deine Saison-Bestleistung" ist zu lang, um daneben zu
    -- passen, und lief bisher aus dem Panel heraus.
    d.forces:ClearAllPoints()
    d.forces:SetPoint("TOPLEFT", d.percent, "BOTTOMLEFT", 2, -2)
    d.forces:SetPoint("RIGHT", d.frame, "RIGHT", -PADDING, 0)
    d.forces:SetText(best ~= "" and ns.L["DETAIL_BEST"] or ns.L["DETAIL_NO_RUN"])

    local list, routeCount = dungeonConsensus(cmId)

    d.affixes:ClearAllPoints()
    d.affixes:SetPoint("TOPLEFT", d.forces, "BOTTOMLEFT", -2, -10)
    d.affixes:SetPoint("RIGHT", d.frame, "RIGHT", -PADDING, 0)
    d.affixes:SetText(ns.L["DETAIL_CONSENSUS"]:format(routeCount))

    local y = 0
    for i, entry in ipairs(list) do
        local row = acquirePullRow(i)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", d.content, "TOPLEFT", 0, -y)
        row:SetPoint("TOPRIGHT", d.content, "TOPRIGHT", 0, -y)

        -- Dieselbe Darstellung wie in der Routenansicht: Zauber am Gegner und
        -- Modellvorschau beim Ueberfahren. Nur die linke Spalte ist anders.
        local height = fillAddRow(row, cmId, entry.npc, 1, true)

        -- Anteil der Routen, die diesen Gegner mitnehmen.
        local share = routeCount > 0 and (entry.count / routeCount * 100) or 0
        local colour = share >= 99 and T:Hex("success") or share >= 50 and T:Hex("warning") or T:Hex("textMuted")
        row.index:SetText(("%s%d/%d|r"):format(colour, entry.count, routeCount))

        row:SetHeight(height)
        row:Show()
        y = y + height
    end

    for i = #list + 1, #d.pullRows do d.pullRows[i]:Hide() end
    d.content:SetHeight(math.max(y, 1))
end

--------------------------------------------------------------------------
-- Dungeon-Leiste
--------------------------------------------------------------------------

---Baut die Icon-Leiste oben neu - nur Dungeons, zu denen es Routen gibt.
local function refreshDungeonBar()
    local bar = ui.dungeonBar
    local x = 0

    -- "Alle" bleibt immer der erste Knopf.
    bar.allButton:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
    bar.allButton.selected:SetShown(filterDungeon == nil)
    x = x + DUNGEON_BUTTON + 2

    for i, dungeon in ipairs(ns.dungeons) do
        local button = bar.buttons[i]
        if not button then
            button = CreateFrame("Button", nil, bar)
            button:SetSize(DUNGEON_BUTTON, DUNGEON_BUTTON)

            button.icon = button:CreateTexture(nil, "ARTWORK")
            button.icon:SetPoint("TOPLEFT", 2, -2)
            button.icon:SetPoint("BOTTOMRIGHT", -2, 2)
            button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

            button.selected = button:CreateTexture(nil, "OVERLAY")
            button.selected:SetAllPoints()
            button.selected:SetAtlas("bags-glow-artifact")
            button.selected:Hide()

            button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

            button.label = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            button.label:SetPoint("BOTTOM", button, "BOTTOM", 0, 1)
            button.label:SetFont(button.label:GetFont(), 9, "OUTLINE")

            button:SetScript("OnClick", function(self)
                filterDungeon = (filterDungeon == self.challengeModeId) and nil or self.challengeModeId
                -- Auswahl loesen, damit die Dungeonuebersicht sichtbar wird.
                selectedId = nil
                wipe(pages)
                B.Refresh()
            end)
            button:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
                GameTooltip:AddLine(self.dungeonName, 1, 1, 1)
                GameTooltip:Show()
            end)
            button:SetScript("OnLeave", function() GameTooltip:Hide() end)

            bar.buttons[i] = button
        end

        button.challengeModeId = dungeon.challengeModeId
        button.dungeonName = dungeon.englishName

        -- Icon und Name kommen aus dem Spiel selbst, nicht aus unseren Daten.
        local name, _, _, texture = C_ChallengeMode.GetMapUIInfo(dungeon.challengeModeId)
        button.icon:SetTexture(texture or 134400)
        if name then button.dungeonName = name end
        button.label:SetText(dungeon.shortName or "")
        button.selected:SetShown(filterDungeon == dungeon.challengeModeId)

        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", bar, "TOPLEFT", x, 0)
        button:Show()
        x = x + DUNGEON_BUTTON + 2
    end

    for i = #ns.dungeons + 1, #bar.buttons do
        bar.buttons[i]:Hide()
    end
end

--------------------------------------------------------------------------
-- Zeichnen
--------------------------------------------------------------------------

---Zeichnet Liste, Leiste und Details neu.
function B.Refresh()
    if not ui then return end

    for _, tab in ipairs(ui.tabs) do
        tab:SetActive(tab.mode == filterMode)
    end

    refreshDungeonBar()
    rebuildEntries()

    local y = 0
    for i, entry in ipairs(entries) do
        local row = acquireRow(i)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", ui.content, "TOPLEFT", 0, -y)
        row:SetPoint("TOPRIGHT", ui.content, "TOPRIGHT", 0, -y)

        if entry.pager then
            row.isHeader = true
            row.routeId, row.route, row.groupKey = nil, nil, nil
            row:SetHeight(PAGER_HEIGHT)
            row:EnableMouse(false)

            row.band:Hide()
            row.bandAccent:Hide()
            row.check:Hide()
            row.warn:Hide()
            row.fav:Hide()
            row.highlight:Hide()
            row.selected:Hide()
            row.title:SetText("")
            row.meta:SetText("")
            row.level:SetText("")
            row.pulls:SetText("")
            row.forces:SetText("")
            row.percent:SetText("")

            row.pageKey = entry.key

            row.pageLabel:ClearAllPoints()
            row.pageLabel:SetPoint("CENTER", row, "CENTER", 0, 0)
            row.pageLabel:SetText(("%s   %s"):format(
                ns.L["PAGE"]:format(entry.page, entry.pageCount),
                ns.L["PAGE_RANGE"]:format(entry.first, entry.last, entry.total)))

            row.prev:ClearAllPoints()
            row.prev:SetPoint("RIGHT", row.pageLabel, "LEFT", -10, 0)
            row.next:ClearAllPoints()
            row.next:SetPoint("LEFT", row.pageLabel, "RIGHT", 10, 0)

            row.pageLabel:Show()
            row.prev:Show()
            row.next:Show()
            row.prev:SetEnabled(entry.page > 1)
            row.next:SetEnabled(entry.page < entry.pageCount)

            row:Show()
            y = y + PAGER_HEIGHT
        elseif entry.header or entry.section then
            row.isHeader = true
            row.routeId  = nil
            row.route    = nil
            row.groupKey = entry.key
            row:SetHeight(entry.section and (HEADER_HEIGHT + 6) or HEADER_HEIGHT)
            row:EnableMouse(true)
            row.warn:Hide()
            row.fav:Hide()

            row.band:SetShown(entry.section == true)
            row.bandAccent:SetShown(entry.section == true)

            row.pageLabel:Hide()
            row.prev:Hide()
            row.next:Hide()

            local arrow = T:Text("accent", entry.collapsed and "+" or "-")

            -- Alles-auswaehlen gehoert zur Dungeon-Gruppe, nicht zum Bereich.
            local groupIds = (not entry.section) and entry.ids or nil
            local deletableIds = {}
            for _, id in ipairs(groupIds or {}) do
                local candidate = displayById[id]
                local _, presetIdx = savedPreset(candidate or {})
                if presetIdx and presetIdx > 1 then deletableIds[#deletableIds + 1] = id end
            end

            local showCheck = filterMode ~= "community" and #deletableIds > 0
            row.check:SetShown(showCheck)
            row.groupIds = deletableIds
            if showCheck then
                local all = true
                for _, id in ipairs(deletableIds) do
                    if not checked[id] then
                        all = false
                        break
                    end
                end
                row.check:SetChecked(all)
            end

            row.title:SetPoint("TOPLEFT", row, "TOPLEFT",
                showCheck and 28 or (entry.section and 12 or 16), -5)
            if entry.section then
                row.title:SetText(("%s %s%s|r  %s(%d)|r"):format(
                    arrow, T:Hex("accent"), entry.text, T:Hex("textMuted"), entry.count))
            else
                row.title:SetText(("  %s %s%s|r  %s(%d)|r"):format(
                    arrow, T:Hex("textSecondary"), entry.text, T:Hex("textMuted"), entry.count))
            end
            row.meta:SetText("")
            row.level:SetText("")
            row.pulls:SetText("")
            row.forces:SetText("")
            row.percent:SetText("")
            row.highlight:Hide()
            row.selected:Hide()
            y = y + (entry.section and (HEADER_HEIGHT + 6) or HEADER_HEIGHT)
        else
            local route = entry.route
            local percent = forcesPercent(route)
            local incomplete = percent ~= nil and percent < 100

            row.isHeader = false
            row.route    = route
            row.routeId  = route.id
            row:SetHeight(ROW_HEIGHT)
            row:EnableMouse(true)

            -- MDTs "Default" auf Index 1 laesst sich nicht loeschen, also gibt
            -- es dafuer auch kein Kaestchen.
            local _, presetIdx = savedPreset(route)
            local deletable = presetIdx ~= nil and presetIdx > 1
            row.check:SetShown(deletable)
            if deletable then
                row.check:SetChecked(checked[route.id] and true or false)
            end

            local indent = deletable and 28 or 20
            row.band:Hide()
            row.bandAccent:Hide()
            row.pageLabel:Hide()
            row.prev:Hide()
            row.next:Hide()
            row.warn:SetShown(incomplete)
            row.warn:SetPoint("LEFT", row, "LEFT", indent - 2, 6)
            row.title:SetPoint("TOPLEFT", row, "TOPLEFT", indent + (incomplete and 16 or 0), -4)
            row.title:SetText(route.title or route.id)

            local meta
            if route.own or route.saved then
                meta = T:Hex("success") .. ns.L["ROUTE_OWN"] .. "|r"
                local by = route.own and route.author or route.author
                if by then
                    meta = meta .. T:Hex("textMuted") .. " · " .. ns.L["BY_AUTHOR"]:format(by) .. "|r"
                end
                if route.saved and route.source then
                    meta = meta .. T:Hex("textMuted") .. " · " .. route.source .. "|r"
                end
            else
                local author = route.author and ns.L["BY_AUTHOR"]:format(route.author) or ""
                local src = route.source and (T:Hex("textMuted") .. " · " .. route.source .. "|r") or ""
                meta = author .. src
            end
            row.meta:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", indent, 5)
            row.meta:SetText(meta)

            row.level:SetText(levelText(route))
            row.pulls:SetText(("%d"):format(#route.pulls))
            row.forces:SetText(("%d/%d"):format(
                route.enemyForces or 0, route.enemyForcesRequired or 0))

            local fav = isFavourite(route.id)
            row.fav:Show()
            row.fav.texture:SetTexture("Interface\\Common\\friendship-heart")
            -- Nicht markiert war fast unsichtbar. Gedaempftes Grau statt
            -- verblasstem Rot: als Schaltflaeche erkennbar, ohne den
            -- markierten die Aufmerksamkeit zu nehmen.
            if fav then
                row.fav.texture:SetVertexColor(1, 0.25, 0.35, 1)
            else
                row.fav.texture:SetVertexColor(0.65, 0.65, 0.65, 0.55)
            end
            row.percent:SetText(percentText(route))

            local isSelected = route.id == selectedId
            row.selected:SetShown(isSelected)
            row.highlight:SetShown(isSelected)
            y = y + ROW_HEIGHT
        end

        row:Show()
    end

    for i = #entries + 1, #ui.rows do
        ui.rows[i]:Hide()
    end

    ui.content:SetHeight(math.max(y, 1))

    if #entries == 0 then
        ui.empty:SetText(#ns.routes == 0 and ns.L["LIST_EMPTY"] or ns.L["BROWSER_NO_MATCH"])
        ui.empty:Show()
    else
        ui.empty:Hide()
    end

    local active = activeFilterCount()
    ui.filterButton:SetText(active > 0
        and ("%s (%d)"):format(ns.L["FILTER"], active)
        or ns.L["FILTER"])

    local route = selectedId and displayById[selectedId]
    updateDetail(route)
    ui.mapButton:SetEnabled(route ~= nil)
    ui.copyButton:SetEnabled(route ~= nil and not route.own and not (route and route.saved))

    -- Loeschen gibt es nur, wo eigene Routen stehen koennen.
    local n = countChecked()


    ui.deleteButton:SetShown(filterMode ~= "community")
    ui.deleteButton:SetEnabled(n > 0)
    ui.deleteButton:SetText(n > 0 and ns.L["DELETE_N"]:format(n) or ns.L["DELETE"])

    -- Rueckgaengig taucht nur auf, wenn es etwas zurueckzuholen gibt.
    ui.undoButton:SetShown(#trash > 0)
    ui.undoButton:SetText(ns.L["UNDO_N"]:format(#trash))
end

--------------------------------------------------------------------------
-- Aufbau
--------------------------------------------------------------------------

---Deckender Wurzel-Frame ueber einem von MDT gestellten Sektions-Frame.
---MDT blendet seine Kartenelemente zwar aus, der Frame liegt aber tief und ist
---durchsichtig - ohne das hier scheint die Karte durch.
---@param parent table
---@return table
local function makeRoot(parent)
    local root = CreateFrame("Frame", nil, parent)
    root:SetAllPoints(parent)
    root:SetFrameLevel(parent:GetFrameLevel() + 60)

    T:Fill(root, "bgBase", 0.96)

    return root
end

---Hebt MDTs Fensterknoepfe ueber unsere Sektion.
---
---Unsere Flaechen liegen bewusst hoch, damit die Karte nicht durchscheint.
---Damit verdecken sie aber auch das Schliessen- und das Vollbildsymbol oben
---rechts. Die sind global benannt, also heben wir sie einfach darueber.
---@param level number
local function liftMDTControls(level)
    for _, name in ipairs({ "MDTCloseButton", "MDTMaximizeButton", "MDTLiveReturnButton" }) do
        local button = _G[name]
        if button and button.SetFrameLevel then
            button:SetFrameLevel(level)
        end
    end
end

---Baut die Detailspalte in MDTs rechter Spalte.
---@param parent table
local function buildDetail(parent)
    local root = makeRoot(parent)
    local d = { pullRows = {} }

    d.frame = root

    d.dungeon = root:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    d.dungeon:SetPoint("TOPLEFT", root, "TOPLEFT", PADDING, -PADDING)
    d.dungeon:SetPoint("RIGHT", root, "RIGHT", -PADDING, 0)
    d.dungeon:SetJustifyH("LEFT")
    d.dungeon:SetTextColor(T:Color("accent"))

    d.title = root:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    d.title:SetPoint("TOPLEFT", d.dungeon, "BOTTOMLEFT", 0, -3)
    d.title:SetPoint("RIGHT", root, "RIGHT", -PADDING, 0)
    d.title:SetJustifyH("LEFT")
    d.title:SetWordWrap(true)

    d.author = root:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    d.author:SetPoint("TOPLEFT", d.title, "BOTTOMLEFT", 0, -5)
    d.author:SetPoint("RIGHT", root, "RIGHT", -PADDING, 0)
    d.author:SetJustifyH("LEFT")
    d.author:SetWordWrap(true)

    -- Der Prozentwert ist die Kernaussage und bekommt den meisten Platz.
    d.percent = root:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    d.percent:SetPoint("TOPLEFT", d.author, "BOTTOMLEFT", 0, -14)

    d.forces = root:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    d.forces:SetPoint("LEFT", d.percent, "RIGHT", 10, -2)
    d.forces:SetPoint("RIGHT", root, "RIGHT", -PADDING, 0)
    d.forces:SetJustifyH("LEFT")
    d.forces:SetWordWrap(false)

    d.affixes = root:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    d.affixes:SetPoint("TOPLEFT", d.percent, "BOTTOMLEFT", 2, -6)
    d.affixes:SetPoint("RIGHT", root, "RIGHT", -PADDING, 0)
    d.affixes:SetJustifyH("LEFT")

    local divider = T:Divider(root)
    divider:SetPoint("TOPLEFT", d.affixes, "BOTTOMLEFT", -2, -10)
    divider:SetPoint("RIGHT", root, "RIGHT", -PADDING, 0)

    local scroll = CreateFrame("ScrollFrame", nil, root, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", divider, "BOTTOMLEFT", 0, -8)
    scroll:SetPoint("BOTTOMRIGHT", root, "BOTTOMRIGHT", -(PADDING + 22), PADDING)
    d.scroll = scroll

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(1, 1)
    scroll:SetScrollChild(content)
    d.content = content

    scroll:SetScript("OnSizeChanged", function(self, width) content:SetWidth(width) end)
    content:SetWidth(scroll:GetWidth())

    d.hint = root:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    d.hint:SetPoint("TOPLEFT", root, "TOPLEFT", PADDING, -80)
    d.hint:SetPoint("TOPRIGHT", root, "TOPRIGHT", -PADDING, -80)
    d.hint:SetJustifyH("CENTER")
    d.hint:SetText(ns.L["DETAIL_HINT"])

    ui.detail = d
end

---Baut die Routenliste in MDTs Kartenbereich.
---@param parent table
local function buildList(parent)
    local root = makeRoot(parent)
    ui.frame = root

    -- Einmal pro Sekunde nachsehen, ob MDT etwas an seinen Presets geaendert
    -- hat - etwa durch einen Import. Haeufiger waere Verschwendung, seltener
    -- fuehle es sich nicht mehr nach "sofort" an.
    root.sinceSync = 0
    root:SetScript("OnUpdate", function(self, elapsed)
        self.sinceSync = self.sinceSync + elapsed
        if self.sinceSync < 1 then return end
        self.sinceSync = 0
        if syncWithMDT() then B.Refresh() end
    end)

    ui.title = root:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    ui.title:SetPoint("TOPLEFT", root, "TOPLEFT", PADDING, -PADDING)
    ui.title:SetText("MDT Route Library")
    ui.title:SetTextColor(T:Color("textPrimary"))

    ui.subtitle = root:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    ui.subtitle:SetPoint("LEFT", ui.title, "RIGHT", 12, -1)

    local search = CreateFrame("EditBox", nil, root, "SearchBoxTemplate")
    search:SetSize(200, 22)
    search:SetPoint("TOPRIGHT", root, "TOPRIGHT", -PADDING, -PADDING)
    search:SetAutoFocus(false)
    search:SetScript("OnTextChanged", function(self, userInput)
        -- Ohne diesen Aufruf blendet die SearchBoxTemplate ihren Platzhalter
        -- nicht aus und "Suchen" liegt ueber dem eingegebenen Text.
        SearchBoxTemplate_OnTextChanged(self)
        filterText = self:GetText() or ""
        -- Nach einer neuen Suche wieder auf Seite eins.
        wipe(pages)
        B.Refresh()
    end)
    search:SetScript("OnEscapePressed", function(self)
        self:SetText("")
        self:ClearFocus()
    end)
    ui.search = search

    -- Umschalter: Community-Routen aus dem Datenpaket, eigene aus MDT, oder beides.
    ui.tabs = {}
    local modes = {
        { key = "all",       label = ns.L["TAB_ALL"] },
        { key = "community", label = ns.L["TAB_COMMUNITY"] },
        { key = "mine",      label = ns.L["TAB_MINE"] },
    }

    local previous
    for _, mode in ipairs(modes) do
        local tab = T:Tab(root, mode.label, 110)
        tab:SetHeight(22)
        if previous then
            tab:SetPoint("LEFT", previous, "RIGHT", 4, 0)
        else
            tab:SetPoint("TOPLEFT", ui.title, "BOTTOMLEFT", 0, -6)
        end
        tab.mode = mode.key
        tab:SetScript("OnClick", function(self)
            filterMode = self.mode
            selectedId = nil
            wipe(checked)
            wipe(pages)
            B.Refresh()
        end)
        ui.tabs[#ui.tabs + 1] = tab
        previous = tab
    end

    -- Ein Knopf statt vieler Schalter: die Leiste lief sonst aus dem Fenster,
    -- und mehr Kriterien haetten dort ohnehin keinen Platz.
    local filterButton = T:Button(root, ns.L["FILTER"], 110)
    filterButton:SetHeight(22)
    filterButton:SetPoint("RIGHT", search, "LEFT", -8, 0)
    ui.filterButton = filterButton

    local panel = T:Panel(root, "bgOverlay")
    panel:SetSize(250, 252)
    panel:SetPoint("TOPRIGHT", filterButton, "BOTTOMRIGHT", 0, -4)
    panel:SetFrameLevel(root:GetFrameLevel() + 20)
    panel:EnableMouse(true)
    panel:Hide()
    ui.filterPanel = panel

    ---Regler mit Beschriftung und Wertanzeige.
    ---@param label string
    ---@param anchor table
    ---@param maxValue number
    ---@param get function
    ---@param set function
    ---@param anyText string Text fuer den Wert 0
    local function makeSlider(label, anchor, maxValue, get, set, anyText)
        local caption = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        -- Senkrecht unter dem REGLER des vorigen Blocks (nicht unter dessen
        -- Beschriftung, sonst stapeln sie sich ineinander), waagerecht fest
        -- am linken Panelrand.
        caption:SetPoint("TOP", anchor, "BOTTOM", 0, -16)
        caption:SetPoint("LEFT", panel, "LEFT", 14, 0)
        caption:SetJustifyH("LEFT")
        caption:SetText(label)

        local slider = CreateFrame("Slider", nil, panel, "MinimalSliderTemplate")
        slider:SetPoint("TOPLEFT", caption, "BOTTOMLEFT", 2, -6)
        slider:SetSize(150, 16)
        slider:SetMinMaxValues(0, maxValue)
        slider:SetValueStep(1)
        slider:SetObeyStepOnDrag(true)

        slider.value = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        slider.value:SetPoint("LEFT", slider, "RIGHT", 10, 0)

        local function render(v)
            slider.value:SetText(v == 0 and anyText or tostring(v))
        end

        slider:SetScript("OnValueChanged", function(self, raw)
            local v = math.floor(raw + 0.5)
            if v == get() then return end
            set(v)
            render(v)
            -- Nach einer Filteraenderung wieder auf Seite eins.
            wipe(pages)
            B.Refresh()
        end)

        slider:SetValue(get())
        render(get())
        slider.caption = caption
        return slider
    end

    -- Keine Breite setzen: UICheckButtonTemplate zieht seine Textur mit und
    -- wuerde zu einer breiten Ellipse. Die Beschriftung steht daneben.
    local favBox = T:Checkbox(panel, ns.L["FILTER_FAVOURITES"])
    favBox:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -14)
    favBox:SetScript("OnClick", function(self)
        filters.favourites = self:GetChecked() and true or false
        wipe(pages)
        B.Refresh()
    end)
    panel.favBox = favBox

    panel.levelSlider = makeSlider(ns.L["FILTER_LEVEL_LABEL"], favBox, 30,
        function() return filters.minLevel end,
        function(v) filters.minLevel = v end,
        ns.L["FILTER_ANY"])

    panel.percentSlider = makeSlider(ns.L["FILTER_PERCENT_LABEL"], panel.levelSlider, 120,
        function() return filters.minPercent end,
        function(v) filters.minPercent = v end,
        ns.L["FILTER_ANY"])

    panel.pullsSlider = makeSlider(ns.L["FILTER_PULLS_LABEL"], panel.percentSlider, 60,
        function() return filters.maxPulls end,
        function(v) filters.maxPulls = v end,
        ns.L["FILTER_ANY"])

    local reset = T:Button(panel, ns.L["FILTER_RESET"], 120)
    reset:SetHeight(22)
    reset:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -14, 12)
    reset:SetScript("OnClick", function()
        filters.favourites = false
        filters.minPercent = 0
        filters.minLevel = 0
        filters.maxPulls = 0

        panel.favBox:SetChecked(false)
        panel.levelSlider:SetValue(0)
        panel.percentSlider:SetValue(0)
        panel.pullsSlider:SetValue(0)
        B.Refresh()
    end)

    filterButton:SetScript("OnClick", function()
        panel:SetShown(not panel:IsShown())
    end)

    -- Dungeonleiste, aufgebaut wie MDTs eigene Auswahl: Icon plus Kurzname.
    local bar = CreateFrame("Frame", nil, root)
    bar:SetPoint("TOPLEFT", root, "TOPLEFT", PADDING, -(PADDING + 52))
    bar:SetPoint("RIGHT", root, "RIGHT", -PADDING, 0)
    bar:SetHeight(DUNGEON_BUTTON)
    bar.buttons = {}

    local allButton = CreateFrame("Button", nil, bar)
    allButton:SetSize(DUNGEON_BUTTON, DUNGEON_BUTTON)
    allButton.selected = allButton:CreateTexture(nil, "OVERLAY")
    allButton.selected:SetAllPoints()
    allButton.selected:SetAtlas("bags-glow-artifact")
    allButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
    allButton.label = allButton:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    allButton.label:SetPoint("CENTER")
    allButton.label:SetText(ns.L["BROWSER_ALL"])
    allButton:SetScript("OnClick", function()
        filterDungeon = nil
        B.Refresh()
    end)
    bar.allButton = allButton
    ui.dungeonBar = bar

    -- Spaltenueberschrift. Liegt ausserhalb des Scrollbereichs, damit sie beim
    -- Blaettern stehen bleibt.
    local head = CreateFrame("Frame", nil, root)
    head:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, -6)
    head:SetPoint("RIGHT", root, "RIGHT", -(PADDING + 22), 0)
    head:SetHeight(16)

    -- Erklaerung beim Ueberfahren. "Kraefte" versteht sonst niemand, der
    -- nicht schon weiss, was gemeint ist.
    local function headTooltip(frame, title, body)
        frame:EnableMouse(true)
        frame:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
            GameTooltip:AddLine(title, 1, 1, 1)
            GameTooltip:AddLine(body, 0.8, 0.8, 0.8, true)
            GameTooltip:Show()
        end)
        frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end

    local function headLabel(text, width, anchor, tipTitle, tipBody)
        -- FontStrings nehmen keine Maus an, also ein Rahmen darueber.
        local box = CreateFrame("Frame", nil, head)
        box:SetSize(width, 16)
        if anchor then
            box:SetPoint("RIGHT", anchor, "LEFT", -6, 0)
        else
            box:SetPoint("RIGHT", head, "RIGHT", -(COL_FAV + 6), 0)
        end

        box.text = box:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        box.text:SetAllPoints()
        box.text:SetJustifyH("RIGHT")
        box.text:SetText(text)

        headTooltip(box, tipTitle, tipBody)
        return box
    end

    local hPercent = headLabel(ns.L["COL_PERCENT"], COL_PERCENT, nil,
        ns.L["COL_PERCENT_TIP_TITLE"], ns.L["COL_PERCENT_TIP"])
    local hForces = headLabel(ns.L["COL_FORCES"], COL_FORCES, hPercent,
        ns.L["COL_FORCES_TIP_TITLE"], ns.L["COL_FORCES_TIP"])
    local hPulls = headLabel(ns.L["COL_PULLS"], COL_PULLS, hForces,
        ns.L["COL_PULLS_TIP_TITLE"], ns.L["COL_PULLS_TIP"])
    headLabel(ns.L["COL_LEVEL"], COL_LEVEL, hPulls,
        ns.L["COL_LEVEL_TIP_TITLE"], ns.L["COL_LEVEL_TIP"])

    local routeBox = CreateFrame("Frame", nil, head)
    routeBox:SetPoint("LEFT", head, "LEFT", 12, 0)
    routeBox:SetSize(140, 16)
    routeBox.text = routeBox:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    routeBox.text:SetAllPoints()
    routeBox.text:SetJustifyH("LEFT")
    routeBox.text:SetText(ns.L["COL_ROUTE"])
    headTooltip(routeBox, ns.L["COL_ROUTE_TIP_TITLE"], ns.L["COL_ROUTE_TIP"])

    local line = T:Divider(head)
    line:SetPoint("BOTTOMLEFT", head, "BOTTOMLEFT", 0, -2)
    line:SetPoint("BOTTOMRIGHT", head, "BOTTOMRIGHT", 0, -2)

    ui.head = head

    local scroll = CreateFrame("ScrollFrame", nil, root, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", head, "BOTTOMLEFT", 0, -6)
    scroll:SetPoint("BOTTOMRIGHT", root, "BOTTOMRIGHT", -(PADDING + 22), PADDING + 34)
    ui.scroll = scroll

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(1, 1)
    scroll:SetScrollChild(content)
    ui.content = content

    scroll:SetScript("OnSizeChanged", function(self, width) content:SetWidth(width) end)
    content:SetWidth(scroll:GetWidth())

    ui.empty = root:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    ui.empty:SetPoint("CENTER", scroll, "CENTER", 0, 0)
    ui.empty:Hide()

    local mapButton = T:Button(root, ns.L["BROWSER_SHOW_ON_MAP"], 150)
    mapButton.primary = true
    mapButton:Apply()
    mapButton:SetPoint("BOTTOMLEFT", root, "BOTTOMLEFT", PADDING, 8)
    mapButton:SetScript("OnClick", function()
        local route = selectedId and displayById[selectedId]
        if route then B.ShowOnMap(route) end
    end)
    ui.mapButton = mapButton

    -- Dauerhaft uebernehmen. Danach ist es ein ganz normales Preset des
    -- Nutzers, das wir nie wieder anfassen - loeschbar unter "Meine Routen".
    -- Mit gedrueckter Umschalttaste stattdessen den Importstring kopieren,
    -- fuer alle, die ihn ausserhalb des Spiels weitergeben wollen.
    local copyButton = T:Button(root, ns.L["BROWSER_SAVE"], 150)
    copyButton:SetPoint("LEFT", mapButton, "RIGHT", 8, 0)
    copyButton:SetScript("OnClick", function()
        local route = selectedId and displayById[selectedId]
        if not route then return end

        if IsShiftKeyDown() then
            B.CopyString(route)
            return
        end

        local idx, slot, err = ns.MDT.PutPreset(route, true)
        if not idx then
            ns.Warn(err or "unbekannter Fehler")
            return
        end
        ns.Print(ns.L["SAVED_TO_MDT"], route.title or route.id)
        B.Refresh()
    end)
    copyButton.tooltipText = ns.L["BROWSER_SAVE_TIP"]
    ui.copyButton = copyButton

    local deleteButton = T:Button(root, ns.L["DELETE"], 150)
    deleteButton:SetPoint("LEFT", copyButton, "RIGHT", 8, 0)
    deleteButton:SetScript("OnClick", function()
        local n = countChecked()
        if n == 0 then return end
        StaticPopup_Show("MDTRL_DELETE", n)
    end)
    ui.deleteButton = deleteButton

    local undoButton = T:Button(root, ns.L["UNDO"], 130)
    undoButton:SetPoint("LEFT", deleteButton, "RIGHT", 8, 0)
    undoButton:SetScript("OnClick", function()
        local restored = restoreDeleted()
        if restored > 0 then
            ns.Print(ns.L["UNDO_DONE"], restored)
        end
        B.Refresh()
    end)
    ui.undoButton = undoButton

    local submitButton = T:Button(root, ns.L["BROWSER_SUBMIT"], 160)
    submitButton:SetPoint("BOTTOMRIGHT", root, "BOTTOMRIGHT", -PADDING, 8)
    submitButton:SetScript("OnClick", function()
        local route = selectedId and displayById[selectedId]

        -- Community-Routen sind bereits veroeffentlicht; einreichen ergibt nur
        -- fuer eigene Sinn.
        if route and not route.own then
            ns.Warn(ns.L["SUBMIT_ONLY_OWN"])
            return
        end

        local preset, dungeonIdx
        if route then
            preset, dungeonIdx = ns.Submit.GetPresetForRoute(route)
            if not preset then
                ns.Warn(ns.L["SUBMIT_STALE"])
                B.Refresh()
                return
            end
        end

        local blob, err = ns.Submit.BuildBlob(preset, dungeonIdx)
        if not blob then
            ns.Warn(err or "unbekannter Fehler")
            return
        end
        ns.UI.ShowCopyDialog(ns.L["SUBMIT_TITLE"], ns.L["SUBMIT_HELP"], blob, ns.SUBMIT_URL)
    end)
    ui.submitButton = submitButton
end

---Aktualisiert die Zeile mit dem Datenstand.
local function updateSubtitle()
    if not ui then return end

    local manifest = ns.manifest
    if not manifest then
        ui.subtitle:SetText("")
        return
    end

    local days = manifest.build and ns.DaysSince(manifest.build)
    local age  = (days and days >= 1) and (" " .. T:Hex("warning") .. "(%d Tage alt)|r"):format(days) or ""
    ui.subtitle:SetText(("%d Routen · %d Dungeons · Stand %s%s"):format(
        manifest.routeCount or #ns.routes,
        manifest.dungeonCount or 0,
        manifest.build or "?",
        age
    ))
end

--------------------------------------------------------------------------
-- Einklinken
--------------------------------------------------------------------------

---Oeffnet MDT und wechselt auf unsere Sektion.
---
---ShowInterface schaltet um: ist MDT offen, wuerde der Aufruf es schliessen.
---Deshalb erst pruefen. Beim ersten Mal laedt MDT seine Oberflaeche nach und
---baut das Fenster asynchron auf - darum der kurze Wiederholversuch.
function B.Open()
    local frame = _G.MDTFrame
    if frame and frame:IsShown() then
        if pluginAPI then pluginAPI:SetCurrentSection(SECTION_KEY) end
        return true
    end

    local api = _G.MythicDungeonToolsAPI
    if not api or type(api.ShowInterface) ~= "function" then
        ns.Warn(ns.L["NO_MDT"])
        return false
    end

    api:ShowInterface()

    local tries = 0
    local function switch()
        tries = tries + 1
        if pluginAPI and _G.MDTFrame and _G.MDTFrame:IsShown() then
            pluginAPI:SetCurrentSection(SECTION_KEY)
            return
        end
        if tries < 20 then C_Timer.After(0.1, switch) end
    end
    C_Timer.After(0.1, switch)

    return true
end

---Meldet die Sektion bei MDT an. Muss laufen, bevor MDT sein Hauptfenster
---baut - der RegisterUIInitializer-Callback ist genau dieser Zeitpunkt.
---@param api table MDTs pluginAPI
function B.Register(api)
    pluginAPI = api
    if not api or type(api.RegisterNavigationSection) ~= "function" then return false end

    api:RegisterNavigationSection({
        key       = SECTION_KEY,
        tooltip   = "MDT Route Library",
        texture   = ICON,
        texCoords = ICON_COORDS,
        -- Beide Frames: erst zusammen decken sie die volle Fensterbreite ab.
        createContentFrame   = true,
        createSidePanelFrame = true,

        onShow = function()
            if not ui then
                local content = api:GetNavigationSectionContentFrame(SECTION_KEY)
                if not content then return end

                -- Den SidePanel-Frame stellt MDT unter dem gleichen Schluessel
                -- am Hauptfenster bereit; eine eigene API dafuer gibt es nicht.
                local frame = _G.MDTFrame
                local side = frame and frame.sectionSidePanelFrames
                    and frame.sectionSidePanelFrames[SECTION_KEY]
                if not side then return end

                ui = { rows = {} }
                buildList(content)
                buildDetail(side)
            end

            -- MDT laesst offene Dialoge (z. B. das Gegner-Panel) beim
            -- Sektionswechsel stehen. pluginAPI raeumt sie fuer uns weg.
            if type(api.HideAllDialogs) == "function" then api:HideAllDialogs() end

            -- Klappfenster nicht ueber einen Sektionswechsel hinweg offen lassen.
            if ui and ui.filterPanel then ui.filterPanel:Hide() end

            -- Fensterknoepfe wieder nach oben holen: unsere Flaechen liegen
            -- darueber, sobald die Sektion sichtbar ist.
            if ui and ui.frame then
                liftMDTControls(ui.frame:GetFrameLevel() + 20)
            end

            syncWithMDT()
            updateSubtitle()
            B.Refresh()
        end,
    })

    return true
end
