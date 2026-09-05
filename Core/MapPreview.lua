-- Kartenvorschau: zeigt beim Ueberfahren einer Route, wo im Dungeon sie
-- langlaeuft - ohne dass man sie erst in MDT laden muss.
--
-- Die Karte selbst zeichnen wir nicht neu. MDT setzt jedes Stockwerk aus
-- 10 x 15 Kacheln zusammen (Midnight/Textures/<Dungeon>/<Ebene>_<n>.png), und
-- genau diese Kacheln zeigen wir hier in klein. Eigene Karten mitzuliefern
-- waere ein Vielfaches der Paketgroesse fuer dasselbe Bild.
--
-- Die Punkte darauf sind die Klone der Route. Ihre Koordinaten stecken im
-- Datenpaket (dungeon.enemies[i].pos), gelesen beim Bauen aus denselben
-- Dateien, die MDT im Spiel benutzt. MDT setzt seine Blips bei
-- (x * scale, y * scale) relativ zur linken oberen Ecke der Karte - wir
-- rechnen mit demselben Bezugssystem, nur mit kleinerem Faktor.

local _, ns = ...

local MP = {}
ns.MapPreview = MP

local T = ns.Theme

-- MDTs Kartenraum bei scale 1. Die Kacheln sind quadratisch (Breite/15),
-- zehn Reihen ergeben also 560 - nicht die 555 des Fensters. Fuer die
-- Umrechnung zaehlt die Kachelgeometrie, nicht die Fensterhoehe.
local MDT_WIDTH = 840

local COLS, ROWS = 15, 10
local TILE       = 24
local MAP_W      = COLS * TILE  -- 360
local MAP_H      = ROWS * TILE  -- 240
local SCALE      = MAP_W / MDT_WIDTH

local PADDING    = 10
local DOT_SIZE   = 5
local DELAY      = 0.35 -- Sekunden Verweilen, bevor die Vorschau aufgeht

-- Obergrenze fuer die Punkte. Keine echte Route kommt in die Naehe; die
-- Grenze schuetzt nur davor, dass ein kaputtes Datenpaket tausende Texturen
-- anlegt.
local MAX_DOTS = 600

local frame
local pending -- laufender Timer

--------------------------------------------------------------------------
-- Farben
--------------------------------------------------------------------------

---Farbe eines Pulls nach seiner Position in der Route: Gruen am Anfang,
---Gold in der Mitte, Rot am Ende. Damit sieht man die Laufrichtung, ohne
---eine einzige Zahl lesen zu muessen.
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
-- Aufbau
--------------------------------------------------------------------------

---Baut den Vorschaurahmen beim ersten Aufruf.
---@return table
local function ensureFrame()
    if frame then return frame end

    local f = CreateFrame("Frame", "MDTRouteLibraryMapPreview", UIParent, "TooltipBorderedFrameTemplate")
    f:SetSize(MAP_W + PADDING * 2, MAP_H + PADDING * 2 + 40)
    -- Eine Stufe unter TOOLTIP, genau wie die Gegnervorschau: Blizzards
    -- eigene Tooltips sollen darueber liegen.
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    f:EnableMouse(false)
    f:Hide()

    -- Selbst aufraeumen. Auf OnLeave der Zeile allein ist kein Verlass: die
    -- Liste wird beim Blaettern neu belegt, und wer MDT mit Escape schliesst,
    -- laesst die Vorschau sonst auf dem leeren Bildschirm stehen.
    f:SetScript("OnUpdate", function(self)
        local owner = self.owner
        if not owner or not owner:IsVisible() or not owner:IsMouseOver() then
            self:Hide()
        end
    end)

    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.title:SetPoint("TOPLEFT", f, "TOPLEFT", PADDING, -PADDING)
    f.title:SetPoint("TOPRIGHT", f, "TOPRIGHT", -PADDING, -PADDING)
    f.title:SetJustifyH("LEFT")
    f.title:SetWordWrap(false)

    f.map = CreateFrame("Frame", nil, f)
    f.map:SetSize(MAP_W, MAP_H)
    f.map:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, -6)

    -- Dunkler Grund. Nicht jede Kachel ist deckend, und ohne Unterlage
    -- schimmert dann der Rahmen durch.
    f.map.bg = f.map:CreateTexture(nil, "BACKGROUND", nil, -1)
    f.map.bg:SetAllPoints()
    f.map.bg:SetColorTexture(T:Color("bgInset", 1))

    -- Die 150 Kacheln. Einmal angelegt, danach nur noch neu belegt.
    f.tiles = {}
    for row = 1, ROWS do
        for col = 1, COLS do
            local tile = f.map:CreateTexture(nil, "BACKGROUND", nil, 0)
            tile:SetSize(TILE, TILE)
            tile:SetPoint("TOPLEFT", f.map, "TOPLEFT", (col - 1) * TILE, -(row - 1) * TILE)
            f.tiles[(row - 1) * COLS + col] = tile
        end
    end

    f.dots  = {}
    f.links = {}

    f.footer = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    f.footer:SetPoint("TOPLEFT", f.map, "BOTTOMLEFT", 0, -6)
    f.footer:SetPoint("RIGHT", f, "RIGHT", -PADDING, 0)
    f.footer:SetJustifyH("LEFT")
    f.footer:SetWordWrap(false)

    frame = f
    return f
end

---Holt den n-ten Punkt aus dem Vorrat.
---@param index number
---@return table
local function acquireDot(index)
    local dot = frame.dots[index]
    if dot then return dot end

    dot = frame.map:CreateTexture(nil, "OVERLAY")
    dot:SetSize(DOT_SIZE, DOT_SIZE)
    frame.dots[index] = dot
    return dot
end

---Holt die n-te Verbindungslinie aus dem Vorrat.
---@param index number
---@return table
local function acquireLink(index)
    local link = frame.links[index]
    if link then return link end

    link = frame.map:CreateLine(nil, "ARTWORK")
    link:SetThickness(1.5)
    link:SetColorTexture(1, 1, 1, 0.30)
    frame.links[index] = link
    return link
end

--------------------------------------------------------------------------
-- Inhalt
--------------------------------------------------------------------------

---Sammelt alle Klonpositionen einer Route, nach Pull gruppiert.
---@param route table
---@return table|nil pulls Liste aus { sublevel -> { {x,y}, ... } }, nil ohne Daten
---@return table counts Anzahl Punkte je Unterebene
local function collectPoints(route)
    local enemies = ns.GetDungeonEnemies(route.challengeModeId)
    if not enemies then return nil, {} end

    local pulls, counts = {}, {}
    local any = false

    for i, pull in ipairs(route.pulls or {}) do
        local points = {}
        for _, entry in ipairs(pull.enemies or {}) do
            local enemy = enemies[entry.enemy]
            local pos = enemy and enemy.pos
            if pos then
                for _, cloneIdx in ipairs(entry.clones or {}) do
                    local p = pos[cloneIdx]
                    if p then
                        local sublevel = p[3] or 1
                        points[#points + 1] = { x = p[1], y = p[2], sublevel = sublevel }
                        counts[sublevel] = (counts[sublevel] or 0) + 1
                        any = true
                    end
                end
            end
        end
        pulls[i] = points
    end

    if not any then return nil, counts end
    return pulls, counts
end

---Legt die Kacheln einer Unterebene auf.
---@param dungeon table
---@param sublevel number
---@return boolean ok
local function applyTiles(dungeon, sublevel)
    local map = dungeon.maps and dungeon.maps[sublevel]
    if not map or not map.path then
        for _, tile in ipairs(frame.tiles) do tile:Hide() end
        return false
    end

    for index, tile in ipairs(frame.tiles) do
        tile:SetTexture(map.path .. "\\" .. sublevel .. "_" .. index .. ".png")
        tile:Show()
    end
    return true
end

---Fuellt die Vorschau mit einer Route.
---@param route table
---@return boolean ok false, wenn es dazu keine Kartendaten gibt
local function fill(route)
    local dungeon = ns.GetDungeon(route.challengeModeId)
    if not dungeon or not dungeon.maps then return false end

    local pulls, counts = collectPoints(route)
    if not pulls then return false end

    -- Bei mehreren Stockwerken zeigen wir das, auf dem die Route am meisten
    -- Gegner hat. Ein Ausschnitt ist ehrlicher als eine Karte, auf der die
    -- Haelfte der Punkte fehlt und niemand erfaehrt warum.
    local sublevel, best, levels = 1, -1, 0
    for level, count in pairs(counts) do
        levels = levels + 1
        if count > best then sublevel, best = level, count end
    end

    if not applyTiles(dungeon, sublevel) then return false end

    local total = #pulls
    local dotIndex, linkIndex = 0, 0
    local prevX, prevY

    for i, points in ipairs(pulls) do
        local t = total > 1 and (i - 1) / (total - 1) or 0
        local r, g, b = pullColor(t)
        local sumX, sumY, n = 0, 0, 0

        for _, point in ipairs(points) do
            if point.sublevel == sublevel then
                local px, py = point.x * SCALE, point.y * SCALE
                sumX, sumY, n = sumX + px, sumY + py, n + 1

                if dotIndex < MAX_DOTS then
                    dotIndex = dotIndex + 1
                    local dot = acquireDot(dotIndex)
                    dot:SetColorTexture(r, g, b, 1)
                    dot:ClearAllPoints()
                    dot:SetPoint("CENTER", frame.map, "TOPLEFT", px, py)
                    dot:Show()
                end
            end
        end

        -- Linie von Pull zu Pull, jeweils durch die Mitte der Gruppe. Das ist
        -- nicht der Laufweg, aber es zeigt die Reihenfolge - und mehr wissen
        -- wir ueber den Weg auch gar nicht.
        if n > 0 then
            local cx, cy = sumX / n, sumY / n
            if prevX then
                linkIndex = linkIndex + 1
                local link = acquireLink(linkIndex)
                link:SetStartPoint("TOPLEFT", frame.map, prevX, prevY)
                link:SetEndPoint("TOPLEFT", frame.map, cx, cy)
                link:Show()
            end
            prevX, prevY = cx, cy
        end
    end

    for i = dotIndex + 1, #frame.dots do frame.dots[i]:Hide() end
    for i = linkIndex + 1, #frame.links do frame.links[i]:Hide() end

    frame.title:SetText(T:Hex("textPrimary") .. (route.title or "?") .. "|r")

    -- Legende zur Farbfolge. Der Pfeil braucht keine Uebersetzung.
    local footer = ("%s%s|r  →  %s%s|r"):format(
        T:Hex("success"), ns.L["MAP_START"],
        T:Hex("danger"), ns.L["MAP_END"]
    )
    -- Bei mehrstoeckigen Dungeons sagen wir dazu, welches Stockwerk man sieht.
    if levels > 1 then
        local map = dungeon.maps[sublevel]
        footer = footer .. T:Hex("textMuted") .. "  ·  "
            .. ns.L["MAP_FLOOR"]:format(map and map.name or tostring(sublevel)) .. "|r"
    end
    frame.footer:SetText(footer)

    return true
end

--------------------------------------------------------------------------
-- Schnittstelle
--------------------------------------------------------------------------

---Haengt die Vorschau an eine Zeile. Sie geht nach rechts auf, weicht aber
---nach links aus, wenn dort der Bildschirm zu Ende ist.
---@param owner table
local function anchor(owner)
    frame.owner = owner
    frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", owner, "TOPRIGHT", 8, 8)

    local right = frame:GetRight()
    if right and right > UIParent:GetRight() then
        frame:ClearAllPoints()
        frame:SetPoint("TOPRIGHT", owner, "TOPLEFT", -8, 8)
    end

    -- Nach unten darf sie auch nicht aus dem Bild laufen.
    local bottom = frame:GetBottom()
    if bottom and bottom < 0 then
        local point, relTo, relPoint, x, y = frame:GetPoint(1)
        frame:ClearAllPoints()
        frame:SetPoint(point, relTo, relPoint, x, y - bottom + 8)
    end
end

---Blendet die Vorschau aus und bricht eine wartende ab.
function MP.Hide()
    if pending then
        pending:Cancel()
        pending = nil
    end
    if frame then frame:Hide() end
end

---Fordert die Vorschau fuer eine Route an.
---
---Sie geht erst nach einer kurzen Verzoegerung auf. Ohne die flackerte beim
---Scrollen durch die Liste bei jeder Zeile ein grosses Fenster auf.
---@param owner table Zeile, an der die Vorschau haengt
---@param route table
function MP.Request(owner, route)
    MP.Hide()
    if not owner or not route then return end

    pending = C_Timer.NewTimer(DELAY, function()
        pending = nil
        -- Die Maus kann in der Zwischenzeit weitergewandert sein.
        if not owner:IsVisible() or not owner:IsMouseOver() then return end

        ensureFrame()
        if not fill(route) then
            frame:Hide()
            return
        end

        anchor(owner)
        frame:Show()
    end)
end
