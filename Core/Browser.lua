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
-- Warum in MDT und nicht in einem eigenen Fenster: die Routen sind nur dann
-- etwas wert, wenn MDT sie gleich uebernehmen kann. Ein eigenes Fenster waere
-- ein zweiter Ort fuer dieselbe Sache - und der Weg dorthin waere wieder das
-- Alt-Tab-Hin-und-Her, das dieses Addon gerade abschaffen soll.

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
local SPELLROW_HEIGHT = 34
-- Rundes Gegnerbild. Dieselbe Maske nimmt MDT fuer seine Kartenblips, also
-- sehen Liste und Karte gleich aus.
local PORTRAIT_MASK = "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask"
local PORTRAIT_SIZE = 18

-- Um so viel steht die Detailspalte ueber MDTs Seitenspalte hinaus. MDT gibt
-- dort feste 251 Pixel vor; darin bekommt man Kennzahlen, Pull-Liste und
-- Zauber nicht geordnet unter.
local DETAIL_EXTRA = 130
local TILE_HEIGHT  = 40
local TILE_GAP     = 6
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
local COL_TIME    = 64  -- deine beste Zeit auf dieser Route

local pluginAPI
local ui           -- gebaute Oberflaeche
local showAddSheet -- weiter unten definiert, aber schon in den Zeilen gebraucht
local hideAddSheet
local lastDetailId -- welche Route zuletzt im Detailbereich stand
-- Zugeklappte Pulls, je Route. Schluessel: Routen-Id und Pullnummer.
local collapsedPulls = {}
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
    -- Ueber der Kartenvorschau, die in derselben Ebene liegt: faehrt man auf
    -- der Karte ueber einen Gegner, soll sein Steckbrief oben liegen.
    frame:SetFrameLevel(600)
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
                        -- MDT vergibt UIDs erst beim Teilen. Fehlt sie, muss
                        -- der Name als Schluessel herhalten - siehe Runs.lua.
                        mdtUid = type(preset.uid) == "string" and preset.uid or nil,
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

    local labels = {}
    for index, preset in pairs(list) do
        if type(preset) == "table" then
            labels[index] = presetDropdownText(preset)
        end
    end

    dropdown:SetList(labels)
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

-- Einen eigenen Dialog in StaticPopupDialogs einzutragen ist der
-- vorgesehene Weg in WoW. luacheck haelt die Felder eines Globals
-- trotzdem fuer schreibgeschuetzt (W122) - hier ist das Eintragen aber
-- genau der Zweck. Eng begrenzt statt in der Konfiguration abgeschaltet,
-- damit ein echter Fall woanders weiter auffaellt.
-- luacheck: push ignore 122
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
-- luacheck: pop

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
        if self.isHeader then return end
        self.highlight:Show()
        -- Kartenvorschau: zeigt den Verlauf, bevor man die Route ueberhaupt
        -- anfasst. Geht verzoegert auf, siehe Core/MapView.lua.
        ns.MapView.Request(self, self.route)
    end)
    row:SetScript("OnLeave", function(self)
        if self.isHeader then return end
        if self.routeId ~= selectedId then self.highlight:Hide() end
        -- Nur eine wartende Karte abbrechen. Eine offene bleibt stehen, sonst
        -- koennte man nicht mit der Maus hineinfahren; sie raeumt sich selbst
        -- weg, sobald der Zeiger weder auf ihr noch auf der Zeile ist.
        ns.MapView.Cancel()
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

    -- Deine beste Zeit auf dieser Route. Leer, solange du sie nicht gelaufen
    -- bist - und genau das ist die Aussage.
    row.time = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.time:SetPoint("RIGHT", row.level, "LEFT", -6, 0)
    row.time:SetJustifyH("RIGHT")
    row.time:SetWidth(COL_TIME)

    -- Bleibt als Anker fuer Titel und Meta erhalten.
    row.stats = row.time

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

    -- Band hinter den Ueberschriftszeilen, wie bei den Bereichen der
    -- Routenliste. Es traegt die Gliederung, nicht eine Farbe.
    row.band = row:CreateTexture(nil, "BACKGROUND", nil, -2)
    row.band:SetAllPoints()
    row.band:SetColorTexture(T:Color("bgOverlay", 1))
    row.band:Hide()

    -- Rundes Gegnerbild wie auf der Karte.
    row.portrait = row:CreateTexture(nil, "ARTWORK")
    row.portrait:SetSize(PORTRAIT_SIZE, PORTRAIT_SIZE)
    row.portrait:SetPoint("TOPLEFT", row, "TOPLEFT", 16, -1)
    row.portraitMask = row:CreateMaskTexture()
    row.portraitMask:SetAllPoints(row.portrait)
    row.portraitMask:SetTexture(PORTRAIT_MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    row.portrait:AddMaskTexture(row.portraitMask)
    row.portrait:Hide()

    -- Ueberschriftszeilen klappen ihren Pull auf und zu, Gegnerzeilen
    -- oeffnen das Gegnerblatt.
    row:SetScript("OnMouseUp", function(self, button)
        if button ~= "LeftButton" then return end
        if self.collapseKey then
            collapsedPulls[self.collapseKey] = (not collapsedPulls[self.collapseKey]) or nil
            B.Refresh()
        elseif self.npcId then
            showAddSheet(self.challengeModeId, self.npcId, self.amount)
        end
    end)

    row:SetScript("OnEnter", function(self)
        self.highlight:Show()

        -- Erst dafuer sorgen, dass die Karte dieselbe Route zeigt wie diese
        -- Liste. Sonst hebt man einen Pull in einer fremden Route hervor -
        -- naemlich in der, ueber die der Zeiger auf dem Weg hierher zuletzt
        -- gelaufen ist.
        if self.pullIndex then
            local route = selectedId and displayById[selectedId]
            if route then ns.MapView.ShowBeside(ui.detail.frame, route) end
        end

        -- Auch die Ueberschriftszeile eines Pulls hebt ihn auf der Karte
        -- hervor - dort steht die Nummer, die man sucht.
        ns.MapView.HighlightPull(self.pullIndex)
        if not self.npcId then return end
        showEnemyPreview(self, self.challengeModeId, self.npcId, self.amount)
    end)
    row:SetScript("OnLeave", function(self)
        self.highlight:Hide()
        ns.MapView.HighlightPull(nil)
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
    row.text:SetPoint("TOPLEFT", row, "TOPLEFT", 38, -2)
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
    row.pullIndex = nil
    local npc = ns.GetNpc(challengeModeId, npcId)
    local name = (npc and npc.name) or ("NPC " .. tostring(npcId))

    row.npcId = npcId
    row.challengeModeId = challengeModeId
    row.amount = amount

    row.index:SetText("")
    row.band:Hide()
    row.collapseKey = nil

    -- In der Dungeonuebersicht steht links noch "3/3" - dort faengt das
    -- Gegnerbild spaeter an. In der Routenansicht ist die Spalte leer.
    local left = hideAmount and 38 or 16
    local textX = left + PORTRAIT_SIZE + 4

    row.portrait:ClearAllPoints()
    row.portrait:SetPoint("TOPLEFT", row, "TOPLEFT", left, -1)
    row.text:ClearAllPoints()
    row.text:SetPoint("TOPLEFT", row, "TOPLEFT", textX, -2)
    row.text:SetPoint("RIGHT", row.percent, "LEFT", -6, 0)

    if npc and npc.displayId then
        SetPortraitTextureFromCreatureDisplayID(row.portrait, npc.displayId)
        row.portrait:Show()
    else
        row.portrait:Hide()
    end

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
            icon:SetPoint("TOPLEFT", row, "TOPLEFT", textX + (shown - 1) * (SPELL_ICON + 3), -height)
            icon:Show()
        else
            icon:Hide()
        end
    end

    if shown > 0 then height = height + SPELL_ICON + 4 end
    return height
end

--------------------------------------------------------------------------
-- Detailbereich
--------------------------------------------------------------------------

---Setzt eine der vier Kennzahl-Kacheln.
---@param index number
---@param value string
---@param caption string
local function setTile(index, value, caption)
    local tile = ui.detail.tiles[index]
    if not tile then return end
    tile.value:SetText(value)
    tile.caption:SetText(caption)
    tile:Show()
end

--------------------------------------------------------------------------
-- Gegnerblatt
--------------------------------------------------------------------------

---Erzeugt oder recycelt eine Zauberzeile im Gegnerblatt.
---@param index number
---@return table
local function acquireSpellRow(index)
    local row = ui.detail.spellRows[index]
    if row then return row end

    row = CreateFrame("Button", nil, ui.detail.sheet.content)
    row:SetHeight(SPELLROW_HEIGHT)

    row.highlight = row:CreateTexture(nil, "BACKGROUND")
    row.highlight:SetAllPoints()
    row.highlight:SetColorTexture(T:Color("bgHover", 0.9))
    row.highlight:Hide()

    -- Weisser Rand hinter dem Symbol: dieselbe Markierung fuer unterbrechbar
    -- wie in der Pull-Liste.
    row.interrupt = row:CreateTexture(nil, "BACKGROUND")
    row.interrupt:SetPoint("TOPLEFT", row, "TOPLEFT", 1, -4)
    row.interrupt:SetSize(28, 28)
    row.interrupt:SetColorTexture(1, 1, 1, 0.95)
    row.interrupt:Hide()

    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetPoint("TOPLEFT", row, "TOPLEFT", 2, -5)
    row.icon:SetSize(26, 26)
    row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    row.name:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 8, 0)
    row.name:SetPoint("RIGHT", row, "RIGHT", -4, 0)
    row.name:SetJustifyH("LEFT")
    row.name:SetWordWrap(false)

    row.flags = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.flags:SetPoint("TOPLEFT", row.name, "BOTTOMLEFT", 0, -2)
    row.flags:SetPoint("RIGHT", row, "RIGHT", -4, 0)
    row.flags:SetJustifyH("LEFT")
    row.flags:SetWordWrap(false)

    -- Wer etwas dagegen tun kann. Steht in der Pull-Liste nur im Tooltip;
    -- hier ist Platz, also steht es fest da.
    row.hints = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.hints:SetPoint("TOPLEFT", row.flags, "BOTTOMLEFT", 0, -2)
    row.hints:SetPoint("RIGHT", row, "RIGHT", -4, 0)
    row.hints:SetJustifyH("LEFT")
    row.hints:SetWordWrap(true)

    row:SetScript("OnEnter", function(self)
        if not self.spellId then return end
        self.highlight:Show()
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetSpellByID(self.spellId)
        GameTooltip:Show()
    end)
    row:SetScript("OnLeave", function(self)
        self.highlight:Hide()
        GameTooltip:Hide()
    end)

    ui.detail.spellRows[index] = row
    return row
end

---Setzt eine Wertzeile im Gegnerblatt.
---@param index number
---@param label string
---@param value string
local function setStat(index, label, value)
    local line = ui.detail.statRows[index]
    if not line then return end
    line.label:SetText(label)
    line.value:SetText(value)
end

---Blendet das Gegnerblatt wieder aus.
function hideAddSheet()
    if ui and ui.detail and ui.detail.sheet then ui.detail.sheet:Hide() end
end

---Zeigt alles, was wir ueber einen Gegner wissen.
---
---Aufgerufen aus zwei Richtungen: Klick auf einen Gegner in der Pull-Liste
---und Klick auf einen Blip auf der Karte. Beide landen hier.
---@param challengeModeId number
---@param npcId number
---@param amount number|nil Anzahl im angeklickten Pull
function showAddSheet(challengeModeId, npcId, amount)
    if not ui or not ui.detail then return end

    local npc = ns.GetNpc(challengeModeId, npcId)
    if not npc then return end

    local d = ui.detail
    local sheet = d.sheet
    local dungeon = ns.GetDungeon(challengeModeId)
    local need = dungeon and dungeon.totalCount

    if npc.displayId then
        sheet.model:SetDisplayInfo(npc.displayId)
        -- Ganzkoerper statt Portraitausschnitt: bei Bossen ist die Silhouette
        -- die halbe Wiedererkennung.
        sheet.model:SetPortraitZoom(0)
        sheet.model:SetRotation(0.5)
        sheet.model:Show()
    else
        sheet.model:Hide()
    end

    sheet.name:SetText(("%s%s|r"):format(
        npc.isBoss and T:Hex("accent") or T:Hex("textPrimary"), npc.name or "?"))

    local kind = npc.creatureType or ""
    if npc.level then
        kind = kind ~= "" and (kind .. " · " .. ns.L["PREVIEW_LEVEL"] .. " " .. npc.level)
            or (ns.L["PREVIEW_LEVEL"] .. " " .. npc.level)
    end
    if npc.isBoss then
        kind = kind ~= "" and (kind .. " · " .. ns.L["SHEET_BOSS"]) or ns.L["SHEET_BOSS"]
    end
    sheet.kind:SetText(kind)

    local share = (npc.count and need and need > 0) and (npc.count / need * 100) or nil

    setStat(1, ns.L["SHEET_HEALTH"], shortHealth(npc.health))
    setStat(2, ns.L["SHEET_FORCES"], tostring(npc.count or "?"))
    setStat(3, ns.L["SHEET_SHARE"], share and ("%.2f %%"):format(share) or "–")
    setStat(4, ns.L["SHEET_IN_PULL"], amount and ("%d×"):format(amount) or "–")
    setStat(5, ns.L["SHEET_NPCID"], tostring(npcId))

    -- Zauber. Namen holen wir zur Laufzeit: im Datenpaket steht nur die ID,
    -- und die ist in jeder Sprache dieselbe.
    local spells = npc.spells or {}
    local y = 0

    for i, spell in ipairs(spells) do
        local row = acquireSpellRow(i)
        row.spellId = spell.id

        local info = C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(spell.id)
        row.name:SetText(("%s%s|r"):format(T:Hex("textPrimary"),
            (info and info.name) or ("Spell " .. tostring(spell.id))))

        row.icon:SetTexture(C_Spell.GetSpellTexture(spell.id) or 134400)
        row.interrupt:SetShown(spell.interruptible == true)

        local flags, hints = {}, {}
        if spell.interruptible then
            flags[#flags + 1] = T:Hex("success") .. ns.L["SPELL_INTERRUPTIBLE"] .. "|r"
        end
        for _, dispel in ipairs(DISPEL_TYPES) do
            if spell[dispel.key] then
                flags[#flags + 1] = ("|cff%02x%02x%02x%s|r"):format(
                    dispel.r * 255, dispel.g * 255, dispel.b * 255, ns.L["SPELL_" .. dispel.label])
                for _, hint in ipairs(ns.GetDispelHint(dispel.key)) do
                    hints[#hints + 1] = hint.text
                end
            end
        end
        row.flags:SetText(table.concat(flags, " · "))
        row.hints:SetText(table.concat(hints, "\n"))

        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", sheet.content, "TOPLEFT", 0, -y)
        row:SetPoint("TOPRIGHT", sheet.content, "TOPRIGHT", 0, -y)

        -- Hoehe aus dem, was wirklich dasteht: ein Zauber ohne Bannart
        -- braucht keine zwei leeren Zeilen.
        local height = 8 + row.name:GetStringHeight() + 2
        if #flags > 0 then height = height + row.flags:GetStringHeight() + 2 end
        if #hints > 0 then height = height + row.hints:GetStringHeight() + 2 end
        height = math.max(height, SPELLROW_HEIGHT)

        row:SetHeight(height)
        row:Show()
        y = y + height
    end

    for i = #spells + 1, #d.spellRows do d.spellRows[i]:Hide() end

    if #spells == 0 then
        local row = acquireSpellRow(1)
        row.spellId = nil
        row.icon:SetTexture(nil)
        row.interrupt:Hide()
        row.name:SetText(T:Text("textMuted", ns.L["SHEET_NO_SPELLS"]))
        row.flags:SetText("")
        row.hints:SetText("")
        row:SetHeight(SPELLROW_HEIGHT)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", sheet.content, "TOPLEFT", 0, 0)
        row:SetPoint("TOPRIGHT", sheet.content, "TOPRIGHT", 0, 0)
        row:Show()
        y = SPELLROW_HEIGHT
    end

    sheet.content:SetHeight(math.max(y, 1))
    sheet:Show()
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
        d.affixes:SetText("")
        d.runs:SetText("")
        d.section:SetText("")
        d.foldAll:Hide()
        for _, tile in ipairs(d.tiles) do
            tile.value:SetText("")
            tile.caption:SetText("")
            tile:Hide()
        end
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

    -- Vier Kennzahlen, dieselben wie die Spalten der Liste und in derselben
    -- Reihenfolge.
    setTile(1, percentText(route), ns.L["TILE_PERCENT"])
    setTile(2, (route.enemyForces and route.enemyForcesRequired)
        and ("%d/%d"):format(route.enemyForces, route.enemyForcesRequired)
        or T:Text("textMuted", "–"), ns.L["COL_FORCES"])
    setTile(3, tostring(#route.pulls), ns.L["COL_PULLS"])
    setTile(4, levelText(route) ~= "" and levelText(route) or T:Text("textMuted", "–"), ns.L["COL_LEVEL"])

    local affixes = (route.affixes and #route.affixes > 0) and table.concat(route.affixes, ", ") or "–"
    d.affixes:SetText(T:Hex("textMuted") .. ns.L["DETAIL_AFFIXES"]:format(affixes) .. "|r")

    -- Was du selbst mit dieser Route erreicht hast.
    local key = ns.Runs.KeyFor(route)
    local best = ns.Runs.Best(route.challengeModeId, key)
    if best then
        local runs = #ns.Runs.ForRoute(route.challengeModeId, key)
        d.runs:SetText(("%s %s%s|r %s+%d · %s|r"):format(
            ns.L["DETAIL_YOUR_BEST"],
            best.onTime and T:Hex("success") or T:Hex("warning"),
            ns.Runs.FormatTime(best.time),
            T:Hex("textMuted"), best.level,
            ns.L["DETAIL_RUN_COUNT"]:format(runs)))
    else
        d.runs:SetText(T:Text("textMuted", ns.L["DETAIL_NO_RUNS"]))
    end

    d.section:SetText(ns.L["DETAIL_SECTION_PULLS"]:upper())

    local anyOpen = false
    for i = 1, #route.pulls do
        if not collapsedPulls[route.id .. ":" .. i] then
            anyOpen = true
            break
        end
    end
    d.foldAll:SetText(anyOpen and ns.L["DETAIL_FOLD_ALL"] or ns.L["DETAIL_UNFOLD_ALL"])
    d.foldAll:Show()

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

        -- Gegner des Pulls zusammenfassen, haeufigste zuerst. Muss vor die
        -- Ueberschrift, denn die nennt ihre Anzahl.
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

        -- Ueberschriften zeigen keine Vorschau und keine Zauber.
        header.npcId = nil
        header.pullIndex = i
        for _, icon in ipairs(header.icons) do icon:Hide() end

        local pullKey = (selectedId or "") .. ":" .. i
        local folded = collapsedPulls[pullKey] or false
        header.collapseKey = pullKey

        header.portrait:Hide()
        header.band:Show()
        header.index:SetText("")
        header.text:ClearAllPoints()
        header.text:SetPoint("TOPLEFT", header, "TOPLEFT", 8, -2)
        header.text:SetPoint("RIGHT", header.percent, "LEFT", -6, 0)

        -- Dieselbe Schreibweise wie die Bereiche der Routenliste: Pfeil,
        -- Name, Anzahl in Klammern.
        header.text:SetText(("%s %s%s %d%s|r  %s(%d)|r"):format(
            T:Text("accent", folded and "+" or "-"),
            pull.boss and T:Hex("accent") or T:Hex("textSecondary"),
            ns.L["PULL"], i,
            pull.boss and " !" or "",
            T:Hex("textMuted"), #order))

        if pull.cumulative and need and need > 0 then
            header.percent:SetText((T:Hex("textSecondary") .. "%.1f %%|r"):format(pull.cumulative / need * 100))
        else
            header.percent:SetText("")
        end

        place(header, PULLROW_HEIGHT + 5)

        if not folded then
            for _, npcId in ipairs(order) do
                rowIndex = rowIndex + 1
                local row = acquirePullRow(rowIndex)
                -- Erst fuellen, dann zuordnen: fillAddRow raeumt pullIndex
                -- weg, weil dieselben Zeilen auch die Dungeonuebersicht
                -- bedienen.
                local height = fillAddRow(row, route.challengeModeId, npcId, counts[npcId])
                row.pullIndex = i
                place(row, height)
            end
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
    d.author:SetText(("%d %s"):format(dungeon.totalCount or 0, ns.L["DETAIL_FORCES"]))

    -- Bestleistung der laufenden Season, falls vorhanden.
    local best, bestTime = "", nil
    if C_MythicPlus and C_MythicPlus.GetSeasonBestForMap then
        local intime, overtime = C_MythicPlus.GetSeasonBestForMap(cmId)
        local run = intime or overtime
        if type(run) == "table" and run.level then
            best = ("%s+%d|r"):format(intime and T:Hex("success") or T:Hex("warning"), run.level)
            bestTime = run.durationSec and formatTime(math.floor(run.durationSec)) or nil
        end
    end

    local list, routeCount = dungeonConsensus(cmId)

    setTile(1, best ~= "" and best or T:Text("textMuted", "–"), ns.L["TILE_BEST"])
    setTile(2, bestTime or T:Text("textMuted", "–"), ns.L["TILE_BEST_TIME"])
    setTile(3, formatTime(timeLimit), ns.L["DETAIL_TIMER"])
    setTile(4, tostring(routeCount), ns.L["TILE_ROUTES"])

    d.affixes:SetText(T:Hex("textMuted") .. ns.L["DETAIL_CONSENSUS"]:format(routeCount) .. "|r")
    d.runs:SetText("")
    d.section:SetText(ns.L["DETAIL_SECTION_OVERVIEW"]:upper())
    d.foldAll:Hide()

    local y, rowIndex = 0, 0

    ---Setzt eine Zeile an die naechste freie Stelle.
    local function place(row, height)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", d.content, "TOPLEFT", 0, -y)
        row:SetPoint("TOPRIGHT", d.content, "TOPRIGHT", 0, -y)
        row:SetHeight(height)
        row:Show()
        y = y + height
    end

    ---Bandzeile als Ueberschrift eines Blocks.
    local function band(text, count)
        rowIndex = rowIndex + 1
        local row = acquirePullRow(rowIndex)
        row.npcId, row.pullIndex, row.collapseKey = nil, nil, nil
        row.portrait:Hide()
        for _, icon in ipairs(row.icons) do icon:Hide() end
        row.band:Show()
        row.index:SetText("")
        row.percent:SetText("")
        row.text:ClearAllPoints()
        row.text:SetPoint("TOPLEFT", row, "TOPLEFT", 8, -2)
        row.text:SetPoint("RIGHT", row.percent, "LEFT", -6, 0)
        row.text:SetText(("%s%s|r  %s(%d)|r"):format(
            T:Hex("textSecondary"), text, T:Hex("textMuted"), count))
        place(row, PULLROW_HEIGHT + 5)
    end

    -- Deine Rangliste zuerst: die beantwortet die Frage, mit welcher Route du
    -- tatsaechlich am schnellsten warst. Erst danach die Gegner.
    local ranking = ns.Runs.Ranking(cmId)
    if #ranking > 0 then
        band(ns.L["DETAIL_YOUR_TIMES"], #ranking)

        for rank, entry in ipairs(ranking) do
            rowIndex = rowIndex + 1
            local row = acquirePullRow(rowIndex)
            row.npcId, row.pullIndex, row.collapseKey = nil, nil, nil
            row.portrait:Hide()
            row.band:Hide()
            for _, icon in ipairs(row.icons) do icon:Hide() end

            row.index:SetText((T:Hex("textMuted") .. "%d.|r"):format(rank))
            row.text:ClearAllPoints()
            row.text:SetPoint("TOPLEFT", row, "TOPLEFT", 38, -2)
            row.text:SetPoint("RIGHT", row.percent, "LEFT", -6, 0)

            local known = entry.key and ns.routeById[entry.key]
            row.text:SetText(("%s%s|r %s+%d · %s|r"):format(
                T:Hex("textPrimary"),
                (known and known.title) or entry.label or ns.L["RUN_UNKNOWN_ROUTE"],
                T:Hex("textMuted"), entry.best.level,
                ns.L["DETAIL_RUN_COUNT"]:format(entry.count)))

            row.percent:SetText(("%s%s|r"):format(
                entry.best.onTime and T:Hex("success") or T:Hex("warning"),
                ns.Runs.FormatTime(entry.best.time)))

            place(row, PULLROW_HEIGHT + 4)
        end

        band(ns.L["DETAIL_SECTION_ADDS"], #list)
    end

    for _, entry in ipairs(list) do
        rowIndex = rowIndex + 1
        local row = acquirePullRow(rowIndex)

        -- Dieselbe Darstellung wie in der Routenansicht: Zauber am Gegner und
        -- Modellvorschau beim Ueberfahren. Nur die linke Spalte ist anders.
        local height = fillAddRow(row, cmId, entry.npc, 1, true)
        row.pullIndex = nil

        -- Anteil der Routen, die diesen Gegner mitnehmen.
        local share = routeCount > 0 and (entry.count / routeCount * 100) or 0
        local colour = share >= 99 and T:Hex("success") or share >= 50 and T:Hex("warning") or T:Hex("textMuted")
        row.index:SetText(("%s%d/%d|r"):format(colour, entry.count, routeCount))

        -- Rechts nicht die Gegnerkraft eines einzelnen Mobs - die sagt beim
        -- Ueberblick nichts. Was zaehlt, ist sein Anteil am Soll: daran sieht
        -- man, ob es weh tut, ihn auszulassen.
        local weight = (dungeon.totalCount or 0) > 0
            and (entry.forces or 0) / dungeon.totalCount * 100 or nil
        row.percent:SetText(weight
            and (T:Hex("textMuted") .. "%.1f %%|r"):format(weight)
            or "")

        place(row, height)
    end

    for i = rowIndex + 1, #d.pullRows do d.pullRows[i]:Hide() end
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

    -- Die Zeilen werden gleich neu belegt; eine wartende Kartenvorschau
    -- zeigte danach die Route der vorigen Belegung.
    ns.MapView.Cancel()

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
            row.time:SetText("")
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
            row.time:SetText("")
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

            -- Beste eigene Zeit. Gruen, wenn der Lauf in der Zeit war.
            local best = ns.Runs.Best(route.challengeModeId, ns.Runs.KeyFor(route))
            row.time:SetText(best
                and ("%s%s|r"):format(
                    best.onTime and T:Hex("success") or T:Hex("textSecondary"),
                    ns.Runs.FormatTime(best.time))
                or "")

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
    if lastDetailId ~= selectedId then
        hideAddSheet()
        lastDetailId = selectedId
    end
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

---Baut die Detailspalte rechts.
---
---Sie ist breiter als MDTs Seitenspalte. MDT gibt dort feste 251 Pixel vor,
---und darin bekommt man Kennzahlen, Pull-Liste, Zauber und Gegnerwerte nicht
---geordnet unter. Die zusaetzlichen Pixel liegen ueber unserem eigenen
---Listenbereich; die Liste wird um denselben Betrag schmaler, damit sich
---nichts ueberdeckt.
---@param parent table
local function buildDetail(parent)
    local root = CreateFrame("Frame", nil, parent)
    root:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 0)
    root:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0)
    root:SetPoint("LEFT", parent, "LEFT", -DETAIL_EXTRA, 0)
    -- Weit ueber allem im Listenbereich: dessen Zeilen haengen tief in
    -- Scrollrahmen und laegen sonst ueber dem ueberstehenden Stueck.
    root:SetFrameLevel(parent:GetFrameLevel() + 200)
    root:EnableMouse(true)
    T:Fill(root, "bgBase", 0.98)

    local d = { pullRows = {}, spellRows = {}, statRows = {} }
    d.frame = root

    --------------------------------------------------------------- Kopf
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

    -------------------------------------------------------- Kennzahlen
    -- Vier Kacheln statt einer riesigen Zahl mit lose danebenstehenden
    -- Werten. Es sind dieselben vier Groessen wie die Spalten der Liste, in
    -- derselben Reihenfolge - wer dort vergleicht, findet sie hier wieder.
    d.tiles = {}
    for i = 1, 4 do
        local tile = CreateFrame("Frame", nil, root)
        tile:SetHeight(TILE_HEIGHT)
        T:Fill(tile, "bgOverlay", 0.9)

        tile.value = tile:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        tile.value:SetPoint("TOP", tile, "TOP", 0, -6)
        tile.value:SetPoint("LEFT", tile, "LEFT", 3, 0)
        tile.value:SetPoint("RIGHT", tile, "RIGHT", -3, 0)
        tile.value:SetJustifyH("CENTER")
        tile.value:SetWordWrap(false)

        tile.caption = tile:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        tile.caption:SetPoint("BOTTOM", tile, "BOTTOM", 0, 5)
        tile.caption:SetJustifyH("CENTER")
        tile.caption:SetWordWrap(false)

        if i == 1 then
            tile:SetPoint("TOPLEFT", d.author, "BOTTOMLEFT", 0, -10)
        else
            tile:SetPoint("TOPLEFT", d.tiles[i - 1], "TOPRIGHT", TILE_GAP, 0)
        end
        d.tiles[i] = tile
    end

    -- Die Kachelbreite haengt an der Fensterbreite, nicht an einer festen
    -- Zahl: MDT laesst sein Fenster skalieren.
    root:SetScript("OnSizeChanged", function(self)
        local inner = (self:GetWidth() or 0) - PADDING * 2
        local w = math.max(40, (inner - TILE_GAP * 3) / 4)
        for _, tile in ipairs(d.tiles) do tile:SetWidth(w) end
    end)

    -- Einmal von Hand: OnSizeChanged feuert nicht, wenn der Rahmen beim
    -- Anlegen schon seine endgueltige Groesse hat.
    root:GetScript("OnSizeChanged")(root)

    d.affixes = root:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    d.affixes:SetPoint("TOPLEFT", d.tiles[1], "BOTTOMLEFT", 2, -8)
    d.affixes:SetPoint("RIGHT", root, "RIGHT", -PADDING, 0)
    d.affixes:SetJustifyH("LEFT")
    d.affixes:SetWordWrap(true)

    ---------------------------------------------------------- Abschnitt
    d.runs = root:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    d.runs:SetPoint("TOPLEFT", d.affixes, "BOTTOMLEFT", 0, -4)
    d.runs:SetPoint("RIGHT", root, "RIGHT", -PADDING, 0)
    d.runs:SetJustifyH("LEFT")
    d.runs:SetWordWrap(false)

    d.section = root:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    d.section:SetPoint("TOPLEFT", d.runs, "BOTTOMLEFT", -2, -10)
    d.section:SetTextColor(T:Color("textMuted"))

    local divider = T:Divider(root)
    divider:SetPoint("TOPLEFT", d.section, "BOTTOMLEFT", 0, -4)
    divider:SetPoint("RIGHT", root, "RIGHT", -PADDING, 0)

    -- Alles auf oder alles zu. Bei vierzig Pulls einzeln zu klicken waere
    -- Arbeit, die niemand machen will.
    d.foldAll = T:Button(root, ns.L["DETAIL_FOLD_ALL"], 124)
    d.foldAll:SetHeight(18)
    d.foldAll:SetPoint("BOTTOMRIGHT", divider, "TOPRIGHT", 0, 3)
    d.foldAll:SetScript("OnClick", function()
        local route = selectedId and displayById[selectedId]
        if not route or not route.pulls then return end

        -- Ist noch irgendein Pull offen, klappt der Knopf zu. Erst wenn alle
        -- zu sind, klappt er wieder auf.
        local anyOpen = false
        for i = 1, #route.pulls do
            if not collapsedPulls[selectedId .. ":" .. i] then
                anyOpen = true
                break
            end
        end

        for i = 1, #route.pulls do
            collapsedPulls[selectedId .. ":" .. i] = anyOpen or nil
        end
        B.Refresh()
    end)

    local scroll = CreateFrame("ScrollFrame", nil, root, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", divider, "BOTTOMLEFT", 0, -6)
    scroll:SetPoint("BOTTOMRIGHT", root, "BOTTOMRIGHT", -(PADDING + 22), PADDING)
    d.scroll = scroll

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(1, 1)
    scroll:SetScrollChild(content)
    d.content = content

    scroll:SetScript("OnSizeChanged", function(self, width) content:SetWidth(width) end)
    content:SetWidth(scroll:GetWidth())

    d.hint = root:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    d.hint:SetPoint("TOPLEFT", root, "TOPLEFT", PADDING, -90)
    d.hint:SetPoint("TOPRIGHT", root, "TOPRIGHT", -PADDING, -90)
    d.hint:SetJustifyH("CENTER")
    d.hint:SetText(ns.L["DETAIL_HINT"])

    ------------------------------------------------------- Gegnerblatt
    -- Klickt man einen Gegner an - auf der Karte oder in der Pull-Liste -,
    -- legt sich dieses Blatt ueber die Routenansicht. Ein eigenes Fenster
    -- waere ein dritter Ort auf dem Bildschirm; hier steht es da, wo man
    -- ohnehin hinsieht.
    local sheet = CreateFrame("Frame", nil, root)
    sheet:SetAllPoints(root)
    sheet:SetFrameLevel(root:GetFrameLevel() + 10)
    sheet:EnableMouse(true)
    T:Fill(sheet, "bgBase", 1)
    sheet:Hide()
    d.sheet = sheet

    sheet.back = T:Button(sheet, ns.L["SHEET_BACK"], 96)
    sheet.back:SetHeight(20)
    sheet.back:SetPoint("TOPLEFT", sheet, "TOPLEFT", PADDING, -PADDING)
    sheet.back:SetScript("OnClick", function() hideAddSheet() end)

    sheet.model = CreateFrame("PlayerModel", nil, sheet)
    sheet.model:SetSize(96, 122)
    sheet.model:SetPoint("TOPLEFT", sheet.back, "BOTTOMLEFT", 0, -8)

    sheet.name = sheet:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    sheet.name:SetPoint("TOPLEFT", sheet.model, "TOPRIGHT", 12, -2)
    sheet.name:SetPoint("RIGHT", sheet, "RIGHT", -PADDING, 0)
    sheet.name:SetJustifyH("LEFT")
    sheet.name:SetWordWrap(true)

    sheet.kind = sheet:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    sheet.kind:SetPoint("TOPLEFT", sheet.name, "BOTTOMLEFT", 0, -4)
    sheet.kind:SetPoint("RIGHT", sheet, "RIGHT", -PADDING, 0)
    sheet.kind:SetJustifyH("LEFT")
    sheet.kind:SetWordWrap(true)

    -- Wertzeilen: Bezeichnung links, Wert rechts. Untereinander ausgerichtet,
    -- damit man Zahlen vergleichen kann, statt sie zu suchen.
    local previous
    for i = 1, 5 do
        local line = CreateFrame("Frame", nil, sheet)
        line:SetHeight(16)
        if previous then
            line:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -2)
            line:SetPoint("TOPRIGHT", previous, "BOTTOMRIGHT", 0, -2)
        else
            line:SetPoint("TOPLEFT", sheet.model, "BOTTOMLEFT", 0, -12)
            line:SetPoint("RIGHT", sheet, "RIGHT", -PADDING, 0)
        end

        line.label = line:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        line.label:SetPoint("LEFT", line, "LEFT", 0, 0)
        line.label:SetJustifyH("LEFT")
        line.label:SetTextColor(T:Color("textMuted"))

        line.value = line:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        line.value:SetPoint("RIGHT", line, "RIGHT", 0, 0)
        line.value:SetJustifyH("RIGHT")

        d.statRows[i] = line
        previous = line
    end

    sheet.spellLabel = sheet:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    sheet.spellLabel:SetPoint("TOPLEFT", d.statRows[5], "BOTTOMLEFT", 0, -12)
    sheet.spellLabel:SetTextColor(T:Color("textMuted"))
    sheet.spellLabel:SetText(ns.L["SHEET_SPELLS"])

    local sheetDivider = T:Divider(sheet)
    sheetDivider:SetPoint("TOPLEFT", sheet.spellLabel, "BOTTOMLEFT", 0, -4)
    sheetDivider:SetPoint("RIGHT", sheet, "RIGHT", -PADDING, 0)

    local sheetScroll = CreateFrame("ScrollFrame", nil, sheet, "UIPanelScrollFrameTemplate")
    sheetScroll:SetPoint("TOPLEFT", sheetDivider, "BOTTOMLEFT", 0, -6)
    sheetScroll:SetPoint("BOTTOMRIGHT", sheet, "BOTTOMRIGHT", -(PADDING + 22), PADDING)
    sheet.scroll = sheetScroll

    local sheetContent = CreateFrame("Frame", nil, sheetScroll)
    sheetContent:SetSize(1, 1)
    sheetScroll:SetScrollChild(sheetContent)
    sheet.content = sheetContent

    sheetScroll:SetScript("OnSizeChanged", function(self, width) sheetContent:SetWidth(width) end)
    sheetContent:SetWidth(sheetScroll:GetWidth())

    -- Ueber der Detailspalte bleibt die Kartenvorschau offen: von dort aus
    -- hebt man Pulls auf der Karte hervor.
    ns.MapView.KeepOpenOver(root)

    ui.detail = d
end

---Baut die Routenliste in MDTs Kartenbereich.
---@param parent table
local function buildList(parent)
    local root = makeRoot(parent)
    ui.frame = root

    -- Geht MDT zu oder wechselt jemand die Sektion, verschwindet dieser
    -- Rahmen - und mit ihm muss die Kartenvorschau verschwinden. Sie haengt
    -- an UIParent, nicht an MDT, und bliebe sonst allein auf dem Bildschirm
    -- stehen.
    root:HookScript("OnHide", function() ns.MapView.Hide() end)

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
    -- "dev" setzt Init.lua, wenn der Versionsplatzhalter nicht ersetzt wurde -
    -- also bei jeder Kopie aus dem Repo und nie bei einer aus CurseForge. Der
    -- Zusatz beantwortet beim Entwickeln die Frage, welchen Stand man vor sich
    -- hat, ohne dass es dafuer ein zweites Addon braucht.
    ui.title:SetText(ns.version == "dev"
        and "MDT Route Library |cffff8800DEV|r"
        or "MDT Route Library")
    ui.title:SetTextColor(T:Color("textPrimary"))

    ui.subtitle = root:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    ui.subtitle:SetPoint("LEFT", ui.title, "RIGHT", 12, -1)

    local search = CreateFrame("EditBox", nil, root, "SearchBoxTemplate")
    search:SetSize(200, 22)
    search:SetPoint("TOPRIGHT", root, "TOPRIGHT", -(PADDING + DETAIL_EXTRA), -PADDING)
    search:SetAutoFocus(false)
    search:SetScript("OnTextChanged", function(self, _userInput)
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
    head:SetPoint("RIGHT", root, "RIGHT", -(PADDING + 22 + DETAIL_EXTRA), 0)
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
    local hLevel = headLabel(ns.L["COL_LEVEL"], COL_LEVEL, hPulls,
        ns.L["COL_LEVEL_TIP_TITLE"], ns.L["COL_LEVEL_TIP"])
    headLabel(ns.L["COL_TIME"], COL_TIME, hLevel,
        ns.L["COL_TIME_TIP_TITLE"], ns.L["COL_TIME_TIP"])

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
    scroll:SetPoint("BOTTOMRIGHT", root, "BOTTOMRIGHT", -(PADDING + 22 + DETAIL_EXTRA), PADDING + 34)
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

    -- Rueckmeldungen der Karte an die Oberflaeche: dieselbe Gegnervorschau
    -- wie in der Pull-Liste, und die Pull-Zeile rechts leuchtet mit.
    ns.MapView.onEnemyEnter = function(owner, challengeModeId, npcId)
        showEnemyPreview(owner, challengeModeId, npcId)
    end
    ns.MapView.onEnemyLeave = hidePreview
    ns.MapView.onEnemyClick = function(challengeModeId, npcId)
        showAddSheet(challengeModeId, npcId)
    end

    ns.MapView.onPullEnter = function(index)
        for _, row in ipairs(ui.detail.pullRows) do
            row.highlight:SetShown(index ~= nil and row.pullIndex == index)
        end
    end
    ns.MapView.onPullLeave = function()
        for _, row in ipairs(ui.detail.pullRows) do
            row.highlight:Hide()
        end
    end

    local mapButton = T:Button(root, ns.L["BROWSER_SHOW_ON_MAP"], 132)
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
    local copyButton = T:Button(root, ns.L["BROWSER_SAVE"], 132)
    copyButton:SetPoint("LEFT", mapButton, "RIGHT", 8, 0)
    copyButton:SetScript("OnClick", function()
        local route = selectedId and displayById[selectedId]
        if not route then return end

        if IsShiftKeyDown() then
            B.CopyString(route)
            return
        end

        local idx, _, err = ns.MDT.PutPreset(route, true)
        if not idx then
            ns.Warn(err or "unbekannter Fehler")
            return
        end
        ns.Print(ns.L["SAVED_TO_MDT"], route.title or route.id)
        B.Refresh()
    end)
    copyButton.tooltipText = ns.L["BROWSER_SAVE_TIP"]
    ui.copyButton = copyButton

    local deleteButton = T:Button(root, ns.L["DELETE"], 132)
    deleteButton:SetPoint("LEFT", copyButton, "RIGHT", 8, 0)
    deleteButton:SetScript("OnClick", function()
        local n = countChecked()
        if n == 0 then return end
        StaticPopup_Show("MDTRL_DELETE", n)
    end)
    ui.deleteButton = deleteButton

    local undoButton = T:Button(root, ns.L["UNDO"], 112)
    undoButton:SetPoint("LEFT", deleteButton, "RIGHT", 8, 0)
    undoButton:SetScript("OnClick", function()
        local restored = restoreDeleted()
        if restored > 0 then
            ns.Print(ns.L["UNDO_DONE"], restored)
        end
        B.Refresh()
    end)
    ui.undoButton = undoButton

    local submitButton = T:Button(root, ns.L["BROWSER_SUBMIT"], 140)
    submitButton:SetPoint("BOTTOMRIGHT", root, "BOTTOMRIGHT", -(PADDING + DETAIL_EXTRA), 8)
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
        tooltip   = ns.version == "dev" and "MDT Route Library (DEV)" or "MDT Route Library",
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
                liftMDTControls((ui.detail and ui.detail.frame:GetFrameLevel() or ui.frame:GetFrameLevel()) + 20)
            end

            syncWithMDT()
            updateSubtitle()
            B.Refresh()
        end,
    })

    return true
end
