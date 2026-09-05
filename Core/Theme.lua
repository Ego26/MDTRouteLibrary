-- Die visuelle Sprache von MDTRouteLibrary.
--
-- Ausrichtung: MDT, nicht etwas Eigenes. Die Sektion liegt in MDTs Fenster,
-- zwischen MDTs eigenen Bereichen - ein fremdes Design waere dort ein
-- Stilbruch, egal wie huebsch es fuer sich genommen waere. Also dieselben
-- dunklen Grautoene, dasselbe Gold als Akzent, dieselben Blizzard-Knoepfe.
--
-- Der Zweck dieser Datei bleibt trotzdem derselbe: kein Farbwert und keine
-- Rahmenstaerke steht sonst irgendwo im Code. Wenn MDT sein Aussehen aendert,
-- ist hier die einzige Stelle, die nachgezogen werden muss.

local _, ns = ...

local Theme = {}
ns.Theme = Theme

--------------------------------------------------------------------------
-- Farbtokens
--------------------------------------------------------------------------

-- Abgeleitet aus MDT: MDT.BackdropColor ist { 0.0588, 0.0588, 0.0588, 0.9 },
-- also 0F0F0F. Das Gold ffd100 benutzt MDT durchgaengig fuer Hervorhebungen.
local PALETTE = {
    bgBase       = "0F0F0F",
    bgRaised     = "141414",
    bgOverlay    = "1A1A1A",
    bgInset      = "0A0A0A",
    bgHover      = "252525",

    borderSubtle = "2E2E2E",
    borderStrong = "4A4A4A",

    textPrimary   = "FFFFFF",
    textSecondary = "C7C7C7",
    textMuted     = "8A8A8A",

    accent        = "FFD100", -- MDTs Gold
    accentHover   = "FFE066",
    success       = "40C057",
    warning       = "FFB400",
    danger        = "FF5555",
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

---Farbcode fuer Text, z. B. "|cffffd100".
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

Theme.space = { xs = 4, sm = 8, md = 12, lg = 16, xl = 24 }

Theme.size = {
    control = 24,
    row     = 34,
    header  = 24,
    hit     = 24,
}

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

---Zeichnet einen 1 px Rand aus vier Kanten.
---@param frame table
---@param token string|nil
---@param alpha number|nil
function Theme:Border(frame, token, alpha)
    local r, g, b, a = self:Color(token or "borderSubtle", alpha)
    frame.borderParts = frame.borderParts or {}

    local edges = {
        { "TOPLEFT", "TOPRIGHT", true },
        { "BOTTOMLEFT", "BOTTOMRIGHT", true },
        { "TOPLEFT", "BOTTOMLEFT", false },
        { "TOPRIGHT", "BOTTOMRIGHT", false },
    }

    for i, edge in ipairs(edges) do
        local line = frame.borderParts[i] or frame:CreateTexture(nil, "BORDER")
        line:ClearAllPoints()
        line:SetPoint(edge[1], frame, edge[1], 0, 0)
        line:SetPoint(edge[2], frame, edge[2], 0, 0)
        if edge[3] then line:SetHeight(1) else line:SetWidth(1) end
        line:SetColorTexture(r, g, b, a)
        frame.borderParts[i] = line
    end
end

---Waagerechte Trennlinie.
---@param parent table
---@return table
function Theme:Divider(parent)
    local line = parent:CreateTexture(nil, "ARTWORK")
    line:SetHeight(1)
    line:SetColorTexture(self:Color("borderStrong", 0.8))
    return line
end

---Flaeche mit Rahmen. Nutzt Blizzards Tooltip-Rahmen, den MDT fuer seine
---eigenen Einblendungen ebenfalls verwendet.
---@param parent table
---@param token string|nil
---@return table
function Theme:Panel(parent, token)
    local frame = CreateFrame("Frame", nil, parent, "TooltipBorderedFrameTemplate")
    self:Fill(frame, token or "bgRaised", 0.96)
    return frame
end

---Knopf im MDT-Stil, also Blizzards Standardknopf.
---
---Die Zusatzfelder (primary, tooltipText, Apply) bleiben erhalten, damit die
---Aufrufstellen unveraendert funktionieren.
---@param parent table
---@param text string
---@param width number|nil
---@return table
function Theme:Button(parent, text, width)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetSize(width or 140, self.size.control)
    button:SetText(text)

    ---Hervorgehobene Knoepfe bekommen goldene Schrift statt einer eigenen
    ---Flaeche - so macht MDT das bei seinen aktiven Elementen auch.
    button.Apply = function(self_)
        local label = self_:GetFontString()
        if not label then return end

        if not self_:IsEnabled() then
            label:SetTextColor(Theme:Color("textMuted"))
        elseif self_.primary then
            label:SetTextColor(Theme:Color("accent"))
        else
            label:SetTextColor(Theme:Color("textPrimary"))
        end
    end

    button:HookScript("OnEnter", function(self_)
        if self_.tooltipText then
            GameTooltip:SetOwner(self_, "ANCHOR_TOP")
            GameTooltip:AddLine(self_.tooltipText, 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)
    button:HookScript("OnLeave", function() GameTooltip:Hide() end)
    button:HookScript("OnEnable", button.Apply)
    button:HookScript("OnDisable", button.Apply)

    button:Apply()
    return button
end

---Umschalter. Aktiv wird golden hervorgehoben.
---@param parent table
---@param text string
---@param width number|nil
---@return table
function Theme:Tab(parent, text, width)
    local tab = self:Button(parent, text, width)

    tab.SetActive = function(self_, active)
        self_.primary = active or nil
        self_:Apply()
    end

    return tab
end

---Ankreuzfeld im Blizzard-Stil mit Beschriftung daneben.
---@param parent table
---@param text string
---@return table
function Theme:Checkbox(parent, text)
    local box = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    box:SetSize(22, 22)

    box.label = box:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    box.label:SetPoint("LEFT", box, "RIGHT", 2, 0)
    box.label:SetText(text or "")

    return box
end
