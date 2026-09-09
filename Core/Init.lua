-- Namensraum und Konstanten.
-- Laeuft als erste Datei; alles Weitere haengt sich hier ein.

local ADDON, ns = ...

ns.addonName = ADDON
-- Im Repo steht der Platzhalter @project-version@; der Packager ersetzt ihn
-- erst beim Release. Beim Entwickeln waere er sonst als Version zu sehen.
local version = C_AddOns.GetAddOnMetadata(ADDON, "Version")
ns.version = (version and not version:find("@", 1, true)) and version or "dev"

-- Namen fremder Addons an genau einer Stelle.
ns.DATA_ADDON   = "MDTRouteLibrary_Data"
ns.MDT_ADDON    = "MythicDungeonTools"
ns.MDT_UI_ADDON = "MythicDungeonTools_UI"

-- Zieladresse fuer Einreichungen. Ein Addon kann keinen Browser oeffnen, die
-- URL muss also zum Kopieren danebenstehen.
--
-- Es gibt zwei Issue-Vorlagen. Deutsche Clients bekommen die deutsche, alle
-- anderen die englische - sonst steht jemand vor einem Formular in einer
-- Sprache, die er nicht liest. Die Pruefung versteht beide Beschriftungssaetze
-- und antwortet in der Sprache der benutzten Vorlage.
local submitTemplate = GetLocale() == "deDE" and "route-submission.yml" or "route-submission-en.yml"
ns.SUBMIT_URL = "https://github.com/Ego26/MDTRouteLibrary/issues/new?template=" .. submitTemplate

-- Praefix der Einreich-Blobs. Die Zahl ist die Formatversion: aendert sich
-- das Schema, zaehlt sie hoch und tools/parse-submission.mjs weiss Bescheid.
ns.SUBMIT_PREFIX = "mdtrl1:"

-- Praefix der MDT-Importstrings ab MDT 6.2 (CBOR + Deflate + Base64).
-- Siehe MythicDungeonTools/Modules/Transmission.lua.
ns.MDT_STRING_PREFIX = "!~MDT2~"

-- Registry der geladenen Routen. Wird von MDTRouteLibrary_Data gefuellt.
ns.routes    = {}
ns.routeById = {}

-- Frueher vergebene Kennung -> heutige. Eine Route wird ueber ihre
-- Einreichungsnummer identifiziert; bekam sie einmal eine andere Kennung,
-- fuehrt sie die alte mit. Ohne diese Tabelle zeigten Favoriten, gespeicherte
-- Kopien und Bestzeiten nach einer Umbenennung ins Leere.
ns.aliasOf = {}

-- Stammdaten der Dungeons, zu denen es Routen gibt (Kurzname, NPC-Namen).
ns.dungeons    = {}
ns.dungeonById = {}

-- Metadaten des Datenpakets, von MDTRouteLibrary_Data/Manifest.lua gesetzt.
ns.manifest = nil

-- Oeffentliche Schnittstelle fuer andere Addons und WeakAuras.
MDTRouteLibrary = {}
ns.api = MDTRouteLibrary
