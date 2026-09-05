-- Kopierdialog.
--
-- Der einzige Weg, Text aus WoW herauszubekommen, ist eine EditBox, die der
-- Nutzer mit Strg+C leert. Genau das machen MDT, WeakAuras und DBM auch.

local _, ns = ...

local UI = {}
ns.UI = UI

local frame

local WIDTH, HEIGHT = 560, 220

---Baut den Dialog beim ersten Aufruf.
---@return table
local function ensureFrame()
    if frame then return frame end

    frame = CreateFrame("Frame", "MDTRouteLibraryCopyFrame", UIParent, "BackdropTemplate")
    frame:SetSize(WIDTH, HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetBackdrop({
        bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 24,
        insets = { left = 6, right = 6, top = 6, bottom = 6 },
    })

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.title:SetPoint("TOPLEFT", 18, -16)

    frame.help = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    frame.help:SetPoint("TOPLEFT", 18, -36)
    frame.help:SetPoint("TOPRIGHT", -18, -36)
    frame.help:SetJustifyH("LEFT")
    frame.help:SetTextColor(0.8, 0.8, 0.8)

    local scroll = CreateFrame("ScrollFrame", "MDTRouteLibraryCopyScroll", frame, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 18, -74)
    scroll:SetPoint("BOTTOMRIGHT", -36, 76)

    local edit = CreateFrame("EditBox", nil, scroll)
    edit:SetMultiLine(true)
    edit:SetFontObject(ChatFontNormal)
    edit:SetWidth(WIDTH - 70)
    edit:SetAutoFocus(false)
    edit:SetScript("OnEscapePressed", function() frame:Hide() end)
    -- Der Inhalt ist nur zum Kopieren da: jede Aenderung wird zurueckgesetzt.
    edit:SetScript("OnTextChanged", function(self, userInput)
        if userInput then
            self:SetText(frame.payload or "")
            self:HighlightText()
        end
    end)
    scroll:SetScrollChild(edit)
    frame.edit = edit
    frame.scroll = scroll

    -- Zweite Zeile fuer eine Adresse. WoW kann keine Links oeffnen, also muss
    -- auch die URL kopierbar sein.
    frame.linkLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    frame.linkLabel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 18, 72)
    frame.linkLabel:SetTextColor(0.8, 0.8, 0.8)

    frame.linkBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    frame.linkBox:SetHeight(20)
    frame.linkBox:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 24, 50)
    frame.linkBox:SetPoint("RIGHT", frame, "RIGHT", -24, 0)
    frame.linkBox:SetAutoFocus(false)
    frame.linkBox:SetScript("OnEscapePressed", function() frame:Hide() end)
    frame.linkBox:SetScript("OnTextChanged", function(self, userInput)
        if userInput then
            self:SetText(frame.link or "")
            self:HighlightText()
        end
    end)
    frame.linkBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)

    local close = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    close:SetSize(120, 24)
    close:SetPoint("BOTTOM", 0, 16)
    close:SetScript("OnClick", function() frame:Hide() end)
    frame.close = close

    tinsert(UISpecialFrames, "MDTRouteLibraryCopyFrame") -- Escape schliesst
    frame:Hide()

    return frame
end

---Zeigt Text zum Kopieren an und markiert ihn vor.
---@param title string
---@param help string
---@param text string
---@param link string|nil Optionale Adresse, ebenfalls zum Kopieren
function UI.ShowCopyDialog(title, help, text, link)
    local f = ensureFrame()

    f.payload = text
    f.link    = link
    f.title:SetText(title)
    f.help:SetText(help)
    f.close:SetText(ns.L["COPY_CLOSE"])

    -- Der Scrollbereich muss Platz lassen: erst die Adresse, dann der Knopf.
    f.scroll:ClearAllPoints()
    f.scroll:SetPoint("TOPLEFT", 18, -74)

    if link then
        f.linkLabel:SetText(ns.L["COPY_LINK_LABEL"])
        f.linkBox:SetText(link)
        f.linkLabel:Show()
        f.linkBox:Show()
        f:SetHeight(300)
        f.scroll:SetPoint("BOTTOMRIGHT", -36, 98)
    else
        f.linkLabel:Hide()
        f.linkBox:Hide()
        f:SetHeight(220)
        f.scroll:SetPoint("BOTTOMRIGHT", -36, 48)
    end

    f.edit:SetText(text)
    f:Show()

    -- Erst nach dem Anzeigen fokussieren, sonst greift die Markierung nicht.
    f.edit:SetFocus()
    f.edit:HighlightText()
end
