-- Minimale Lokalisierung: L["Schluessel"] gibt die Uebersetzung zurueck,
-- sonst den Schluessel selbst. Fehlende Strings fallen so nie hart aus.

local _, ns = ...

local locale = GetLocale()
local translations = {}

ns.L = setmetatable({}, {
    __index = function(_, key)
        local entry = translations[key]
        if entry == nil then return key end
        return entry
    end,
})

---Traegt Uebersetzungen fuer eine Sprache ein.
---enUS ist die Basis und wird immer angewendet, damit kein Schluessel fehlt.
---@param localeName string Sprachkuerzel, z. B. "deDE"
---@param entries table<string, string>
function ns.RegisterLocale(localeName, entries)
    if localeName ~= "enUS" and localeName ~= locale then return end
    for key, value in pairs(entries) do
        translations[key] = value
    end
end
