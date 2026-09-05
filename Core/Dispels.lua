-- Wer bekommt welchen Effekt weg?
--
-- MDT markiert jeden Gegnerzauber mit seiner Art (Magie, Fluch, Gift,
-- Krankheit, Blutung, Raserei). Welche Klasse damit umgehen kann, steht
-- nirgends in den Spieldaten - das ist Wissen, das hier von Hand gepflegt wird.
--
-- WICHTIG: Diese Tabelle altert. Blizzard verschiebt Bannzauber zwischen
-- Spezialisierungen, und die Angaben unten gelten fuer Retail zum Zeitpunkt
-- des letzten Abgleichs (MDT 6.2.13, Client 12.0.1). Wenn etwas nicht mehr
-- stimmt, ist genau diese Datei der einzige Ort, der angefasst werden muss.
--
-- Zwei Richtungen sind zu unterscheiden:
--   dispel  - der Effekt liegt als Debuff auf der Gruppe und wird entfernt
--   offense - der Gegner hat einen Buff, der geraubt oder beruhigt wird

local _, ns = ...

---Klassenname in Klassenfarbe.
---@param token string Klassenkuerzel, z. B. "PRIEST"
---@return string
local function coloured(token)
    local name = LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[token] or token
    local colour = RAID_CLASS_COLORS and RAID_CLASS_COLORS[token]
    if colour and colour.colorStr then
        return ("|c%s%s|r"):format(colour.colorStr, name)
    end
    return name
end

ns.ColouredClass = coloured

-- Nur Klassenkuerzel, damit die Anzeige lokalisiert und eingefaerbt werden
-- kann. Die Spezialisierung steht als Klammerzusatz dahinter, wo sie zaehlt.
local DISPELS = {
    magic = {
        dispel  = { "PRIEST", "PALADIN", "DRUID", "SHAMAN", "MONK", "EVOKER" },
        offense = { "SHAMAN", "MAGE", "PRIEST", "WARLOCK", "HUNTER" },
    },
    curse = {
        dispel = { "MAGE", "DRUID", "SHAMAN" },
    },
    poison = {
        dispel = { "PALADIN", "MONK", "DRUID", "EVOKER" },
    },
    disease = {
        dispel = { "PRIEST", "PALADIN", "MONK" },
    },
    bleed = {
        -- Blutungen lassen sich nicht bannen. Ehrlicher Hinweis statt leerer
        -- Zeile: hier hilft nur Schadensreduktion.
        none = true,
    },
    enrage = {
        offense = { "HUNTER", "DRUID", "ROGUE" },
    },
}

---Liefert die Zeilen, die im Tooltip unter einer Zauberart stehen.
---@param dispelType string "magic", "curse", ...
---@return table Liste von { text = string }
function ns.GetDispelHint(dispelType)
    local entry = DISPELS[dispelType]
    if not entry then return {} end

    local lines = {}

    if entry.none then
        lines[#lines + 1] = { text = ns.L["DISPEL_NONE"] }
        return lines
    end

    if entry.dispel then
        local names = {}
        for i, token in ipairs(entry.dispel) do names[i] = coloured(token) end
        lines[#lines + 1] = { text = ns.L["DISPEL_BY"] .. " " .. table.concat(names, ", ") }
    end

    if entry.offense then
        -- Raserei wird beruhigt, Magie geraubt - unterschiedliche Woerter fuer
        -- dieselbe Mechanik, deshalb getrennte Beschriftung.
        local label = dispelType == "enrage" and ns.L["DISPEL_SOOTHE"] or ns.L["DISPEL_PURGE"]
        local names = {}
        for i, token in ipairs(entry.offense) do names[i] = coloured(token) end
        lines[#lines + 1] = { text = label .. " " .. table.concat(names, ", ") }
    end

    return lines
end
