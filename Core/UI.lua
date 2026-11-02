-- Kopierdialog.
--
-- Der einzige Weg, Text aus WoW herauszubekommen, ist eine EditBox, die der
-- Nutzer mit Strg+C leert. Genau das machen MDT, WeakAuras und DBM auch.

local _, ns = ...

local UI = {}
ns.UI = UI

local T = ns.Theme

local frame

local WIDTH, HEIGHT = 560, 220

---Baut den Dialog beim ersten Aufruf.
---@return table
local function ensureFrame()
    if frame then return frame end

    frame = CreateFrame("Frame", "MDTRouteLibraryCopyFrame", UIParent)
    frame:SetSize(WIDTH, HEIGHT)
    frame:SetPoint("CENTER")
    -- Ueber dem Browser, der selbst auf "DIALOG" liegt.
    frame:SetFrameStrata("FULLSCREEN_DIALOG")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    -- Wie MDTs eigene Dialoge (Kit/Dialogs.lua): flache Flaeche, Pixelrand.
    T:Fill(frame, "bgBase", 1)
    T:Border(frame, "borderStrong")

    frame.title = frame:CreateFontString(nil, "OVERLAY", T:FontName("heading"))
    frame.title:SetPoint("TOPLEFT", 18, -16)

    frame.help = frame:CreateFontString(nil, "OVERLAY", T:FontName("body", "textSecondary"))
    frame.help:SetPoint("TOPLEFT", 18, -36)
    frame.help:SetPoint("TOPRIGHT", -18, -36)
    frame.help:SetJustifyH("LEFT")

    -- Das Feld hinter dem Text, wie MDTs mehrzeilige Eingabe.
    local field = CreateFrame("Frame", nil, frame)
    T:Fill(field, "bgInset", 1)
    T:Border(field, "borderStrong")
    frame.field = field

    local scroll = T:Scroll(frame)
    scroll:SetPoint("TOPLEFT", 24, -80)
    scroll:SetPoint("BOTTOMRIGHT", -36, 82)
    field:SetPoint("TOPLEFT", scroll, "TOPLEFT", -6, 6)
    field:SetPoint("BOTTOMRIGHT", scroll, "BOTTOMRIGHT", 22, -6)

    local edit = CreateFrame("EditBox", nil, scroll)
    edit:SetMultiLine(true)
    edit:SetFontObject(T:Font("body"))
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
    frame.linkLabel = frame:CreateFontString(nil, "OVERLAY", T:FontName("small", "textMuted"))
    frame.linkLabel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 18, 102)

    frame.linkBox = CreateFrame("EditBox", nil, frame)
    frame.linkBox:SetHeight(22)
    frame.linkBox:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 18, 76)
    frame.linkBox:SetPoint("RIGHT", frame, "RIGHT", -18, 0)
    frame.linkBox:SetAutoFocus(false)
    T:SkinEditBox(frame.linkBox, 6)
    frame.linkBox:SetScript("OnEscapePressed", function() frame:Hide() end)
    frame.linkBox:SetScript("OnTextChanged", function(self, userInput)
        if userInput then
            self:SetText(frame.link or "")
            self:HighlightText()
        end
    end)
    frame.linkBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)

    -- Dritte Zeile: wann die Route im Spiel ankommt. Wer gerade eingereicht
    -- hat, fragt genau das als Naechstes - und ohne Antwort sieht ein Tag
    -- Wartezeit nach einem Fehler aus.
    frame.note = frame:CreateFontString(nil, "OVERLAY", T:FontName("small", "textMuted"))
    frame.note:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 18, 50)
    frame.note:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -18, 50)
    frame.note:SetJustifyH("LEFT")

    local close = T:Button(frame, "", 120)
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

    -- Die Kartenvorschau tritt zurueck, solange hier etwas zu lesen ist. Beim
    -- ersten Mal anmelden reicht; danach fragt sie selbst nach.
    ns.MapView.BlockedBy(f)
    ns.MapView.Hide()

    f.payload = text
    f.link    = link
    f.title:SetText(title)
    f.help:SetText(help)
    f.close:SetText(ns.L["COPY_CLOSE"])

    -- Der Scrollbereich muss Platz lassen: erst die Adresse, dann der Knopf.
    f.scroll:ClearAllPoints()
    f.scroll:SetPoint("TOPLEFT", 24, -80)

    if link then
        f.linkLabel:SetText(ns.L["COPY_LINK_LABEL"])
        f.linkBox:SetText(link)
        f.note:SetText(ns.L["SUBMIT_WHEN"])
        f.linkLabel:Show()
        f.linkBox:Show()
        f.note:Show()
        f:SetHeight(326)
        f.scroll:SetPoint("BOTTOMRIGHT", -36, 132)
    else
        f.linkLabel:Hide()
        f.linkBox:Hide()
        f.note:Hide()
        f:SetHeight(220)
        f.scroll:SetPoint("BOTTOMRIGHT", -36, 56)
    end

    f.edit:SetText(text)
    f:Show()

    -- Erst nach dem Anzeigen fokussieren, sonst greift die Markierung nicht.
    f.edit:SetFocus()
    f.edit:HighlightText()
end
