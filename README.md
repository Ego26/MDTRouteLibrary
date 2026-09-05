<div align="center">
  <img src="branding/png/banner-1696.png" width="100%"
       alt="MDT Route Library — kuratierte Mythic+-Routen, direkt in Mythic Dungeon Tools durchsuchbar">
</div>

Kuratierte Mythic+-Routen, direkt in **Mythic Dungeon Tools** durchsuchbar –
ohne Alt-Tab, ohne Copy-Paste.

Das Addon hängt sich als eigene Sektion in MDTs Fenster: Routen nach Dungeon
gruppiert, mit Gegnerkräften, Pull-Liste, Gegnervorschau und Zauber-Infos. Ein
Klick zeigt eine Route auf der Karte, ein weiterer übernimmt sie dauerhaft.

## Status

Frühe Entwicklung. Gebaut und geprüft gegen **MDT 6.2.13** (Client 12.0.1).
Addon, MDT-Anbindung, Einreich-Pfad, Generator und tägliche Pipeline stehen.
Was fehlt, ist der Inhalt – siehe [docs/02-Datenquellen.md](docs/02-Datenquellen.md).

## Wie es sich in MDT verhält

Wichtigster Grundsatz: **MDT bekommt nur, was der Nutzer will.**

| Aktion | Wirkung in MDT |
|---|---|
| Addon laden | Nichts wird eingetragen. Reste früherer Sitzungen werden aufgeräumt. |
| „Auf Karte zeigen" | Ein einziger Vorschauplatz je Dungeon, der beim nächsten Mal überschrieben wird. |
| „In MDT speichern" | Dauerhafte Kopie **ohne** unsere Markierung – ab da ein ganz normales Preset des Nutzers. |

Eine gespeicherte Community-Route erscheint in der Liste weiterhin nur einmal,
dann aber mit dem Vermerk, dass sie in MDT liegt. Wird sie dort gelöscht, fällt
der Vermerk weg.

## Aufbau

Zwei Addons:

| Ordner                    | Was                                                       |
|---------------------------|-----------------------------------------------------------|
| `Core/`                   | Das Addon: MDT-Anbindung, Browser, Einreich-Dialog, Theme. |
| `MDTRouteLibrary_Data/`   | **Generiert.** LoadOnDemand-Paket mit den Routen.          |

Die Trennung hat einen Grund: die Routendaten werden erst geladen, wenn MDT
aufgeht. Wer nie MDT öffnet, zahlt keinen Speicher.

Drumherum:

| Ordner        | Was                                                     |
|---------------|---------------------------------------------------------|
| `tools/`      | Node-Skripte für Build und Pipeline.                    |
| `data/routes` | Normalisierte Routen als JSON – die eigentliche Quelle.  |
| `data/mock`   | Testdaten, damit der Build ohne API-Schlüssel läuft.     |
| `docs/`       | Architektur, Datenquellen, Veröffentlichung.             |

## Befehle im Spiel

```
/routes             Browser öffnen (auch /mdtrl)
/routes list        installierte Routen im Chat
/routes status      Datenalter und MDT-Anbindung
/routes cleanup     Vorschau-Presets aus MDT entfernen
/routes submit      die in MDT geöffnete Route zum Einreichen verpacken
/routes copy <n>    MDT-Importstring einer Route zum Kopieren
```

## Entwickeln

Voraussetzungen: Node 20+, eine MDT-Installation (oder ein Checkout von
[Nnoggie/MythicDungeonTools](https://github.com/Nnoggie/MythicDungeonTools)).

```bash
# Datenaddon aus data/routes + data/cache bauen
node tools/build.mjs --mdt "C:/Spiele/World of Warcraft/_retail_/Interface/AddOns/MythicDungeonTools"

# Mit Testdaten arbeiten (kein API-Schlüssel nötig)
cp data/mock/ks-*.json data/cache/

# MDTs Dungeonkatalog und Saison-Listen ansehen
node tools/mdt-dungeons.mjs --mdt "<MDT-Pfad>"

# Eine Einreichung von Hand prüfen
node tools/parse-submission.mjs --file einreichung.txt --mdt "<MDT-Pfad>"
```

Ins Spiel kopieren:

```powershell
.\tools\sync.ps1            # einmalig
.\tools\sync.ps1 -Watch     # bei jeder Änderung
```

`tools/build.mjs` sagt über den Exitcode, ob sich etwas geändert hat:
`0` = neuer Inhalt, `9` = unverändert, `1` = Fehler. Die tägliche GitHub Action
veröffentlicht nur bei `0` – deshalb sieht niemand ein Update ohne neue Routen.

## Weiterführend

| Dokument | Inhalt |
|---|---|
| [docs/01-Architektur.md](docs/01-Architektur.md) | Wie die MDT-Anbindung funktioniert und warum so |
| [docs/02-Datenquellen.md](docs/02-Datenquellen.md) | Woher Routen kommen sollen, und was rechtlich gilt |
| [docs/04-Veroeffentlichen.md](docs/04-Veroeffentlichen.md) | Secrets, Projekt-IDs, erster Release |

## Mitmachen

Routen einreichen: `/routes submit` im Spiel, dann
[eine Einreichung anlegen](../../issues/new?template=route-submission.yml).
Jede Route wird vor der Aufnahme geprüft.

## Lizenz

Code: MIT. Eingereichte Routen bleiben bei ihren Autorinnen und Autoren; mit der
Einreichung geben sie die Veröffentlichung im Addon frei.

MDT Route Library steht in keiner Verbindung zu Blizzard Entertainment und ist
kein offizieller Teil von Mythic Dungeon Tools.
