-- Slash-Befehle: /routes bzw. /mdtrl

local _, ns = ...

local L = ns.L

local handlers = {}

---Zeigt die Hilfe.
local function showHelp()
    ns.Print(L["HELP_HEADER"])
    ns.Print(L["HELP_OPEN"])
    ns.Print(L["HELP_LIST"])
    ns.Print(L["HELP_SUBMIT"])
    ns.Print(L["HELP_STATUS"])
    ns.Print(L["HELP_CLEANUP"])
end

function handlers.list()
    if not ns.EnsureData() then return end

    if #ns.routes == 0 then
        ns.Print(L["LIST_EMPTY"])
        return
    end

    ns.Print(L["LIST_HEADER"])
    for i, route in ipairs(ns.routes) do
        ns.Print(L["LIST_LINE"]:format(
            tostring(i),
            route.title or route.id,
            #route.pulls,
            route.author or "?"
        ))
    end
end

function handlers.status()
    ns.Print("MDTRouteLibrary %s", ns.version)

    if not ns.MDT.IsInstalled() then
        ns.Warn(L["NO_MDT"])
    elseif ns.MDT.IsReady() then
        local result = ns.MDT.GetLastResult()
        if result then
            ns.Print(L["ROUTES_INSTALLED"], result.installed, result.dungeons)
        end
    else
        ns.Print("MDT gefunden, Oberflaeche noch nicht geladen (oeffne MDT einmal).")
    end

    if not ns.EnsureData() then return end

    local manifest = ns.manifest
    if manifest and manifest.build then
        local days = ns.DaysSince(manifest.build)
        if days and days > 0 then
            ns.Print(L["DATA_STALE"], days)
        else
            ns.Print(L["DATA_FRESH"], manifest.build)
        end
    end
end

function handlers.cleanup()
    if not ns.EnsureData() then return end

    if not ns.MDT.IsReady() then
        ns.Warn("MDT ist noch nicht geladen. Oeffne MDT einmal (/mdt).")
        return
    end

    local result = ns.MDT.CleanupPresets()
    ns.Print(L["CLEANED_UP"], result.removed)
end

function handlers.submit()
    local blob, err = ns.Submit.BuildBlob()
    if not blob then
        ns.Warn(err or "unbekannter Fehler")
        return
    end

    ns.UI.ShowCopyDialog(L["SUBMIT_TITLE"], L["SUBMIT_HELP"], blob, ns.SUBMIT_URL)
    ns.Print(L["SUBMIT_OK"])
end

---/routes copy <nummer> - MDT-Importstring einer Route zum Kopieren.
function handlers.copy(arg)
    if not ns.EnsureData() then return end

    local index = tonumber(arg)
    local route = index and ns.routes[index]
    if not route then
        ns.Warn("Unbekannte Route. /routes list zeigt die Nummern.")
        return
    end

    local str, err = ns.MDT.BuildImportString(route)
    if not str then
        ns.Warn(err or "Importstring konnte nicht erzeugt werden.")
        return
    end

    ns.UI.ShowCopyDialog(route.title or route.id, L["SUBMIT_HELP"], str)
end

---Oeffnet den Routen-Browser in MDT.
function handlers.open()
    ns.Browser.Open()
end

handlers.help = showHelp

SLASH_MDTRL1 = "/routes"
SLASH_MDTRL2 = "/mdtrl"

SlashCmdList["MDTRL"] = function(input)
    local command, rest = strsplit(" ", strtrim(input or ""), 2)
    command = (command or ""):lower()

    -- Ohne Argument das Fenster oeffnen: Befehle sind der Nebenweg, nicht
    -- der Hauptweg.
    if command == "" then
        ns.Browser.Open()
        return
    end

    local handler = handlers[command]
    if handler then
        handler(rest)
    else
        showHelp()
    end
end

-- Eintrag im Addon-Compartment (das Zahnrad an der Minikarte).
function MDTRouteLibrary_OnCompartmentClick()
    ns.Browser.Open()
end
