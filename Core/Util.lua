-- Kleine Helfer: Ausgabe, JSON-Serialisierung und Blizzards Kodier-API.

local _, ns = ...

local PREFIX = "|cff4fc3f7MDTRouteLibrary|r: "

---Schreibt eine Zeile in den Standard-Chatframe.
function ns.Print(msg, ...)
    if select("#", ...) > 0 then msg = msg:format(...) end
    DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. msg)
end

---Wie Print, aber in Rot fuer Fehler.
function ns.Warn(msg, ...)
    if select("#", ...) > 0 then msg = msg:format(...) end
    DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. "|cffff5555" .. msg .. "|r")
end

--------------------------------------------------------------------------
-- JSON
--------------------------------------------------------------------------

-- Eigener Encoder statt C_EncodingUtil.SerializeJSON: der Einreich-Blob soll
-- auch dann funktionieren, wenn Blizzard die Signatur aendert, und die Ausgabe
-- muss deterministisch sein, damit sich Blobs vergleichen lassen.

-- Links steht das Zeichen selbst, rechts die zwei Zeichen, die JSON dafuer
-- verlangt. "\\n" ist also Backslash plus n, nicht der Zeilenumbruch.
local escapes = {
    ['"'] = '\\"', ["\\"] = "\\\\", ["\b"] = "\\b",
    ["\f"] = "\\f", ["\n"] = "\\n", ["\r"] = "\\r", ["\t"] = "\\t",
}

local function escapeString(s)
    -- Das Muster muss den Backslash selbst enthalten, sonst bleibt er
    -- unescapt im JSON stehen. In Lua-Mustern ist "\" nichts Besonderes,
    -- der doppelte hier ist nur die Schreibweise im Quelltext.
    return (s:gsub('[%c"\\]', function(c)
        return escapes[c] or ("\\u%04x"):format(c:byte())
    end))
end

local function encodeNumber(n)
    if n ~= n or n == math.huge or n == -math.huge then
        return "null" -- NaN/Inf sind in JSON nicht darstellbar
    end
    if n == math.floor(n) and math.abs(n) < 2 ^ 53 then
        return ("%d"):format(n)
    end
    return ("%.14g"):format(n)
end

---Ist die Tabelle ein dichtes Array (1..n ohne Luecken)?
local function isArray(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    for i = 1, count do
        if t[i] == nil then return false end
    end
    return true, count
end

local encodeValue

---Schluessel sortieren, damit dieselben Daten denselben String ergeben.
local function sortedKeys(t)
    local keys = {}
    for k in pairs(t) do
        if type(k) == "string" or type(k) == "number" then
            keys[#keys + 1] = k
        end
    end
    table.sort(keys, function(a, b)
        if type(a) == type(b) then return a < b end
        return type(a) == "number"
    end)
    return keys
end

encodeValue = function(value, out)
    local t = type(value)
    if value == nil then
        out[#out + 1] = "null"
    elseif t == "boolean" then
        out[#out + 1] = value and "true" or "false"
    elseif t == "number" then
        out[#out + 1] = encodeNumber(value)
    elseif t == "string" then
        out[#out + 1] = '"' .. escapeString(value) .. '"'
    elseif t == "table" then
        local array, count = isArray(value)
        if array then
            out[#out + 1] = "["
            for i = 1, count do
                if i > 1 then out[#out + 1] = "," end
                encodeValue(value[i], out)
            end
            out[#out + 1] = "]"
        else
            out[#out + 1] = "{"
            local keys = sortedKeys(value)
            for i = 1, #keys do
                if i > 1 then out[#out + 1] = "," end
                out[#out + 1] = '"' .. escapeString(tostring(keys[i])) .. '":'
                encodeValue(value[keys[i]], out)
            end
            out[#out + 1] = "}"
        end
    else
        out[#out + 1] = "null" -- Funktionen, Userdata: nicht darstellbar
    end
end

---Serialisiert eine Lua-Tabelle deterministisch als JSON.
---@param value any
---@return string
function ns.ToJSON(value)
    local out = {}
    encodeValue(value, out)
    return table.concat(out)
end

--------------------------------------------------------------------------
-- Kodierung
--------------------------------------------------------------------------

---Packt einen String: Deflate + Base64. Faellt auf reines Base64 zurueck,
---falls die Kompression nicht verfuegbar ist.
---@param text string
---@return string|nil encoded, string|nil err
function ns.PackString(text)
    if not C_EncodingUtil then return nil, "C_EncodingUtil fehlt" end

    local payload = text
    local compressed = C_EncodingUtil.CompressString(text, Enum.CompressionMethod.Deflate)
    if compressed then payload = compressed end

    local encoded = C_EncodingUtil.EncodeBase64(payload)
    if not encoded then return nil, "Base64 fehlgeschlagen" end
    return encoded
end

---Erzeugt einen MDT-Importstring aus einer Preset-Tabelle.
---Format wie MythicDungeonTools/Modules/Transmission.lua: CBOR, Deflate, Base64.
---@param preset table
---@return string|nil importString, string|nil err
function ns.ToMDTString(preset)
    if not C_EncodingUtil then return nil, "C_EncodingUtil fehlt" end

    local serialized = C_EncodingUtil.SerializeCBOR(preset)
    if not serialized then return nil, "CBOR fehlgeschlagen" end

    local compressed = C_EncodingUtil.CompressString(serialized, Enum.CompressionMethod.Deflate)
    if not compressed then return nil, "Kompression fehlgeschlagen" end

    local encoded = C_EncodingUtil.EncodeBase64(compressed)
    if not encoded then return nil, "Base64 fehlgeschlagen" end

    return ns.MDT_STRING_PREFIX .. encoded
end

---Tage zwischen einem ISO-Datum (YYYY-MM-DD) und jetzt.
---@param iso string
---@return number|nil
function ns.DaysSince(iso)
    if type(iso) ~= "string" then return nil end
    local y, m, d = iso:match("^(%d%d%d%d)-(%d%d)-(%d%d)")
    if not y then return nil end
    local then_ = time({ year = tonumber(y), month = tonumber(m), day = tonumber(d), hour = 12 })
    if not then_ then return nil end
    return math.floor((time() - then_) / 86400)
end
