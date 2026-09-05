-- Ablauf beim Start.
--
-- Absichtlich sehr wenig: beim Login melden wir uns nur bei MDT an. Die
-- Routendaten liegen im LoadOnDemand-Addon MDTRouteLibrary_Data und werden erst
-- geladen, wenn sie jemand braucht - also wenn MDT aufgeht oder ein
-- Slash-Befehl danach fragt. Wer nie MDT oeffnet, zahlt keinen Speicher.

local _, ns = ...

-- Ab so vielen Tagen gilt der Datenstand als alt.
local STALE_AFTER_DAYS = 10

local dataLoaded  = false
local ageReported = false

---Laedt MDTRouteLibrary_Data nach, falls noch nicht geschehen.
---@return boolean ok
function ns.EnsureData()
    if dataLoaded then return true end

    if C_AddOns.IsAddOnLoaded(ns.DATA_ADDON) then
        dataLoaded = true
        return true
    end

    local loaded, reason = C_AddOns.LoadAddOn(ns.DATA_ADDON)
    if not loaded then
        ns.Warn("%s (%s)", ns.L["NO_DATA"], tostring(reason))
        return false
    end

    dataLoaded = true
    return true
end

---Weist einmal pro Sitzung darauf hin, wenn die Routendaten alt sind.
function ns.CheckDataAge()
    if ageReported then return end

    local manifest = ns.manifest
    if not manifest or not manifest.build then return end

    local days = ns.DaysSince(manifest.build)
    if days and days >= STALE_AFTER_DAYS then
        ageReported = true
        ns.Warn(ns.L["DATA_STALE"], days)
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event)
    if event ~= "PLAYER_LOGIN" then return end
    self:UnregisterEvent("PLAYER_LOGIN")

    -- Eigene Einstellungen: bisher nur die Merkliste. Beim ersten Start gibt
    -- es die SavedVariable noch nicht.
    MDTRouteLibraryDB = MDTRouteLibraryDB or {}
    MDTRouteLibraryDB.favourites = MDTRouteLibraryDB.favourites or {}
    -- Eigene Laufzeiten, je Dungeon. Siehe Core/Runs.lua.
    MDTRouteLibraryDB.runs = MDTRouteLibraryDB.runs or {}

    if not ns.MDT.IsInstalled() then
        -- Ohne MDT ist das Addon nutzlos, aber kein Grund fuer Laerm beim
        -- Login. Der Hinweis kommt bei /routes status.
        return
    end

    if not ns.MDT.Hook() then
        ns.Warn(ns.L["MDT_TOO_OLD"])
    end
end)
