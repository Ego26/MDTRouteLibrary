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
[eine Einreichung anlegen](../../issues/new?template=route-submission.yml) –
auf Englisch geht es
[hier entlang](../../issues/new?template=route-submission-en.yml). Das Addon
verlinkt von selbst die Vorlage, die zur Spielsprache passt, und der Bot
antwortet in der Sprache des benutzten Formulars.

Es geht auch **ohne das Addon**: MDTs eigener Export-String aus dem
*Share*-Fenster (`!~MDT2~…`) wird genauso angenommen. `/routes submit` bleibt
der bessere Weg, weil dieser Code den Dungeon beim Namen nennt statt über MDTs
interne Nummer und den Charakternamen als Autorenangabe mitbringt.

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

### Die Route bleibt ihrem Autor

Eine aufgenommene Route wird über die Nummer ihres Issues identifiziert, nicht
über ihren Inhalt. Deshalb kann ihr Autor sie später noch anfassen:

| | |
|---|---|
| **Ändern** | Das eigene Issue bearbeiten – auch das geschlossene. Die Route wird überschrieben und behält ihre Kennung, also auch die Favoriten und Bestzeiten, die Spieler auf ihr haben. |
| **Zurückziehen** | `/withdraw` als Kommentar ins eigene Issue. Die Route wird gelöscht und verschwindet mit dem nächsten Datenpaket bei allen Spielern. |

Zählen tut nur, was vom Einreichenden selbst kommt – sonst könnte jeder fremde
Routen aus der Bibliothek werfen. Der Betreiber kann dasselbe über das Label
`withdrawn` erreichen; es wieder zu entfernen nimmt die Route beim nächsten
Lauf zurück in die Bibliothek.

Eine Bearbeitung, die die Prüfung nicht besteht, wirft die bereits
veröffentlichte Fassung **nicht** weg. Sie bleibt stehen, das Issue geht wieder
auf und bekommt die Mängelliste.

**Sein Issue wiederfinden** muss dabei niemand von Hand:

- **Im Spiel** – die Route anwählen und auf die Herkunftszeile unter dem
  Namen klicken. Der Kopierdialog gibt die Adresse der Einreichung heraus.
- **Auf GitHub** – [`is:issue author:@me`](../../issues?q=is%3Aissue+author%3A%40me)
  zeigt nur die eigenen, unabhängig davon wie viele es insgesamt gibt. In der
  Issue-Liste ist das der Filter *Author → dein Name*.
- **Per Mail** – auf sein eigenes Issue ist man automatisch abonniert, die
  Annahme-Nachricht liegt also im Postfach und verlinkt direkt dorthin.

Das planmäßige Veröffentlichen lässt sich anhalten: Repository-Variable
`PUBLISH_PAUSED` auf `true`. Einreichungen werden weiter angenommen, nur
hochgeladen wird nichts mehr, bis die Variable wieder weg ist. Von Hand
auslösen geht auch dann.

**Bis sie im Spiel ankommt, dauert es etwas länger.** Addons dürfen nicht ins
Netz, die Routen stecken also fest im Paket. Alle sechs Stunden bündelt ein
Lauf alles Neue, baut das Datenaddon und lädt es zu CurseForge – ab dann kommt
es mit dem nächsten Addon-Update beim Spieler an. Gebündelt wird mit Absicht:
würde jede einzelne Einreichung ein Release auslösen, wären drei Routen an
einem Abend drei Update-Benachrichtigungen für jeden Nutzer. Ändert sich
nichts, gibt es auch kein Release.

### Wie viele Routen es pro Dungeon gibt

Alle, die die Prüfung bestehen. Es gibt keine Obergrenze und keine Auswahl
durch jemanden – was gültig ist, wird ausgeliefert.

Das ist bewusst so. Eine Rangfolge bräuchte ein Signal dafür, welche Route
gut ist, und dieses Signal gibt es nicht: das Addon darf nicht ins Netz, und
wer im Spiel eine Route lädt, geht danach nicht auf GitHub, um sie zu
bewerten. Jede Auswahl wäre also geraten. Statt zu raten liefern wir alles
aus und überlassen die Auswahl dem, der sie treffen kann: Der Browser im
Spiel filtert nach Name, Autor, Dungeon, Schlüsselstufe, Pull-Zahl und
Gegnerkräften, und Favoriten wandern nach oben.

## Lizenz

Code: MIT. Eingereichte Routen bleiben bei ihren Autorinnen und Autoren; mit der
Einreichung geben sie die Veröffentlichung im Addon frei.

MDT Route Library steht in keiner Verbindung zu Blizzard Entertainment und ist
kein offizieller Teil von Mythic Dungeon Tools.
