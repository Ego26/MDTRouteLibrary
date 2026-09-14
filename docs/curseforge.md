# MDT Route Library

*Die Beschreibung für die CurseForge-Projektseite. Dort einfügen, wenn sie
sich ändert — CurseForge speichert sie nur auf der Website, nicht im
Repository. Englisch, weil die Seite international gelesen wird; das Addon
selbst spricht Deutsch und Englisch.*

---

**Mythic+ routes inside Mythic Dungeon Tools. No alt-tab, no copy-paste.**

MDT Route Library adds its own section to MDT's window. Browse routes grouped
by dungeon, see the enemy forces, the pull list, every enemy and every ability
— then put a route on the map with one click, or keep it as a preset of your
own.

## Top Routes — what the best groups actually run

A tab built on the Raider.IO leaderboard. It answers the question you would
otherwise alt-tab for: which composition cleared this dungeon at this key
level, how fast, and where is the route they ran.

The top of a leaderboard is a single composition on a single key level — in
Altar of Fangs, ranks 1 to 21 are all Blood Death Knights at +20. Ten routes
like that answer one question and no others. So the selection covers what
people actually ask:

* **Every tank specialisation.** The first Guardian Druid in Altar of Fangs is
  rank 28, the first Protection Warrior rank 107, the first Vengeance Demon
  Hunter rank 211. They are all in.
* **A wide spread of key levels**, from +11 up to the current top. A
  world-first run is not what you play on a +12: it opens with four mobs and
  takes 28 minutes, where a +12 opens with eleven and is done in 21.
* **Quick and safe, side by side.** On the same key level a fast run sits next
  to a careful one, and each entry says which it is.

Filter by key level, pace, class and specialisation — the lists only offer
values that lead somewhere. Every run shows its group in class colours, its
clear time, its rank, and links back to raider.io.

**And they are the real routes, not estimates.** Raider.IO records which
enemies died and when, not which of nine identically named ones it was, or
where a pull ended — so the run's own combat log does the work instead.
Warcraftlogs hands out what the log contains: which instance of an enemy
fell, where it stood, when it was first hit. Measured against three real
keystone.guru routes, the result matches 96, 100 and 98 per cent of the
enemies.

Where no report turns up, the entry stays a link to keystone.guru rather than
becoming a guess. Every rebuilt route names the Warcraftlogs report it came
from, so you can watch the run it describes.

A run is only listed when it was timed with the full enemy forces, its owner
allows the route to be shown, and a route was actually published.

## What else it does

* **Enemy forces as a percentage** of what the dungeon needs, so you see before
  you commit whether a route finishes the key.
* **Every pull broken down** into the enemies it contains, with a running
  total, collapsible.
* **Enemy details on hover:** 3D model, level, type, health, and every ability
  — interrupts outlined, dispel types colour coded, with the classes that can
  handle them.
* **A map preview** you can pan and zoom, with pull outlines in MDT's own
  colours and the pull under your cursor highlighted in the list beside it.
* **Your own times.** The addon records how long you took on a route and ranks
  them, so you can see which one is actually fastest for you.
* **Favourites** move to their own section at the top.

## It leaves your MDT alone

Nothing is written to your preset list when the addon loads.

| Action | What happens in MDT |
|---|---|
| Loading the addon | Nothing is added. Leftovers from earlier sessions are cleaned up. |
| *Show on map* | One preview slot per dungeon, overwritten next time. |
| *Save to MDT* | A permanent copy that becomes an ordinary preset of yours — the addon never touches it again. |

Your own presets are never modified or deleted.

## Submitting your own routes

Build it in MDT, type `/routes submit`, paste the code into a submission on
GitHub. No waiting for approval: the submission is checked automatically and
accepted on the spot. The route stays yours — edit the issue to change it, or
comment `/withdraw` to take it back out.

MDT's own export string from the *Share* window works too, if you would rather
not use the command.

## Commands

```
/routes             open the browser (also /mdtrl)
/routes status      data age and MDT connection
/routes submit      pack the route currently open in MDT for submission
/routes cleanup     remove preview presets from MDT
```

## Requirements

[Mythic Dungeon Tools](https://www.curseforge.com/wow/addons/mythic-dungeon-tools).
Built and tested against MDT 6.2.16.

Not affiliated with Blizzard Entertainment, and not an official part of Mythic
Dungeon Tools. Run data from [Raider.IO](https://raider.io), used under their
API terms with attribution.
