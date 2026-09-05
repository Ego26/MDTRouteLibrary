-- Luacheck-Konfiguration fuer MDTRouteLibrary
-- Ausfuehren:  luacheck .

std = "lua51"
max_line_length = 120
codes = true
self = false

exclude_files = { ".release/", "node_modules/" }

ignore = {
    "212/self",   -- unbenutztes self in Methoden
    "212/_.*",    -- absichtlich unbenutzte Parameter mit _-Praefix
    "631",        -- Zeilenlaenge wird oben separat geregelt
}

globals = {
    "MDTRouteLibrary",
    "MDTRouteLibraryDB",
    "SLASH_MDTRL1", "SLASH_MDTRL2",
    "MDTRouteLibrary_OnCompartmentClick",
    "SlashCmdList",
    "UISpecialFrames",

    -- Fremdes SavedVariable: wir haengen Presets ein (siehe Core/MDT.lua).
    "MythicDungeonToolsDB",
}

read_globals = {
    -- Lua-Erweiterungen des WoW-Clients
    "wipe", "strsplit", "strjoin", "strtrim", "tinsert", "tremove", "sort", "bit",
    "unpack", "select", "format", "date", "time", "CopyTable", "tContains",

    -- Kern-API
    "CreateFrame", "GetTime", "GetLocale", "UIParent", "DEFAULT_CHAT_FRAME",
    "ReloadUI", "GetBuildInfo", "IsControlKeyDown", "IsShiftKeyDown", "UnitFullName",
    "GameFontNormal", "GameFontHighlight", "ChatFontNormal",
    "SearchBoxTemplate_OnTextChanged", "YES", "NO",
    "RAID_CLASS_COLORS", "LOCALIZED_CLASS_NAMES_MALE",
    "GetClassInfo", "GetClassColor", "WrapTextInColorCode",
    "StaticPopupDialogs", "StaticPopup_Show", "GameTooltip",

    -- Namensraeume
    "C_AddOns", "C_Timer", "C_EncodingUtil", "C_Map", "C_ChallengeMode",
    "Enum", "Settings", "Mixin", "CreateFromMixins", "C_MythicPlus",

    -- MDT (oeffentliche Schnittstelle, siehe docs/01-Architektur.md)
    "MythicDungeonToolsAPI",
}
