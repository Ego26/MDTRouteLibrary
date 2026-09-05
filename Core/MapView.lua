-- Kartenvorschau: faehrt man ueber eine Route, geht die Dungeonkarte auf.
-- Man kann mit der Maus hinein, zoomen, schieben und Gegner anfassen.
--
-- Warum nachgebaut und nicht MDTs eigene benutzt: MDTs Plugin-Schnittstelle
-- kennt sechs Methoden (RegisterNavigationSection, GetCurrentSection,
-- SetCurrentSection, GetNavigationSectionContentFrame, HideAllDialogs,
-- RegisterDungeonData). Keine davon zeichnet eine Karte, und MDTs Karte gibt
-- es nur einmal - fest an MDT.main_frame gebunden. Sie hierher zu holen ginge
-- nur ueber MDTs Interna, und davon haelt sich dieses Addon fern.
--
-- Was wir stattdessen benutzen, ist alles oeffentlich: MDTs Kacheln liegen als
-- Dateien im Addonordner, die Gegnerbilder kommen aus Blizzards
-- SetPortraitTextureFromCreatureDisplayID, und die Koordinaten stecken im
-- Datenpaket. Ring und Leuchten sind dieselben Ausschnitte aus MDTs
-- Texturatlas, die MDT selbst dafuer nimmt - damit sieht es aus wie dort.
--
-- Was hier bewusst fehlt: Patrouillenwege, Sichtlinien, Interessenpunkte,
-- Bossflaechen. Wer das braucht, klickt "In MDT oeffnen" und bekommt MDTs
-- echte Ansicht. Diese hier beantwortet eine Frage: wo laeuft die Route lang,
-- und was liegt in welchem Pull.

local _, ns = ...

local MV = {}
ns.MapView = MV

local T = ns.Theme

-- MDTs Kartenraum bei scale 1. Zehn quadratische Kachelreihen zu Breite/15
-- ergeben 560, nicht die 555 des Fensters - fuer die Umrechnung zaehlt die
-- Kachelgeometrie.
local MDT_WIDTH  = 840
local COLS, ROWS = 15, 10
local ASPECT     = COLS / ROWS -- 1.5

-- MDTs Texturatlas. Dieselben Ausschnitte benutzt MDT fuer seine Blips.
local ATLAS = "Interface\\AddOns\\MythicDungeonTools\\Textures\\UI-EncounterJournalTextures"
local RING  = { 0.85, 0.97, 0.43, 0.4865 }
local GLOW  = { 0.69, 0.81, 0.39, 0.333 }
local MASK  = "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask"

local VIEW_W  = 480
local VIEW_H  = VIEW_W / ASPECT -- 320
local PADDING = 10
local HEAD_H  = 18
local FOOT_H  = 22

local BLIP_SIZE = 15
local LABEL_GAP = 22

-- Umriss um einen Pull. Der Abstand ist der halbe Blip plus etwas Luft,
-- damit die Linie nicht auf den Bildern klebt. RING_STEPS bestimmt, wie rund
-- die Ecken werden: jeder Gegner steuert so viele Punkte bei, aus denen die
-- Huelle gebildet wird. Sechs reichen - mehr Punkte heisst mehr Linien.
local HULL_PAD   = BLIP_SIZE / 2 + 5
local HULL_ALPHA = 0.85
local RING_STEPS = 6

-- Blasse Darstellung fuer Gegner, die nicht zur Route gehoeren.
local DIM_ALPHA  = 0.5
local MUTE_ALPHA = 0.3

local ZOOM_MIN, ZOOM_MAX, ZOOM_STEP = 1, 4, 0.5

-- Verweilzeit, bevor die Karte aufgeht. Ohne die flackerte beim Scrollen
-- durch die Liste bei jeder Zeile ein grosses Fenster auf.
local DELAY = 0.3

-- Nachlauf, bevor sie wieder zugeht. Der Weg von der Zeile zur Karte und von
-- der Karte zur Pull-Liste fuehrt ueber ein paar Pixel, die zu keinem von
-- beiden gehoeren; ohne Nachlauf faellt sie einem dabei zu.
local GRACE = 0.4

local panel   -- die ganze Ansicht
local route   -- aktuell gezeigte Route
local pending -- laufender Timer
local keepOpen = {} -- Rahmen, ueber denen die Karte offen bleibt

--------------------------------------------------------------------------
-- Farben
--------------------------------------------------------------------------

-- MDTs Palette "High Contrast" (Modules/Pulls.lua, colorPaletteValues[4]).
-- Es ist die, die MDT ab Werk benutzt, und sie wird genauso durchgezaehlt:
-- Pull 12 bekommt wieder die Farbe von Pull 1. Ein Verlauf ueber die ganze
-- Route sieht zwar huebsch aus, aber zwei benachbarte Pulls unterscheiden
-- sich darin kaum - und genau die will man trennen.
local PALETTE = {
    { 1.0000, 0.2446, 1.0000 },
    { 0.2446, 1.0000, 0.6223 },
    { 1.0000, 0.2446, 0.2446 },
    { 0.2446, 0.6223, 1.0000 },
    { 1.0000, 0.9874, 0.2446 },
    { 0.2446, 1.0000, 0.2446 },
    { 1.0000, 0.2446, 0.6223 },
    { 0.2446, 1.0000, 1.0000 },
    { 1.0000, 0.6097, 0.2446 },
    { 0.2446, 0.2446, 1.0000 },
    { 0.6349, 1.0000, 0.2446 },
}

---Wandelt MDTs Farbschreibweise ("228b22") in Anteile um.
---@param hex string|nil
---@return number|nil r, number|nil g, number|nil b
local function hexColor(hex)
    if type(hex) ~= "string" then return nil end
    hex = hex:gsub("^#", "")
    if #hex ~= 6 then return nil end

    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    if not r or not g or not b then return nil end
    return r / 255, g / 255, b / 255
end

---Farbe eines Pulls.
---
---Bringt die Route eigene Farben mit - eigene MDT-Presets tun das -, gelten
---die: dann sieht die Karte hier genauso aus wie in MDT, auch wenn jemand
---dort von Hand gefaerbt hat. Sonst MDTs Palette.
---@param index number Pullnummer
---@param pull table|nil
---@return number r, number g, number b
local function pullColor(index, pull)
    local r, g, b = hexColor(pull and pull.color)
    if r then return r, g, b end

    local colour = PALETTE[(index - 1) % #PALETTE + 1]
    return colour[1], colour[2], colour[3]
end

--------------------------------------------------------------------------
-- Geometrie
--------------------------------------------------------------------------

---Konvexe Huelle einer Punktmenge (Andrew's monotone chain).
---
---Damit umfasst ein Pull seine Gegner, statt sie nur einzufaerben. Zwei
---nebeneinanderliegende Pulls sehen sonst gleich aus, sobald ihre Farben
---nah beieinander liegen - und bei vierzig Pulls tun sie das immer.
---@param points table Liste aus { x, y }
---@return table Ecken im Umlaufsinn
local function convexHull(points)
    local n = #points
    if n < 3 then return points end

    table.sort(points, function(a, b)
        if a[1] ~= b[1] then return a[1] < b[1] end
        return a[2] < b[2]
    end)

    local function cross(o, a, b)
        return (a[1] - o[1]) * (b[2] - o[2]) - (a[2] - o[2]) * (b[1] - o[1])
    end

    local lower = {}
    for i = 1, n do
        while #lower >= 2 and cross(lower[#lower - 1], lower[#lower], points[i]) <= 0 do
            lower[#lower] = nil
        end
        lower[#lower + 1] = points[i]
    end

    local upper = {}
    for i = n, 1, -1 do
        while #upper >= 2 and cross(upper[#upper - 1], upper[#upper], points[i]) <= 0 do
            upper[#upper] = nil
        end
        upper[#upper + 1] = points[i]
    end

    -- Erster und letzter Punkt stehen in beiden Haelften.
    lower[#lower] = nil
    upper[#upper] = nil
    for _, point in ipairs(upper) do lower[#lower + 1] = point end
    return lower
end

--------------------------------------------------------------------------
-- Ziehen
--------------------------------------------------------------------------

---Merkt sich die Cursorposition als Ausgangspunkt einer Zugbewegung.
local function beginDrag()
    local viewport = panel.viewport
    local scale = viewport:GetEffectiveScale()
    local x, y = GetCursorPosition()
    viewport.dragX, viewport.dragY = x / scale, y / scale
    viewport.dragging = true
end

---Beendet die Zugbewegung.
local function endDrag()
    if panel then panel.viewport.dragging = false end
end

---Laeuft waehrend des Ziehens mit: laesst man die Taste ausserhalb des
---Sichtfensters los, bekommt dessen OnMouseUp das nicht mit - die Karte klebte
---sonst am Zeiger, bis man wieder hineinfaehrt.
local function dragStillHeld()
    return IsMouseButtonDown("LeftButton")
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

    -- Ziehen und Anklicken teilen sich die linke Maustaste. Der Blip faengt
    -- den Mausdruck ab, also schiebt er die Karte selbst weiter - und
    -- entscheidet beim Loslassen anhand des zurueckgelegten Weges, ob es ein
    -- Klick war oder ein Zug.
    blip:SetScript("OnMouseDown", function(self, button)
        if button ~= "LeftButton" then return end
        beginDrag()
        self.downX, self.downY = GetCursorPosition()
    end)
    blip:SetScript("OnMouseUp", function(self, button)
        endDrag()
        if button ~= "LeftButton" or not self.downX then return end
        local x, y = GetCursorPosition()
        local moved = math.abs(x - self.downX) + math.abs(y - self.downY)
        self.downX, self.downY = nil, nil
        if moved < 6 and MV.onEnemyClick and self.npcId then
            MV.onEnemyClick(self.challengeModeId, self.npcId, self.pull)
        end
    end)

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

    -- Auf der Beschriftungsebene, nicht auf der Karte: Blips sind Rahmen und
    -- liegen ueber jeder Textur - eine Ziffer auf der Karte selbst waere
    -- ausgerechnet in der Pullmitte verdeckt.
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

---Legt Kacheln, Blips, Linien und Nummern auf die aktuelle Zoomstufe.
local function layoutCanvas()
    local canvasW = VIEW_W * panel.zoom
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

    -- Umrisse. Sie werden hier gerechnet und nicht einmalig beim Aufbau: der
    -- Abstand zur Linie ist ein Bildschirmmass, kein Kartenmass - beim Zoomen
    -- bleiben die Gegnerbilder gleich gross, also muss die Huelle mitwandern.
    local linkIndex = 0
    for _, group in ipairs(panel.groups) do
        local candidates = {}
        for _, point in ipairs(group.points) do
            local px, py = point[1] * s, point[2] * s
            -- Jeder Gegner steuert einen Kranz von Punkten bei. Dadurch
            -- umschliesst die Huelle auch einen einzelnen Gegner sauber,
            -- statt zu einem Punkt zu entarten.
            for step = 1, RING_STEPS do
                local angle = (step - 1) * (2 * math.pi / RING_STEPS)
                candidates[#candidates + 1] = {
                    px + math.cos(angle) * HULL_PAD,
                    py + math.sin(angle) * HULL_PAD,
                }
            end
        end

        local hull = convexHull(candidates)
        for i = 1, #hull do
            local a = hull[i]
            local b = hull[i % #hull + 1]
            linkIndex = linkIndex + 1
            local link = acquireLink(linkIndex)
            link:SetColorTexture(group.r, group.g, group.b, 1)
            link:SetAlpha(HULL_ALPHA)
            link.pull = group.pull
            link:SetStartPoint("TOPLEFT", panel.canvas, a[1], a[2])
            link:SetEndPoint("TOPLEFT", panel.canvas, b[1], b[2])
            link:Show()
        end
    end
    panel.linkCount = linkIndex

    local placed, labelIndex = {}, 0

    for k, centre in ipairs(panel.centres) do
        local index, cx, cy = centre[1], centre[2] * s, centre[3] * s

        -- Bei vierzig Pulls passen nicht alle Nummern nebeneinander. Erste und
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
    local cw, ch = panel.canvas:GetWidth(), panel.canvas:GetHeight()

    -- SetPoint zaehlt y nach oben. Die Karte haengt mit ihrer linken oberen
    -- Ecke an der linken oberen Ecke des Sichtfensters:
    --   ox geht von 0 (linker Rand) bis VIEW_W - cw (rechter Rand), also nach
    --   links ins Negative.
    --   oy geht von 0 (oberer Rand) bis ch - VIEW_H (unterer Rand), also nach
    --   oben ins Positive.
    panel.ox = math.max(math.min(ox or panel.ox, 0), math.min(0, VIEW_W - cw))
    panel.oy = math.min(math.max(oy or panel.oy, 0), math.max(0, ch - VIEW_H))

    panel.canvas:ClearAllPoints()
    panel.canvas:SetPoint("TOPLEFT", panel.viewport, "TOPLEFT", panel.ox, panel.oy)
end

---Aendert die Zoomstufe und haelt dabei den Punkt unter dem Zeiger fest.
---@param delta number
local function zoomBy(delta)
    local target = math.max(ZOOM_MIN, math.min(ZOOM_MAX, panel.zoom + delta))
    if target == panel.zoom then return end

    local cw, ch = panel.canvas:GetWidth(), panel.canvas:GetHeight()

    -- Wo im Sichtfenster steht der Zeiger? Der Punkt der Karte unter ihm soll
    -- dort bleiben - so zoomt man dorthin, wo man hinsieht, statt dass der
    -- Ausschnitt wegspringt. Ausserhalb der Karte gilt die Mitte.
    local px, py = VIEW_W / 2, VIEW_H / 2
    if panel.viewport:IsMouseOver() then
        local scale = panel.viewport:GetEffectiveScale()
        local mx, my = GetCursorPosition()
        px = mx / scale - panel.viewport:GetLeft()
        py = panel.viewport:GetTop() - my / scale
    end

    -- Welcher Punkt der Karte liegt unter dem Zeiger? Waagerecht px - ox,
    -- senkrecht py + oy - siehe die Vorzeichen in pan().
    local fx = cw > 0 and (px - panel.ox) / cw or 0.5
    local fy = ch > 0 and (py + panel.oy) / ch or 0.5

    panel.zoom = target
    layoutCanvas()

    local nw, nh = panel.canvas:GetWidth(), panel.canvas:GetHeight()
    pan(px - fx * nw, fy * nh - py)
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
    local pullOf, counts, colours = {}, {}, {}
    local total = #route.pulls

    for i, pull in ipairs(route.pulls) do
        colours[i] = { pullColor(i, pull) }
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
    -- ehrlicher als eine Karte, auf der die Haelfte der Punkte fehlt und
    -- niemand erfaehrt warum.
    local sublevel, best, levels = 1, -1, 0
    for level, count in pairs(counts) do
        levels = levels + 1
        if count > best then sublevel, best = level, count end
    end

    if not applyTiles(dungeon, sublevel) then return false end

    -- Blips fuer alle Gegner des Dungeons, nicht nur die der Route. Erst
    -- daran sieht man, was eine Route auslaesst - beim Vergleich zweier
    -- Routen ist genau das die interessante Frage.
    local index, sums, groupPoints = 0, {}, {}
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
                    local r, g, b = unpack(colours[pull])
                    blip.ring:SetVertexColor(r, g, b, 1)
                    blip.portrait:SetVertexColor(1, 1, 1, 1)
                    blip:SetAlpha(1)
                    blip:SetFrameLevel(baseLevel + 5)

                    local sum = sums[pull]
                    if not sum then
                        sum = { 0, 0, 0, r, g, b }
                        sums[pull] = sum
                        groupPoints[pull] = {}
                    end
                    sum[1] = sum[1] + p[1]
                    sum[2] = sum[2] + p[2]
                    sum[3] = sum[3] + 1
                    local points = groupPoints[pull]
                    points[#points + 1] = { p[1], p[2] }
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

    -- Dichte Liste der Pullmitten: { Nummer, x, y, r, g, b }. Pulls ohne
    -- Gegner auf dieser Ebene fallen heraus, und genau deshalb ist die Liste
    -- dicht - eine Luecke haette #centres unbrauchbar gemacht.
    wipe(panel.centres)
    wipe(panel.groups)
    for i = 1, total do
        local sum = sums[i]
        if sum and sum[3] > 0 then
            panel.centres[#panel.centres + 1] =
                { i, sum[1] / sum[3], sum[2] / sum[3], sum[4], sum[5], sum[6] }
            panel.groups[#panel.groups + 1] =
                { pull = i, r = sum[4], g = sum[5], b = sum[6], points = groupPoints[i] }
        end
    end

    panel.title:SetText(T:Hex("textPrimary") .. (route.title or route.id) .. "|r")

    -- Die Farbe sagt jetzt nur noch, was zusammengehoert - die Reihenfolge
    -- steht in den Nummern. Also braucht es auch keine Farblegende mehr.
    local footer = ("%s%d %s"):format(T:Hex("textMuted"), total, ns.L["COL_PULLS"])

    if levels > 1 then
        local map = dungeon.maps[sublevel]
        footer = footer .. "  ·  " .. ns.L["MAP_FLOOR"]:format(map and map.name or tostring(sublevel))
    end
    panel.footer:SetText(footer .. "|r")

    return true
end

--------------------------------------------------------------------------
-- Aufbau
--------------------------------------------------------------------------

---Baut den Rahmen beim ersten Aufruf.
---@return table
local function ensurePanel()
    if panel then return panel end

    local p = CreateFrame("Frame", "MDTRouteLibraryMapView", UIParent, "TooltipBorderedFrameTemplate")
    p:SetSize(VIEW_W + PADDING * 2, VIEW_H + PADDING * 2 + HEAD_H + FOOT_H)
    -- Eine Stufe unter TOOLTIP: Blizzards Zaubertooltips sollen darueber
    -- liegen, unsere Gegnervorschau ebenso.
    p:SetFrameStrata("FULLSCREEN_DIALOG")
    -- Anders als ein gewoehnlicher Tooltip nimmt dieser hier die Maus an -
    -- sonst koennte man weder zoomen noch schieben, und das Mausrad ginge an
    -- die Routenliste darunter.
    p:EnableMouse(true)
    p:EnableMouseWheel(true)
    p:Hide()

    p.zoom, p.ox, p.oy = ZOOM_MIN, 0, 0
    p.blips, p.labels, p.links, p.centres, p.groups = {}, {}, {}, {}, {}
    p.blipCount, p.linkCount = 0, 0

    -- Frueh setzen: die Anordnungsfunktionen greifen darauf zu.
    panel = p

    p.title = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    p.title:SetPoint("TOPLEFT", p, "TOPLEFT", PADDING, -PADDING)
    p.title:SetPoint("TOPRIGHT", p, "TOPRIGHT", -PADDING, -PADDING)
    p.title:SetJustifyH("LEFT")
    p.title:SetWordWrap(false)

    -- Sichtfenster: schneidet die Karte ab, damit sie beim Zoomen nicht ueber
    -- Ueberschrift und Fusszeile laeuft.
    local viewport = CreateFrame("Frame", nil, p)
    viewport:SetSize(VIEW_W, VIEW_H)
    viewport:SetPoint("TOPLEFT", p, "TOPLEFT", PADDING, -(PADDING + HEAD_H))
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

    local function onWheel(_, delta) zoomBy(delta > 0 and ZOOM_STEP or -ZOOM_STEP) end
    viewport:SetScript("OnMouseWheel", onWheel)
    p:SetScript("OnMouseWheel", onWheel)

    -- Ziehen zum Verschieben. Gerechnet wird gegen die letzte Cursorposition
    -- statt gegen einen Startpunkt: so bleibt die Karte auch dann unter dem
    -- Zeiger, wenn sie zwischendurch am Rand angeschlagen ist.
    viewport:SetScript("OnMouseDown", function(_, button)
        if button ~= "LeftButton" then return end
        beginDrag()
    end)
    viewport:SetScript("OnMouseUp", endDrag)
    viewport:SetScript("OnHide", function(self) self.dragging = false end)
    viewport:SetScript("OnUpdate", function(self)
        if not self.dragging then return end
        if not dragStillHeld() then
            self.dragging = false
            return
        end
        local scale = self:GetEffectiveScale()
        local x, y = GetCursorPosition()
        x, y = x / scale, y / scale
        pan(p.ox + (x - self.dragX), p.oy + (y - self.dragY))
        self.dragX, self.dragY = x, y
    end)

    p.footer = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    p.footer:SetPoint("TOPLEFT", viewport, "BOTTOMLEFT", 0, -6)
    p.footer:SetJustifyH("LEFT")
    p.footer:SetWordWrap(false)

    p.zoomLabel = p:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    p.zoomLabel:SetPoint("TOPRIGHT", viewport, "BOTTOMRIGHT", 0, -6)
    p.zoomLabel:SetText("100 %")

    -- Selbst aufraeumen. Die Karte bleibt stehen, solange der Zeiger auf ihr
    -- oder auf der Zeile ist, aus der sie kam - sonst waere sie nicht
    -- bedienbar, sie verschwaende beim Hineinfahren.
    p:SetScript("OnUpdate", function(self, elapsed)
        -- Waehrend des Ziehens bleibt sie offen. Wer die Karte schiebt, faehrt
        -- mit gedrueckter Taste zwangslaeufig ueber den Rand hinaus, und dort
        -- ginge sie ihm sonst unter der Hand zu.
        if self.viewport.dragging then
            self.grace = 0
            return
        end

        local owner = self.owner
        if owner and owner:IsVisible() and (owner:IsMouseOver() or self:IsMouseOver()) then
            self.grace = 0
            return
        end

        -- Auch ueber der Detailspalte bleibt sie offen: dort haengt die
        -- Pull-Liste, und ueber deren Zeilen leuchten die Gegner auf der Karte
        -- auf. Ginge die Karte beim Hinuebergehen zu, waere die Verbindung
        -- zwischen beiden nutzlos.
        for _, frame in ipairs(keepOpen) do
            if frame:IsVisible() and frame:IsMouseOver() then
                self.grace = 0
                return
            end
        end

        -- Erst nach dem Nachlauf zu. Ein Pixel neben der Zeile ist keine
        -- Absicht.
        self.grace = (self.grace or 0) + elapsed
        if self.grace >= GRACE then self:Hide() end
    end)

    p:SetScript("OnHide", function(self)
        MV.HighlightPull(nil)
        if MV.onPullLeave then MV.onPullLeave() end
        if MV.onEnemyLeave then MV.onEnemyLeave() end
        self.owner = nil
    end)

    return p
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

    -- Die Umrisse gehen denselben Weg: der gemeinte Pull tritt hervor, die
    -- uebrigen zuruck. Sonst bliebe ein Gewirr aus Linien ueber dem, was man
    -- gerade ansieht.
    for i = 1, panel.linkCount do
        local link = panel.links[i]
        if index == nil then
            link:SetAlpha(HULL_ALPHA)
        elseif link.pull == index then
            link:SetAlpha(1)
        else
            link:SetAlpha(HULL_ALPHA * 0.2)
        end
    end
end

---Haengt die Karte an eine Zeile. Rechtsbuendig zur Zeile, also innerhalb von
---MDTs Fenster: rechts daneben liegen die Addons des Nutzers.
---@param owner table
local function clampBottom()
    local bottom = panel:GetBottom()
    if bottom and bottom < 8 then
        local point, relTo, relPoint, x, y = panel:GetPoint(1)
        panel:ClearAllPoints()
        panel:SetPoint(point, relTo, relPoint, x, y - bottom + 8)
    end
end

local function anchor(owner)
    panel.owner = owner
    panel:ClearAllPoints()
    panel:SetPoint("TOPRIGHT", owner, "TOPRIGHT", -4, 8)
    clampBottom()
end

---Baut die Karte fuer eine Route auf, falls dort nicht schon dieselbe steht.
---@param newRoute table
---@return boolean ok
local function prepare(newRoute)
    if panel:IsShown() and route == newRoute then return true end

    route = newRoute
    if not build() then
        route = nil
        return false
    end

    panel.zoom, panel.ox, panel.oy = ZOOM_MIN, 0, 0
    panel.highlighted = nil
    panel.zoomLabel:SetText("100 %")
    layoutCanvas()
    pan(0, 0)
    return true
end

---Meldet einen Rahmen an, ueber dem die Karte offen bleibt.
---@param frame table
function MV.KeepOpenOver(frame)
    if type(frame) ~= "table" then return end
    for _, existing in ipairs(keepOpen) do
        if existing == frame then return end
    end
    keepOpen[#keepOpen + 1] = frame
end

---Blendet die Karte aus und bricht eine wartende ab.
function MV.Hide()
    if pending then
        pending:Cancel()
        pending = nil
    end
    if panel then panel:Hide() end
end

---Bricht nur eine wartende Karte ab. Eine offene bleibt stehen, damit man
---mit der Maus hineinfahren kann - sie raeumt sich selbst weg.
function MV.Cancel()
    if pending then
        pending:Cancel()
        pending = nil
    end
end

---Zeigt die Karte sofort links neben einem Rahmen.
---
---Fuer die Pull-Liste in der Detailspalte. Die zeigt immer die *gewaehlte*
---Route, die Karte folgte bisher dem Zeiger - wer auf dem Weg nach rechts
---eine andere Zeile streifte, hob dann Pulls in einer Karte hervor, die eine
---ganz andere Route zeigte. Hier gilt deshalb die Auswahl, nicht der Weg
---dorthin. Und ohne Verweilzeit: gewartet hat man schon.
---@param frame table Rahmen, links neben dem die Karte sitzt
---@param newRoute table|nil
function MV.ShowBeside(frame, newRoute)
    MV.Cancel()
    if not frame or not newRoute then return end

    ensurePanel()
    if not prepare(newRoute) then
        panel:Hide()
        return
    end

    panel.owner = frame
    panel:ClearAllPoints()
    panel:SetPoint("TOPRIGHT", frame, "TOPLEFT", -8, 0)
    clampBottom()

    panel.grace = 0
    panel:Show()
end

---Fordert die Karte fuer eine Route an.
---@param owner table Zeile, an der die Karte haengt
---@param newRoute table|nil
function MV.Request(owner, newRoute)
    MV.Cancel()
    if not owner or not newRoute then return end

    -- Schon offen und dieselbe Route: nur neu anhaengen, nicht neu bauen.
    if panel and panel:IsShown() and route == newRoute then
        anchor(owner)
        return
    end

    pending = C_Timer.NewTimer(DELAY, function()
        pending = nil
        -- Der Zeiger kann in der Zwischenzeit weitergewandert sein.
        if not owner:IsVisible() or not owner:IsMouseOver() then return end

        ensurePanel()
        if not prepare(newRoute) then
            panel:Hide()
            return
        end

        anchor(owner)
        panel.grace = 0
        panel:Show()
    end)
end
