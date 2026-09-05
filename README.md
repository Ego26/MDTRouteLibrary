<div align="center">
  <img src="branding/banner-1696.png" width="100%"
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
Was fehlt, ist der Inhalt.

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

## Mitmachen

Routen einreichen: `/routes submit` im Spiel, dann
[eine Einreichung anlegen](../../issues/new?template=route-submission.yml).

Es wartet niemand auf eine Freigabe: die Einreichung wird automatisch geprüft
und bei bestandener Prüfung sofort aufgenommen, das Issue schließt sich
selbst. Geprüft wird:

| | |
|---|---|
| Einreichungs-Code | lässt sich dekodieren, Dungeon und jeder Gegner existieren in MDT |
| Gegnerkräfte | **mindestens 100 %** – darunter lässt sich der Schlüssel nicht abschließen |
| Dungeon | gehört zur laufenden Season |
| Name, Stufenbereich, Art | vorhanden und plausibel, unsichtbare Zeichen fliegen raus |
| Rechte | die Zusage im Formular ist gesetzt |

Fällt eine Einreichung durch, bleibt ihr Issue offen und bekommt einen
Kommentar mit den Mängeln. Jede Änderung am Issue startet die Prüfung neu.

**Bis sie im Spiel ankommt, dauert es etwas länger.** Addons dürfen nicht ins
Netz, die Routen stecken also fest im Paket. Alle sechs Stunden bündelt ein
Lauf alles Neue, baut das Datenaddon und lädt es zu CurseForge – ab dann kommt
es mit dem nächsten Addon-Update beim Spieler an. Gebündelt wird mit Absicht:
würde jede einzelne Einreichung ein Release auslösen, wären drei Routen an
einem Abend drei Update-Benachrichtigungen für jeden Nutzer. Ändert sich
nichts, gibt es auch kein Release.

### Wie viele Routen es pro Dungeon gibt

Aufgenommen wird jede Route, die die Prüfung besteht. Ins Paket kommen aber
höchstens **acht je Dungeon** – vierzig Vorschläge für einen Dungeon machen
die Liste im Spiel unbrauchbar, egal wie gültig jede einzelne ist.

Wer drin ist, entscheidet der 👍 am Einreich-Issue: wer eine Route gelaufen
ist und sie gut fand, klickt ihn. Bei Gleichstand zählt die höhere Abdeckung
der Gegnerkräfte, dann die kürzere Zeit – drei Daumen in fünf Tagen sind mehr
wert als drei in sechzig.

**Jede neue Route wird erst einmal ausgeliefert, ohne sich zu qualifizieren.**
Vierzehn Tage lang, dann zählt ihre Bilanz. Das ist keine Nettigkeit, sondern
notwendig: der Daumen hängt am Issue, gesehen wird eine Route aber im Spiel.
Ohne Schonfrist käme eine Route, die einmal unter der Grenze liegt, nie wieder
darüber – sie würde nie ausgeliefert, also nie gelaufen, also nie bewertet.
Höchstens die Hälfte der Plätze geht an Neulinge, damit fünf Einreichungen an
einem Abend nicht alles Bewährte verdrängen.

Zurückgestellte Routen bleiben im Repository und rücken nach, sobald sie mehr
Zustimmung haben als eine ausgelieferte. Grenze und Schonfrist lassen sich
über die Repository-Variable `MAX_ROUTES_PER_DUNGEON` und den Schalter
`--grace-days` ändern.

## Lizenz

Code: MIT. Eingereichte Routen bleiben bei ihren Autorinnen und Autoren; mit der
Einreichung geben sie die Veröffentlichung im Addon frei.

MDT Route Library steht in keiner Verbindung zu Blizzard Entertainment und ist
kein offizieller Teil von Mythic Dungeon Tools.
