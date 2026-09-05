# Changelog

## 2026.09.05 – erste Veröffentlichung

Erstes Grundgerüst. Gebaut und geprüft gegen MDT 6.2.13 (Interface 120100).

### Addon
- Anbindung an MDT über `MythicDungeonToolsAPI:RegisterUIInitializer` – lädt
  MDTs Oberfläche nicht selbst nach.
- Routen werden als Presets in MDTs Datenbank eingetragen und beim nächsten
  Update anhand einer eigenen Markierung wieder ersetzt. Presets des Nutzers
  bleiben unangetastet.
- Dungeonindizes werden zur Laufzeit über den englischen Namen aufgelöst, nicht
  eingebacken – MDT nummeriert zwischen Versionen um.
- Eigene Erzeugung von MDT-Importstrings (`!~MDT2~`) über `C_EncodingUtil`,
  ohne fremde Bibliotheken.
- Einreich-Dialog: `/routes submit` packt die geöffnete Route in einen Blob zum
  Kopieren.
- Routendaten liegen im LoadOnDemand-Addon `MDTRouteLibrary_Data` und werden erst
  geladen, wenn MDT aufgeht.
- Deutsche und englische Sprachdateien.

### Toolchain
- `tools/lua-table.mjs` – kleiner Lua-Parser für MDTs Datendateien.
- `tools/mdt-dungeons.mjs` – liest MDTs Dungeonkatalog samt Gegnertabellen.
- `tools/keystone-convert.mjs` – keystone.guru-Routen nach MDT, mit
  Gegnerkräfte-Gegenrechnung als Selbsttest.
- `tools/parse-submission.mjs` – dekodiert Einreichungen, ergänzt NPC-IDs.
- `tools/collect-submissions.mjs` – holt freigegebene Einreichungen aus Issues.
- `tools/generate-lua.mjs` – erzeugt das Datenaddon deterministisch.
- `tools/build.mjs` – Gesamtbau; Exitcode 9 bedeutet „unverändert“.
- Tägliche GitHub Action, die nur bei geändertem Inhalt veröffentlicht.

### Offen
- Inhalt.
- Freigabe von Raider.IO für die Weiterverteilung von keystone.guru-Routen.
- Bedeutung von `mdtIndex` in der keystone.guru-API (klärt sich mit dem ersten
  echten API-Aufruf).
