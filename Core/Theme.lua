-- Die visuelle Sprache von MDTRouteLibrary.
--
-- Ausrichtung: MDT, nicht etwas Eigenes. Der Browser liegt ueber MDTs
-- Fenster, zwischen MDTs eigenen Leisten - ein fremdes Design waere dort ein
-- Stilbruch, egal wie huebsch es fuer sich genommen waere.
--
-- Seit 6.3.10 zeichnet MDT mit einem eigenen UI-Kit (MythicDungeonTools_UI,
-- Kit/Theme.lua): flache Flaechen in kuehlem Anthrazit, Raender genau ein
-- Bildschirmpixel breit, Weiss statt Gold als Hervorhebung, Archivo Narrow
-- als Schrift. Dieses Kit ist privat - MDT gibt sein Addon-Objekt nicht
-- heraus. Die Farbwerte stehen deshalb hier noch einmal, Token fuer Token
-- uebernommen. Die Schriften dagegen legt MDT global an (MDTFont_<Rolle>);
-- die werden direkt benutzt, samt einer Schrift, die der Spieler in MDTs
-- Einstellungen gewaehlt hat.
--
-- Kein Farbwert und keine Rahmenstaerke steht sonst irgendwo im Code. Wenn
-- MDT sein Aussehen wieder aendert, ist hier die einzige Stelle, die
-- nachgezogen werden muss.

local _, ns = ...

local Theme = {}
ns.Theme = Theme

--------------------------------------------------------------------------
-- Farbtokens
--------------------------------------------------------------------------

-- Die Werte aus MDTs Kit/Theme.lua, unter den Namen, die dieser Code schon
-- vorher benutzte. Daneben, in Klammern, MDTs eigener Tokenname.
local PALETTE = {
    bgBase       = "111113", -- bg.panel
    bgInset      = "0B0B0C", -- bg.sunken
    bgRaised     = "17171A", -- bg.raised
    bgRaised2    = "1B1B1F", -- bg.raised2
    bgOverlay    = "141417", -- bg.overlay
    bgHover      = "313135", -- bg.hover: bg.raised2, 8 % Richtung Weiss
    bgPressed    = "161619", -- bg.pressed: bg.raised, 4 % Richtung Schwarz
    bgSelected   = "2A2A2D", -- bg.selected: bg.raised, 8 % Richtung accent

    borderSubtle  = "2B2B30", -- border.normal
    borderStrong  = "303036", -- border.strong
    borderDivider = "1F1F23", -- border.divider

    textPrimary   = "E9E6E1", -- text.normal
    textSecondary = "CFCAC2", -- text.secondary
    textMuted     = "8E8A84", -- text.muted
    textDisabled  = "55534F", -- text.disabled
    textInverse   = "111113", -- text.inverse

    accent        = "FFFFFF", -- accent
    accentHover   = "FFFFFF",
    accentBg      = "26262B", -- accent.bg
    accentBgHover = "3A3A3F", -- accent.bgHover
    accentBorder  = "4A4A52", -- accent.border

    success       = "5EE07A", -- ok
    danger        = "FF6B5B", -- warn
    dangerBg      = "3A1416", -- danger.bg
    dangerBorder  = "5A2626", -- danger.border
    barProgress   = "2F5FC4", -- bar.progress

    -- Kennt MDT nicht: "knapp", "sicher" und "ueber der Zeit". Rot waere
    -- zu laut fuer etwas, das nur zur Vorsicht mahnt.
    warning       = "E8B04B",
}

-- MDTs Waschungen: Weiss mit wenig Deckkraft ueber dem, was darunter liegt.
-- So zeigt MDT Hover und Auswahl auf rahmenlosen Flaechen und in seiner
-- Symbolleiste.
Theme.tint = {
    hover    = 0.08, -- bg.hoverTint  ffffff14
    selected = 0.14, -- bg.selectedTint ffffff24
}

Theme.tokens = {}

local function hexToParts(hex)
    return tonumber(hex:sub(1, 2), 16) / 255,
           tonumber(hex:sub(3, 4), 16) / 255,
           tonumber(hex:sub(5, 6), 16) / 255
end

for name, hex in pairs(PALETTE) do
    local r, g, b = hexToParts(hex)
    Theme.tokens[name] = { r = r, g = g, b = b, hex = hex }
end

---Farbe eines Tokens.
---@param token string
---@param alpha number|nil
---@return number r, number g, number b, number a
function Theme:Color(token, alpha)
    local colour = self.tokens[token] or self.tokens.textPrimary
    return colour.r, colour.g, colour.b, alpha or 1
end

---Farbcode fuer Text, z. B. "|cffe9e6e1".
---@param token string
---@return string
function Theme:Hex(token)
    local colour = self.tokens[token] or self.tokens.textPrimary
    return "|cff" .. colour.hex
end

---Faerbt einen Text ein.
---@param token string
---@param text string
---@return string
function Theme:Text(token, text)
    return self:Hex(token) .. text .. "|r"
end

--------------------------------------------------------------------------
-- Masse
--------------------------------------------------------------------------

-- MDT: space xs 2, sm 4, md 8, lg 12, xl 16. Unsere Abstaende waren schon
-- vorher eine Stufe groesser und bleiben es - die Liste ist dichter als
-- alles, was MDT selbst zeigt.
Theme.space = { xs = 4, sm = 8, md = 12, lg = 16, xl = 24 }

Theme.size = {
    control = 26, -- MDT size.md
    row     = 34,
    header  = 24,
    hit     = 24,
}

--------------------------------------------------------------------------
-- Schrift
--------------------------------------------------------------------------

-- MDTs Rollen, aber zwei Punkte groesser. MDT setzt sie fuer dichte
-- Werkzeugleisten (body 12, small 10); in unserer Liste und Detailspalte war
-- das zu klein zum Lesen. Ausprobiert, nicht abgeleitet - wer hier dreht,
-- prueft die Zeilenhoehen in Browser.lua mit.
local FONT_SIZES = {
    body = 14, small = 12, title = 17, heading = 15, number = 14, display = 22,
}

-- Die Dateien wie in MDTs Fonts.lua: lateinisch Archivo (oder was der
-- Spieler in MDT gewaehlt hat), fuer die uebrigen Schriften die, die jeder
-- Client mitbringt. Ohne sie erschienen kyrillische und chinesische
-- Spielernamen in der Gruppenliste als Kaestchen.
local ARCHIVO = "Interface\\AddOns\\MythicDungeonTools\\Fonts\\ArchivoNarrow-Bold.ttf"
local FILES = {
    roman = ARCHIVO,
    russian = "Fonts\\FRIZQT___CYR.TTF",
    korean = "Fonts\\2002.TTF",
    simplifiedchinese = "Fonts\\ARKai_T.ttf",
    traditionalchinese = "Fonts\\blei00d.TTF",
}
local ALPHABETS = { "roman", "russian", "korean", "simplifiedchinese", "traditionalchinese" }
local CLIENT = { ruRU = "russian", koKR = "korean", zhCN = "simplifiedchinese", zhTW = "traditionalchinese" }
-- CJK wirkt bei gleicher Hoehe kleiner (MDT: heightScale).
local SCALE = { korean = 1.05, simplifiedchinese = 1.05, traditionalchinese = 1.05 }

local fonts = {}

---Die lateinische Datei. Hat der Spieler in MDT eine eigene Schrift gewaehlt,
---traegt MDTs Schriftobjekt sie - auf lateinischen Clients steht sie dort
---an erster Stelle.
---@return string
local function romanFile()
    local client = CLIENT[GetLocale()]
    local mdt = _G.MDTFont_body
    if not client and mdt then
        local file = mdt:GetFont()
        if file then return file end
    end
    return ARCHIVO
end

---Schriftobjekt fuer eine Rolle und Farbe. Es traegt beides, damit es direkt
---als Vorlage in CreateFontString taugt.
---
---Eine Schriftfamilie wie bei MDT: die eigene Schrift des Clients zuerst,
---die anderen als Ersatz fuer Zeichen, die ihr fehlen. Ohne CreateFontFamily
---bleibt es eine einfache Schrift.
---@param role string body | small | title | heading | number | display
---@param token string|nil Farbtoken, Vorgabe textPrimary
---@param outline boolean|nil mit Kontur, fuer Text auf Bildern und Farben
---@return string name globaler Name, fuer CreateFontString
function Theme:FontName(role, token, outline)
    token = token or "textPrimary"
    local name = "MDTRouteLibraryFont_" .. role .. "_" .. token .. (outline and "_outline" or "")
    if fonts[name] then return name end

    local size = FONT_SIZES[role] or FONT_SIZES.body
    local flags = outline and "OUTLINE" or ""
    local client = CLIENT[GetLocale()] or "roman"
    local files = { roman = romanFile() }
    setmetatable(files, { __index = FILES })

    local members = {}
    local function add(alphabet)
        members[#members + 1] = {
            alphabet = alphabet,
            file = files[alphabet],
            height = math.floor(size * (SCALE[alphabet] or 1) + 0.5),
            flags = flags,
        }
    end
    add(client)
    for _, alphabet in ipairs(ALPHABETS) do
        if alphabet ~= client then add(alphabet) end
    end

    local font
    if type(CreateFontFamily) == "function" and pcall(CreateFontFamily, name, members) then
        font = _G[name]
    end
    if not font then
        font = CreateFont(name)
        if not font:SetFont(members[1].file, members[1].height, flags) then
            font:SetFont(STANDARD_TEXT_FONT, size, flags)
        end
    end
    font:SetTextColor(self:Color(token))
    font:SetShadowOffset(0, 0)

    fonts[name] = font
    return name
end

---Dasselbe als Objekt, fuer SetFontObject.
---@param role string
---@param token string|nil
---@param outline boolean|nil
---@return table
function Theme:Font(role, token, outline)
    return _G[self:FontName(role, token, outline)]
end

--------------------------------------------------------------------------
-- Bausteine
--------------------------------------------------------------------------

---Legt eine einfarbige Flaeche ueber einen Frame.
---@param parent table
---@param token string
---@param alpha number|nil
---@param layer string|nil
---@return table
function Theme:Fill(parent, token, alpha, layer)
    local texture = parent:CreateTexture(nil, layer or "BACKGROUND")
    texture:SetAllPoints()
    texture:SetColorTexture(self:Color(token, alpha))
    return texture
end

---Weisse Waschung wie bei MDT, fuer Hover und Auswahl.
---@param parent table
---@param kind string hover | selected
---@param layer string|nil
---@return table
function Theme:Tint(parent, kind, layer)
    local texture = parent:CreateTexture(nil, layer or "BACKGROUND", nil, 1)
    texture:SetAllPoints()
    texture:SetColorTexture(1, 1, 1, self.tint[kind] or self.tint.hover)
    return texture
end

---Breite eines Bildschirmpixels in den Einheiten dieses Frames.
---@param frame table
---@return number
local function pixel(frame)
    return PixelUtil.GetPixelToUIUnitFactor() / math.max(0.01, frame:GetEffectiveScale())
end

---Zeichnet einen Rand, genau ein Bildschirmpixel breit - wie MDTs
---Kit/Pixel.lua. Die Staerke wird beim Zeigen neu bestimmt, denn der Browser
---uebernimmt MDTs Skalierung erst, wenn er ueber MDT gelegt wird.
---@param frame table
---@param token string|nil
---@param alpha number|nil
function Theme:Border(frame, token, alpha)
    frame.borderParts = frame.borderParts or {}

    local edges = {
        { "TOPLEFT", "TOPRIGHT", true },
        { "BOTTOMLEFT", "BOTTOMRIGHT", true },
        { "TOPLEFT", "BOTTOMLEFT", false },
        { "TOPRIGHT", "BOTTOMRIGHT", false },
    }

    for i, edge in ipairs(edges) do
        local line = frame.borderParts[i]
        if not line then
            line = frame:CreateTexture(nil, "BORDER")
            line:SetSnapToPixelGrid(false)
            line:SetTexelSnappingBias(0)
            line:SetPoint(edge[1], frame, edge[1], 0, 0)
            line:SetPoint(edge[2], frame, edge[2], 0, 0)
            line.horizontal = edge[3]
            frame.borderParts[i] = line
        end
    end

    self:SetBorderColor(frame, token, alpha)

    if not frame.borderSized then
        frame.borderSized = true
        local function size()
            local px = pixel(frame)
            for _, line in ipairs(frame.borderParts) do
                if line.horizontal then line:SetHeight(px) else line:SetWidth(px) end
            end
        end
        frame:HookScript("OnShow", size)
        size()
    end
end

---Faerbt einen mit Border gezeichneten Rand um.
---@param frame table
---@param token string|nil
---@param alpha number|nil
function Theme:SetBorderColor(frame, token, alpha)
    if not frame.borderParts then return end
    local r, g, b, a = self:Color(token or "borderSubtle", alpha)
    for _, line in ipairs(frame.borderParts) do
        line:SetColorTexture(r, g, b, a)
        line:SetShown(token ~= false)
    end
end

---Waagerechte Trennlinie (MDT: border.divider).
---@param parent table
---@return table
function Theme:Divider(parent)
    local line = parent:CreateTexture(nil, "ARTWORK")
    line:SetHeight(1)
    line:SetColorTexture(self:Color("borderSubtle", 1))
    return line
end

---Flaeche mit Rand, wie MDTs Popover und Dialoge.
---@param parent table
---@param token string|nil
---@return table
function Theme:Panel(parent, token)
    local frame = CreateFrame("Frame", nil, parent)
    self:Fill(frame, token or "bgOverlay", 1)
    self:Border(frame, "borderStrong")
    return frame
end

--------------------------------------------------------------------------
-- Knoepfe
--------------------------------------------------------------------------

-- MDTs Skins (Kit/Theme.lua, skin): Flaeche, Rand und Schrift je Zustand.
-- false heisst: nicht zeichnen.
local SKINS = {
    default = {
        normal   = { "bgRaised",   "borderSubtle", "textPrimary" },
        hover    = { "bgHover",    "borderStrong", "textPrimary" },
        pressed  = { "bgPressed",  "borderStrong", "textPrimary" },
        selected = { "bgSelected", "accent",       "accent" },
        disabled = { "bgRaised",   "borderSubtle", "textDisabled" },
    },
    primary = {
        normal   = { "accentBg",      "accentBorder", "accent" },
        hover    = { "accentBgHover", "accent",       "accent" },
        pressed  = { "accentBg",      "accent",       "accent" },
        selected = { "accent",        "accent",       "textInverse" },
        disabled = { "bgRaised",      "borderSubtle", "textDisabled" },
    },
    danger = {
        normal   = { "dangerBg", "dangerBorder", "danger" },
        hover    = { "dangerBg", "danger",       "danger" },
        pressed  = { "dangerBg", "danger",       "danger" },
        selected = { "dangerBg", "danger",       "danger" },
        disabled = { "bgRaised", "borderSubtle", "textDisabled" },
    },
    -- Auswahlfelder: sehen aus wie ein Eingabefeld.
    field = {
        normal   = { "bgInset", "borderStrong", "textPrimary" },
        hover    = { "bgInset", "borderStrong", "textPrimary" },
        pressed  = { "bgInset", "accent",       "textPrimary" },
        selected = { "bgInset", "accent",       "textPrimary" },
        disabled = { "bgInset", "borderSubtle", "textDisabled" },
    },
    ghost = {
        normal   = { false,      false, "textMuted" },
        hover    = { "hover",    false, "textPrimary" },
        pressed  = { "bgRaised", false, "textPrimary" },
        selected = { "selected", false, "accent" },
        disabled = { false,      false, "textDisabled" },
    },
}

---Zustand eines Knopfs, in MDTs Reihenfolge: aus vor gedrueckt vor
---ausgewaehlt vor Hover.
local function state(button)
    if not button:IsEnabled() then return "disabled" end
    if button.pressed then return "pressed" end
    if button.selected then return "selected" end
    if button.hovered then return "hover" end
    return "normal"
end

local function paint(button)
    local skin = SKINS[button.variant] or SKINS.default
    local row = skin[state(button)] or skin.normal
    local bg, border, text = row[1], row[2], row[3]

    if bg == "hover" or bg == "selected" then
        button.bg:SetColorTexture(1, 1, 1, Theme.tint[bg])
        button.bg:Show()
    elseif bg then
        button.bg:SetColorTexture(Theme:Color(bg))
        button.bg:Show()
    else
        button.bg:Hide()
    end
    Theme:SetBorderColor(button, border or false)

    local label = button:GetFontString()
    if label then label:SetTextColor(Theme:Color(text)) end
    if button.icon then button.icon:SetVertexColor(Theme:Color(text)) end
end

---Flacher Knopf wie MDTs Kit/Controls/Button.lua.
---
---Die Zusatzfelder von frueher bleiben: primary hebt hervor (MDTs Skin
---"primary"), tooltipText zeigt einen Hinweis, Apply zeichnet neu. Dazu
---variant fuer "danger" und "ghost".
---@param parent table
---@param text string
---@param width number|nil
---@return table
function Theme:Button(parent, text, width)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(width or 140, self.size.control)
    button:RegisterForClicks("LeftButtonUp")

    button.bg = button:CreateTexture(nil, "BACKGROUND")
    button.bg:SetAllPoints()
    self:Border(button, "borderSubtle")

    -- MDTs Innenabstand (space.md). Bei schmalen Knoepfen wie "<" und ">"
    -- blieb dafuer kein Platz fuer das Zeichen, und es kam ".." heraus.
    local pad = (width or 140) < 40 and 2 or 8
    local label = button:CreateFontString(nil, "OVERLAY")
    label:SetFontObject(self:Font("body"))
    label:SetPoint("LEFT", button, "LEFT", pad, 0)
    label:SetPoint("RIGHT", button, "RIGHT", -pad, 0)
    label:SetWordWrap(false)
    button:SetFontString(label)
    button:SetText(text)

    button.Apply = function(self_)
        if self_.primary and self_.variant == "default" then self_.variant = "primary" end
        if not self_.primary and self_.variant == "primary" and not self_.fixedVariant then
            self_.variant = "default"
        end
        paint(self_)
    end

    ---Setzt den Skin dauerhaft, unabhaengig von primary.
    button.SetVariant = function(self_, variant)
        self_.variant = variant
        self_.fixedVariant = true
        paint(self_)
    end

    button.variant = "default"

    button:HookScript("OnEnter", function(self_)
        self_.hovered = true
        paint(self_)
        if self_.tooltipText then
            GameTooltip:SetOwner(self_, "ANCHOR_TOP")
            GameTooltip:AddLine(self_.tooltipText, 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)
    button:HookScript("OnLeave", function(self_)
        self_.hovered = nil
        self_.pressed = nil
        paint(self_)
        GameTooltip:Hide()
    end)
    button:HookScript("OnMouseDown", function(self_)
        if not self_:IsEnabled() then return end
        self_.pressed = true
        paint(self_)
    end)
    button:HookScript("OnMouseUp", function(self_)
        self_.pressed = nil
        paint(self_)
    end)
    button:HookScript("OnEnable", function(self_) self_:Apply() end)
    button:HookScript("OnDisable", function(self_) self_:Apply() end)

    button:Apply()
    return button
end

---Umschalter. Aktiv bekommt MDTs Skin "selected": heller Grund, weisser
---Rand und weisse Schrift.
---@param parent table
---@param text string
---@param width number|nil
---@return table
function Theme:Tab(parent, text, width)
    local tab = self:Button(parent, text, width)

    tab.SetActive = function(self_, active)
        self_.selected = active or nil
        self_:Apply()
    end

    return tab
end

---Ankreuzfeld wie MDTs Kit/Controls/Checkbox.lua: ein Kasten, dessen Rand
---bei Hover oder Haken aufhellt, gefuellt mit einem weissen Quadrat.
---
---Die Schnittstelle bleibt die eines CheckButton (GetChecked, SetChecked,
---OnClick), damit die Aufrufstellen nichts merken.
---@param parent table
---@param text string
---@return table
function Theme:Checkbox(parent, text)
    local box = CreateFrame("CheckButton", nil, parent)
    box:SetSize(18, 18)

    self:Fill(box, "bgInset", 1)
    self:Border(box, "borderStrong")

    local fill = box:CreateTexture(nil, "ARTWORK")
    fill:SetSize(10, 10)
    fill:SetPoint("CENTER")
    fill:SetColorTexture(self:Color("accent"))
    box:SetCheckedTexture(fill)

    local function repaint(self_)
        local lit = self_:GetChecked() or self_.hovered
        Theme:SetBorderColor(self_, lit and "accent" or "borderStrong", lit and 0.5 or 1)
    end
    box:HookScript("OnEnter", function(self_) self_.hovered = true repaint(self_) end)
    box:HookScript("OnLeave", function(self_) self_.hovered = nil repaint(self_) end)
    -- PostClick statt eines OnClick-Hooks: die Aufrufstellen setzen OnClick
    -- mit SetScript, und das wirft Hooks weg.
    box:SetScript("PostClick", repaint)
    hooksecurefunc(box, "SetChecked", repaint)

    box.label = box:CreateFontString(nil, "OVERLAY", self:FontName("body"))
    box.label:SetPoint("LEFT", box, "RIGHT", 6, 0)
    box.label:SetText(text or "")

    -- Die Beschriftung soll mitklicken, wie bei MDT.
    box:SetHitRectInsets(0, -(box.label:GetStringWidth() + 6), 0, 0)

    return box
end

---Kleidet ein Eingabefeld wie MDTs Skin "field": versenkter Grund, kraeftiger
---Rand, beim Tippen weiss. Blizzards Rahmenteile verschwinden.
---@param edit table EditBox, auch aus InputBoxTemplate oder SearchBoxTemplate
---@param inset number|nil linker Textabstand
function Theme:SkinEditBox(edit, inset)
    for _, key in ipairs({ "Left", "Right", "Middle", "Mid" }) do
        local part = edit[key]
        if part and part.SetAlpha then part:SetAlpha(0) end
    end

    local bg = edit:CreateTexture(nil, "BACKGROUND", nil, -8)
    bg:SetAllPoints()
    bg:SetColorTexture(self:Color("bgInset"))
    self:Border(edit, "borderStrong")

    edit:SetFontObject(self:Font("body"))
    if inset then edit:SetTextInsets(inset, 6, 0, 0) end
    if edit.Instructions then edit.Instructions:SetFontObject(self:Font("body", "textDisabled")) end

    edit:HookScript("OnEditFocusGained", function(self_) Theme:SetBorderColor(self_, "accent") end)
    edit:HookScript("OnEditFocusLost", function(self_) Theme:SetBorderColor(self_, "borderStrong") end)
end

--------------------------------------------------------------------------
-- Rollen
--------------------------------------------------------------------------

-- MDTs Kit/Scroll.lua: 8 Punkte breit, flache Spur, Daumen in border.strong,
-- bei Hover heller. Keine Pfeilknoepfe.
local TRACK_WIDTH = 8
local WHEEL_STEP = 40

---Scrollbereich mit MDTs schmaler Leiste statt Blizzards Pfeilleiste.
---
---Die Leiste steht rechts neben dem Bereich, wo vorher Blizzards stand; die
---Aufrufstellen behalten ihre Abstaende.
---@param parent table
---@return table scroll ScrollFrame
function Theme:Scroll(parent)
    local scroll = CreateFrame("ScrollFrame", nil, parent)
    scroll:EnableMouseWheel(true)

    local bar = CreateFrame("Frame", nil, scroll)
    bar:SetWidth(TRACK_WIDTH)
    bar:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 6, 0)
    bar:SetPoint("BOTTOMLEFT", scroll, "BOTTOMRIGHT", 6, 0)
    bar:EnableMouse(true)
    self:Fill(bar, "bgInset", 1)
    scroll.bar = bar

    local thumb = CreateFrame("Frame", nil, bar)
    thumb:SetWidth(TRACK_WIDTH)
    thumb:EnableMouse(true)
    thumb.texture = self:Fill(thumb, "borderStrong", 1, "ARTWORK")
    bar.thumb = thumb

    local function layout()
        local range = scroll:GetVerticalScrollRange() or 0
        local view = scroll:GetHeight() or 0
        if range < 0.5 or view <= 0 then
            bar:Hide()
            return
        end
        bar:Show()
        local track = bar:GetHeight()
        local size = math.max(16, track * view / (view + range))
        thumb:SetHeight(math.min(track, size))
        local offset = (track - thumb:GetHeight()) * (scroll:GetVerticalScroll() / range)
        thumb:ClearAllPoints()
        thumb:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, -offset)
    end
    scroll.UpdateBar = layout

    local function scrollTo(value)
        local range = scroll:GetVerticalScrollRange() or 0
        scroll:SetVerticalScroll(math.max(0, math.min(range, value)))
    end

    scroll:SetScript("OnMouseWheel", function(self_, delta)
        scrollTo(self_:GetVerticalScroll() - delta * WHEEL_STEP)
    end)
    scroll:SetScript("OnScrollRangeChanged", function(self_)
        -- Faellt der Inhalt kuerzer aus, nicht ins Leere zeigen.
        scrollTo(self_:GetVerticalScroll())
        layout()
    end)
    scroll:SetScript("OnVerticalScroll", layout)
    bar:SetScript("OnSizeChanged", layout)

    thumb:SetScript("OnEnter", function(self_) self_.texture:SetColorTexture(Theme:Color("textMuted")) end)
    thumb:SetScript("OnLeave", function(self_)
        if not self_.drag then self_.texture:SetColorTexture(Theme:Color("borderStrong")) end
    end)
    thumb:SetScript("OnMouseDown", function(self_)
        local _, y = GetCursorPosition()
        self_.drag = { y = y / self_:GetEffectiveScale(), value = scroll:GetVerticalScroll() }
        self_:SetScript("OnUpdate", function()
            local _, now = GetCursorPosition()
            local travel = bar:GetHeight() - self_:GetHeight()
            if travel <= 0 then return end
            local moved = self_.drag.y - now / self_:GetEffectiveScale()
            scrollTo(self_.drag.value + moved / travel * scroll:GetVerticalScrollRange())
        end)
    end)
    thumb:SetScript("OnMouseUp", function(self_)
        self_.drag = nil
        self_:SetScript("OnUpdate", nil)
        if not self_:IsMouseOver() then self_.texture:SetColorTexture(Theme:Color("borderStrong")) end
    end)

    -- Ein Klick auf die Spur springt seitenweise, wie bei MDT.
    bar:SetScript("OnMouseDown", function(self_)
        local _, y = GetCursorPosition()
        y = y / self_:GetEffectiveScale()
        local page = scroll:GetHeight() * 0.9
        if y > thumb:GetTop() then
            scrollTo(scroll:GetVerticalScroll() - page)
        elseif y < thumb:GetBottom() then
            scrollTo(scroll:GetVerticalScroll() + page)
        end
    end)

    bar:Hide()
    return scroll
end
