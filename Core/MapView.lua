-- Kartenansicht: die Route auf der Dungeonkarte, zum Hineinfahren und Zoomen.
--
-- Warum nachgebaut und nicht MDTs eigene benutzt: MDTs Plugin-Schnittstelle
-- kennt sechs Methoden (RegisterNavigationSection, GetCurrentSection,
-- SetCurrentSection, GetNavigationSectionContentFrame, HideAllDialogs,
-- RegisterDungeonData). Keine davon zeichnet eine Karte, und MDTs Karte gibt
-- es nur einmal - fest an MDT.main_frame gebunden. Sie in unsere Sektion zu
-- holen ginge nur ueber MDTs Interna, und davon haelt sich dieses Addon fern.
--
-- Was wir stattdessen benutzen, ist alles oeffentlich: MDTs Kacheln liegen als
-- Dateien im Addonordner, die Gegnerbilder kommen aus Blizzards
-- SetPortraitTextureFromCreatureDisplayID, und die Koordinaten stecken im
-- Datenpaket. Ring und Leuchten um die Bilder sind dieselben Ausschnitte aus
-- MDTs Texturatlas, die MDT selbst dafuer nimmt - damit sieht es aus wie dort.
--
-- Was hier bewusst fehlt: Patrouillenwege, Sichtlinien, Interessenpunkte,
-- Bossflaechen. Wer das braucht, ist mit "Auf Karte zeigen" in MDTs echter
-- Ansicht besser bedient. Diese hier beantwortet eine Frage: wo laeuft die
-- Route lang, und was liegt in welchem Pull.

local _, ns = ...

local MV = {}
ns.MapView = MV

local T = ns.Theme

-- MDTs Kartenraum bei scale 1. Zehn quadratische Kachelreihen zu Breite/15
-- ergeben 560, nicht die 555 des Fensters - fuer die Umrechnung zaehlt die
-- Kachelgeometrie.
local MDT_WIDTH  = 840
local COLS, ROWS = 15, 10
local ASPECT     = COLS / ROWS  -- 1.5

-- MDTs Texturatlas. Dieselben Ausschnitte benutzt MDT fuer seine Blips.
local ATLAS = "Interface\\AddOns\\MythicDungeonTools\\Textures\\UI-EncounterJournalTextures"
local RING  = { 0.85, 0.97, 0.43, 0.4865 }
local GLOW  = { 0.69, 0.81, 0.39, 0.333 }
local MASK  = "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask"

local BLIP_SIZE = 15
local LABEL_GAP = 22
local BAR_SPACE = 46 -- Ueberschrift oben, Zoomleiste unten

-- Blasse Darstellung fuer Gegner, die nicht zur Route gehoeren.
local DIM_ALPHA  = 0.5
local MUTE_ALPHA = 0.3

local ZOOM_MIN, ZOOM_MAX, ZOOM_STEP = 1, 4, 0.5

local panel    -- die ganze Ansicht
local route    -- aktuell gezeigte Route

--------------------------------------------------------------------------
-- Farben
--------------------------------------------------------------------------

---Farbe eines Pulls nach seiner Position in der Route: Gruen am Anfang,
---Gold in der Mitte, Rot am Ende.
---@param t number 0 = erster Pull, 1 = letzter
---@return number r, number g, number b
local function pullColor(t)
    if t < 0.5 then
        local k = t * 2
        return 0.25 + 0.75 * k, 0.80 + 0.05 * k, 0.30 - 0.10 * k
    end
    local k = (t - 0.5) * 2
    return 1.0, 0.85 - 0.55 * k, 0.20 + 0.05 * k
end

--------------------------------------------------------------------------
-- Vorrat
--------------------------------------------------------------------------

---Erzeugt einen Blip aus dem Vorrat.
---@param index number
---@return table
local function acquireBlip(index)
    local blip = panel.blips[index]
    if blip then return blip end

    blip = CreateFrame("Button", nil, panel.canvas)
    blip:SetSize(BLIP_SIZE, BLIP_SIZE)

    -- Klicks weiterreichen, damit man die Karte auch dann ziehen kann, wenn
    -- der Zeiger gerade auf einem Gegner steht. Ohne das faengt der Blip den
    -- Mausdruck ab und die Karte bleibt stehen.
    if blip.SetPropagateMouseClicks then blip:SetPropagateMouseClicks(true) end

    blip.glow = blip:CreateTexture(nil, "BACKGROUND")
    blip.glow:SetPoint("CENTER")
    blip.glow:SetSize(BLIP_SIZE * 1.7, BLIP_SIZE * 1.7)
    blip.glow:SetTexture(ATLAS)
    blip.glow:SetTexCoord(unpack(GLOW))
    blip.glow:Hide()

    blip.portrait = blip:CreateTexture(nil, "ARTWORK")
    blip.portrait:SetPoint("CENTER")
    blip.portrait:SetSize(BLIP_SIZE, BLIP_SIZE)

    -- Ohne Maske waere das Portrait ein Quadrat. MDT nimmt dieselbe Datei.
    blip.mask = blip:CreateMaskTexture()
    blip.mask:SetAllPoints(blip.portrait)
    blip.mask:SetTexture(MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    blip.portrait:AddMaskTexture(blip.mask)

    blip.ring = blip:CreateTexture(nil, "OVERLAY")
    blip.ring:SetPoint("CENTER")
    blip.ring:SetSize(BLIP_SIZE * 1.4, BLIP_SIZE * 1.4)
    blip.ring:SetTexture(ATLAS)
    blip.ring:SetTexCoord(unpack(RING))

    blip:SetScript("OnEnter", function(self)
        if MV.onEnemyEnter and self.npcId then
            MV.onEnemyEnter(self, self.challengeModeId, self.npcId)
        end
        MV.HighlightPull(self.pull)
        if MV.onPullEnter then MV.onPullEnter(self.pull) end
    end)
    blip:SetScript("OnLeave", function()
        if MV.onEnemyLeave then MV.onEnemyLeave() end
        MV.HighlightPull(nil)
        if MV.onPullLeave then MV.onPullLeave() end
    end)

    panel.blips[index] = blip
    return blip
end

---Erzeugt eine Pullnummer aus dem Vorrat.
---@param index number
---@return table
local function acquireLabel(index)
    local label = panel.labels[index]
    if label then return label end

    -- Auf der Beschriftungsebene, nicht auf der Karte: sonst verschwindet die
    -- Ziffer hinter den Blips, die genau dort stehen.
    label = panel.overlay:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetShadowColor(0, 0, 0, 1)
    label:SetShadowOffset(1, -1)
    panel.labels[index] = label
    return label
end

---Erzeugt eine Verbindungslinie aus dem Vorrat.
---@param index number
---@return table
local function acquireLink(index)
    local link = panel.links[index]
    if link then return link end

    link = panel.canvas:CreateLine(nil, "ARTWORK")
    link:SetThickness(2)
    link:SetColorTexture(1, 1, 1, 0.35)
    panel.links[index] = link
    return link
end

--------------------------------------------------------------------------
-- Anordnung
--------------------------------------------------------------------------

---Setzt die Groesse des Sichtfensters. Die Karte behaelt ihr
---Seitenverhaeltnis, egal wie MDTs Fenster gerade steht.
local function layoutViewport()
    local w = panel:GetWidth()
    local h = (panel:GetHeight() or 0) - BAR_SPACE
    if not w or w <= 0 or h <= 0 then return end

    local vw = math.min(w, h * ASPECT)
    panel.viewport:SetSize(vw, vw / ASPECT)
end

---Legt Kacheln, Blips, Linien und Nummern auf die aktuelle Zoomstufe.
local function layoutCanvas()
    local vw = panel.viewport:GetWidth()
    if not vw or vw <= 0 then return end

    local canvasW = vw * panel.zoom
    local tile    = canvasW / COLS
    panel.canvas:SetSize(canvasW, tile * ROWS)

    for row = 1, ROWS do
        for col = 1, COLS do
            local t = panel.tiles[(row - 1) * COLS + col]
            t:SetSize(tile, tile)
            t:ClearAllPoints()
            t:SetPoint("TOPLEFT", panel.canvas, "TOPLEFT", (col - 1) * tile, -(row - 1) * tile)
        end
    end

    local s = canvasW / MDT_WIDTH

    for i = 1, panel.blipCount do
        local blip = panel.blips[i]
        blip:ClearAllPoints()
        blip:SetPoint("CENTER", panel.canvas, "TOPLEFT", blip.mapX * s, blip.mapY * s)
    end

    local placed, labelIndex, linkIndex = {}, 0, 0
    local prevX, prevY

    for k, centre in ipairs(panel.centres) do
        local index, cx, cy = centre[1], centre[2] * s, centre[3] * s

        if prevX then
            linkIndex = linkIndex + 1
            local link = acquireLink(linkIndex)
            link:SetStartPoint("TOPLEFT", panel.canvas, prevX, prevY)
            link:SetEndPoint("TOPLEFT", panel.canvas, cx, cy)
            link:Show()
        end
        prevX, prevY = cx, cy

        -- Bei vielen Pulls passen nicht alle Nummern nebeneinander. Erste und
        -- letzte stehen immer, der Rest nur mit genug Abstand - beim
        -- Hineinzoomen kommen die fehlenden von selbst dazu.
        local must = (k == 1 or k == #panel.centres)
        local room = true
        if not must then
            for _, p in ipairs(placed) do
                if math.abs(p[1] - cx) < LABEL_GAP and math.abs(p[2] - cy) < LABEL_GAP then
                    room = false
                    break
                end
            end
        end

        if must or room then
            labelIndex = labelIndex + 1
            local label = acquireLabel(labelIndex)
            label:SetText(tostring(index))
            label:SetTextColor(centre[4], centre[5], centre[6])
            label:ClearAllPoints()
            label:SetPoint("CENTER", panel.overlay, "TOPLEFT", cx, cy)
            label:Show()
            placed[#placed + 1] = { cx, cy }
        end
    end

    for i = labelIndex + 1, #panel.labels do panel.labels[i]:Hide() end
    for i = linkIndex + 1, #panel.links do panel.links[i]:Hide() end
end

---Schiebt die Karte im Sichtfenster und haelt sie darin.
---@param ox number|nil neue Verschiebung, sonst die bestehende nachziehen
---@param oy number|nil
local function pan(ox, oy)
    local vw, vh = panel.viewport:GetWidth(), panel.viewport:GetHeight()
    local cw, ch = panel.canvas:GetWidth(), panel.canvas:GetHeight()
    if not vw or not cw then return end

    panel.ox = math.max(math.min(ox or panel.ox, 0), math.min(0, vw - cw))
    panel.oy = math.min(math.max(oy or panel.oy, math.min(0, vh - ch)), 0)

    panel.canvas:ClearAllPoints()
    panel.canvas:SetPoint("TOPLEFT", panel.viewport, "TOPLEFT", panel.ox, panel.oy)
end

---Aendert die Zoomstufe und haelt dabei die Bildmitte fest.
---@param delta number
local function zoomBy(delta)
    local target = math.max(ZOOM_MIN, math.min(ZOOM_MAX, panel.zoom + delta))
    if target == panel.zoom then return end

    local vw, vh = panel.viewport:GetWidth(), panel.viewport:GetHeight()
    local cw, ch = panel.canvas:GetWidth(), panel.canvas:GetHeight()

    -- Welcher Punkt der Karte liegt gerade in der Mitte? Der soll dort
    -- bleiben, sonst springt beim Zoomen der Ausschnitt.
    local fx = (cw and cw > 0) and (-panel.ox + vw / 2) / cw or 0.5
    local fy = (ch and ch > 0) and (-panel.oy + vh / 2) / ch or 0.5

    panel.zoom = target
    layoutCanvas()

    local nw, nh = panel.canvas:GetWidth(), panel.canvas:GetHeight()
    pan(-(fx * nw - vw / 2), -(fy * nh - vh / 2))
    panel.zoomLabel:SetText(("%.0f %%"):format(panel.zoom * 100))
end

--------------------------------------------------------------------------
-- Inhalt
--------------------------------------------------------------------------

---Legt die Kacheln einer Unterebene auf.
---@param dungeon table
---@param level number
---@return boolean ok
local function applyTiles(dungeon, level)
    local map = dungeon.maps and dungeon.maps[level]
    if not map or not map.path then
        for _, tile in ipairs(panel.tiles) do tile:Hide() end
        return false
    end

    for index, tile in ipairs(panel.tiles) do
        tile:SetTexture(map.path .. "\\" .. level .. "_" .. index .. ".png")
        tile:Show()
    end
    return true
end

---Baut Blips, Pullmitten und Nummern fuer die aktuelle Route.
---@return boolean ok
local function build()
    local dungeon = route and ns.GetDungeon(route.challengeModeId)
    local enemies = route and ns.GetDungeonEnemies(route.challengeModeId)
    if not dungeon or not enemies then return false end

    -- Zuordnung Gegner/Klon -> Pull. Was nicht darin steht, gehoert nicht zur
    -- Route und wird blass gezeigt.
    local pullOf = {}
    local total = #route.pulls
    local counts = {}

    for i, pull in ipairs(route.pulls) do
        for _, entry in ipairs(pull.enemies or {}) do
            local enemy = enemies[entry.enemy]
            local pos = enemy and enemy.pos
            for _, cloneIdx in ipairs(entry.clones or {}) do
                pullOf[entry.enemy .. ":" .. cloneIdx] = i
                local p = pos and pos[cloneIdx]
                if p then
                    local level = p[3] or 1
                    counts[level] = (counts[level] or 0) + 1
                end
            end
        end
    end

    -- Ebene mit den meisten Gegnern der Route zeigen. Ein Ausschnitt ist
    -- ehrlicher als eine Karte, auf der die Haelfte der Punkte fehlt.
    local sublevel, best, levels = 1, -1, 0
    for level, count in pairs(counts) do
        levels = levels + 1
        if count > best then sublevel, best = level, count end
    end

    if not applyTiles(dungeon, sublevel) then return false end

    -- Blips fuer alle Gegner des Dungeons, nicht nur die der Route. Erst
    -- daran sieht man, was eine Route auslaesst - beim Vergleich zweier
    -- Routen ist genau das die interessante Frage.
    local index = 0
    local sums = {}
    local baseLevel = panel.canvas:GetFrameLevel()

    for enemyIdx, enemy in pairs(enemies) do
        local npc = ns.GetNpc(route.challengeModeId, enemy.npc)
        for cloneKey, p in pairs(enemy.pos or {}) do
            if (p[3] or 1) == sublevel then
                index = index + 1
                local blip = acquireBlip(index)

                blip.mapX, blip.mapY = p[1], p[2]
                blip.npcId = enemy.npc
                blip.challengeModeId = route.challengeModeId

                if npc and npc.displayId then
                    SetPortraitTextureFromCreatureDisplayID(blip.portrait, npc.displayId)
                else
                    blip.portrait:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
                end

                local pull = pullOf[enemyIdx .. ":" .. cloneKey]
                blip.pull = pull

                if pull then
                    local t = total > 1 and (pull - 1) / (total - 1) or 0
                    local r, g, b = pullColor(t)
                    blip.ring:SetVertexColor(r, g, b, 1)
                    blip.portrait:SetVertexColor(1, 1, 1, 1)
                    blip:SetAlpha(1)
                    blip:SetFrameLevel(baseLevel + 5)

                    local sum = sums[pull]
                    if not sum then
                        sum = { 0, 0, 0, r, g, b }
                        sums[pull] = sum
                    end
                    sum[1] = sum[1] + p[1]
                    sum[2] = sum[2] + p[2]
                    sum[3] = sum[3] + 1
                else
                    blip.ring:SetVertexColor(0.35, 0.35, 0.35, 1)
                    blip.portrait:SetVertexColor(0.45, 0.45, 0.45, 1)
                    blip:SetAlpha(DIM_ALPHA)
                    blip:SetFrameLevel(baseLevel + 1)
                end

                blip.glow:Hide()
                blip:Show()
            end
        end
    end

    for i = index + 1, #panel.blips do panel.blips[i]:Hide() end
    panel.blipCount = index

    -- Dichte Liste der Pullmitten: { Pullnummer, x, y, r, g, b }. Pulls ohne
    -- Gegner auf dieser Ebene fallen dabei heraus, und genau deshalb ist die
    -- Liste dicht - eine Luecke haette #centres unbrauchbar gemacht.
    wipe(panel.centres)
    for i = 1, total do
        local sum = sums[i]
        if sum and sum[3] > 0 then
            panel.centres[#panel.centres + 1] =
                { i, sum[1] / sum[3], sum[2] / sum[3], sum[4], sum[5], sum[6] }
        end
    end

    local map = dungeon.maps[sublevel]
    panel.caption:SetText(("%s%s|r%s"):format(
        T:Hex("textPrimary"), route.title or route.id,
        levels > 1
            and (T:Hex("textMuted") .. "   " ..
                 ns.L["MAP_FLOOR"]:format(map and map.name or tostring(sublevel)) .. "|r")
            or ""))

    return true
end

--------------------------------------------------------------------------
-- Schnittstelle
--------------------------------------------------------------------------

---Hebt einen Pull hervor: seine Gegner leuchten, alle anderen treten zurueck.
---Wird auch von der Pull-Liste rechts aufgerufen.
---@param index number|nil nil hebt die Hervorhebung auf
function MV.HighlightPull(index)
    if not panel or panel.highlighted == index then return end
    panel.highlighted = index

    for i = 1, panel.blipCount do
        local blip = panel.blips[i]
        local base = blip.pull and 1 or DIM_ALPHA
        if index == nil then
            blip:SetAlpha(base)
            blip.glow:Hide()
        elseif blip.pull == index then
            blip:SetAlpha(1)
            blip.glow:Show()
        else
            blip:SetAlpha(base * MUTE_ALPHA)
            blip.glow:Hide()
        end
    end
end

---Zeigt eine Route auf der Karte.
---@param newRoute table|nil
---@return boolean ok false, wenn es dazu keine Kartendaten gibt
function MV.SetRoute(newRoute)
    if not panel then return false end

    -- Dieselbe Route nicht neu aufbauen. Die Oberflaeche zeichnet sich bei
    -- jeder Kleinigkeit neu; zweihundert Blips jedes Mal neu zu setzen waere
    -- Verschwendung, und die Zoomstufe des Nutzers ginge dabei verloren.
    local key = newRoute and (newRoute.id .. ":" .. #newRoute.pulls) or nil
    if key and key == panel.routeKey and panel.blipCount > 0 then
        route = newRoute
        return true
    end
    panel.routeKey = key

    route = newRoute
    if not route or not build() then
        route = nil
        panel.blipCount = 0
        for _, blip in ipairs(panel.blips) do blip:Hide() end
        panel.caption:SetText("")
        panel.viewport:Hide()
        panel.empty:Show()
        return false
    end

    panel.empty:Hide()
    panel.viewport:Show()
    panel.zoom = ZOOM_MIN
    panel.ox, panel.oy = 0, 0
    panel.highlighted = nil
    panel.zoomLabel:SetText(("%.0f %%"):format(panel.zoom * 100))

    layoutViewport()
    layoutCanvas()
    pan(0, 0)
    return true
end

---Ist die Kartenansicht sichtbar?
---@return boolean
function MV.IsShown()
    return panel ~= nil and panel:IsShown()
end

---Blendet die Kartenansicht ein oder aus.
---@param shown boolean
function MV.SetShown(shown)
    if not panel then return end
    panel:SetShown(shown and true or false)
end

---Baut die Ansicht. Einmal beim Aufbau der Sektion aufgerufen.
---@param parent table Wurzelrahmen des Listenbereichs
---@param anchorTop table Rahmen, unter dem die Karte beginnt
---@param padding number
---@param bottomInset number
---@return table panel
function MV.Build(parent, anchorTop, padding, bottomInset)
    if panel then return panel end

    local p = CreateFrame("Frame", nil, parent)
    p:SetPoint("TOPLEFT", anchorTop, "BOTTOMLEFT", 0, -6)
    p:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -padding, bottomInset)
    p:Hide()

    p.zoom, p.ox, p.oy = ZOOM_MIN, 0, 0
    p.blips, p.labels, p.links, p.centres = {}, {}, {}, {}
    p.blipCount = 0

    -- Frueh setzen: OnSizeChanged kann feuern, waehrend hier noch gebaut wird,
    -- und die Anordnungsfunktionen greifen auf diese Variable zu.
    panel = p

    p.caption = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    p.caption:SetPoint("TOPLEFT", p, "TOPLEFT", 2, -2)
    p.caption:SetPoint("TOPRIGHT", p, "TOPRIGHT", -2, -2)
    p.caption:SetJustifyH("LEFT")
    p.caption:SetWordWrap(false)

    -- Sichtfenster: schneidet die Karte ab, damit sie beim Zoomen nicht ueber
    -- Ueberschrift und Knopfleiste laeuft.
    local viewport = CreateFrame("Frame", nil, p)
    viewport:SetPoint("TOP", p.caption, "BOTTOM", 0, -4)
    viewport:SetClipsChildren(true)
    viewport:EnableMouse(true)
    viewport:EnableMouseWheel(true)
    p.viewport = viewport

    viewport.ground = viewport:CreateTexture(nil, "BACKGROUND", nil, -2)
    viewport.ground:SetAllPoints()
    viewport.ground:SetColorTexture(T:Color("bgInset", 1))

    local canvas = CreateFrame("Frame", nil, viewport)
    canvas:SetPoint("TOPLEFT", viewport, "TOPLEFT", 0, 0)
    p.canvas = canvas

    -- Eigene Ebene fuer die Pullnummern. Blips sind Rahmen und liegen damit
    -- ueber jeder Textur der Karte - eine Ziffer auf der Karte selbst waere
    -- ausgerechnet in der Pullmitte verdeckt.
    local overlay = CreateFrame("Frame", nil, canvas)
    overlay:SetAllPoints(canvas)
    overlay:SetFrameLevel(canvas:GetFrameLevel() + 20)
    p.overlay = overlay

    p.tiles = {}
    for row = 1, ROWS do
        for col = 1, COLS do
            p.tiles[(row - 1) * COLS + col] = canvas:CreateTexture(nil, "BACKGROUND", nil, 0)
        end
    end

    viewport:SetScript("OnMouseWheel", function(_, delta)
        zoomBy(delta > 0 and ZOOM_STEP or -ZOOM_STEP)
    end)

    -- Ziehen zum Verschieben. Gerechnet wird gegen die letzte Cursorposition
    -- statt gegen einen Startpunkt: so bleibt die Karte auch dann unter dem
    -- Zeiger, wenn sie zwischendurch am Rand angeschlagen ist.
    viewport:SetScript("OnMouseDown", function(self, button)
        if button ~= "LeftButton" then return end
        local scale = self:GetEffectiveScale()
        local x, y = GetCursorPosition()
        self.dragX, self.dragY = x / scale, y / scale
        self.dragging = true
    end)
    viewport:SetScript("OnMouseUp", function(self) self.dragging = false end)
    viewport:SetScript("OnHide", function(self) self.dragging = false end)
    viewport:SetScript("OnUpdate", function(self)
        if not self.dragging then return end
        local scale = self:GetEffectiveScale()
        local x, y = GetCursorPosition()
        x, y = x / scale, y / scale
        pan(p.ox + (x - self.dragX), p.oy + (y - self.dragY))
        self.dragX, self.dragY = x, y
    end)

    p:SetScript("OnSizeChanged", function()
        layoutViewport()
        layoutCanvas()
        pan()
    end)

    local zoomIn = T:Button(p, "+", 26)
    zoomIn:SetHeight(20)
    zoomIn:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -2, 2)
    zoomIn:SetScript("OnClick", function() zoomBy(ZOOM_STEP) end)

    local zoomOut = T:Button(p, "-", 26)
    zoomOut:SetHeight(20)
    zoomOut:SetPoint("RIGHT", zoomIn, "LEFT", -4, 0)
    zoomOut:SetScript("OnClick", function() zoomBy(-ZOOM_STEP) end)

    p.zoomLabel = p:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    p.zoomLabel:SetPoint("RIGHT", zoomOut, "LEFT", -8, 0)
    p.zoomLabel:SetText("100 %")

    p.hint = p:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    p.hint:SetPoint("BOTTOMLEFT", p, "BOTTOMLEFT", 2, 7)
    p.hint:SetText(ns.L["MAPVIEW_HINT"])

    p.empty = p:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    p.empty:SetPoint("CENTER", p, "CENTER", 0, 0)
    p.empty:SetText(ns.L["MAPVIEW_EMPTY"])
    p.empty:Hide()

    return p
end
