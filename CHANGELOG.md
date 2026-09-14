# Changelog

## Unreleased

<!-- Anything done to the addon itself goes here, one short line per change,
     written for players. New, changed and removed routes are added
     automatically at release time by tools/changelog.mjs - do not list them
     here. This section is emptied with every release. -->

### Top Routes — the routes the best groups actually run

A new tab next to *Community* and *My routes*. It shows what the fastest
groups in the world ran, pull for pull, on the map, ready to import into
MDT. The runs come from the Raider.IO leaderboard and are rebuilt into
real MDT routes — not screenshots, not links: routes you can put on the
map and follow.

**It is not just the world first.** The top of any leaderboard is a single
composition on a single key level — in Altar of Fangs, ranks 1 to 21 are
all Blood Death Knights at +20. Ten routes like that answer one question
and no others. So the selection covers what people actually ask:

- **Every tank specialisation.** The first Guardian Druid in Altar of Fangs
  is rank 28, the first Protection Warrior rank 107, the first Vengeance
  Demon Hunter rank 211. They are all in.
- **Every key level from +10 up**, with no gaps. A world-first run is not
  what you play on a +12: it opens with four mobs and takes 28 minutes,
  where a +12 opens with eleven and is done in 21.
- **Quick and safe, side by side.** At +14 in Altar of Fangs one Guardian
  Druid took 23:47 over 22 pulls, another 27:34 over 33. Both are in, and
  each route says which it is.

Filter by key level, pace, class and specialisation; the lists only ever
offer values that lead somewhere. Every run carries its group in class
colours, its clear time, its rank, and a link back to raider.io.

**One thing said plainly:** Raider.IO records which enemies died and when,
not which of the identically named ones it was. The order of the pulls and
what they contain is exact; the positions are reconstructed from the path
the group took. Routes say so, and where an enemy had to be added back
because the log omits it entirely, they say that too.

Runs are only taken when the owner allows their route to be shown, and
only when they were timed with the full enemy forces.

### Also

- Enemy forces were counted 15 too low in Temple of Sethraliss, for every
  route including your own. A single spawn may award more forces than its
  siblings, and those were being ignored. Percentages now agree with what
  MDT shows next to them.
- Filter routes by key level range, pace, class and specialisation. The
  lists are built from the routes that are actually loaded, so they never
  offer a choice that leads nowhere.
- When nothing matches, the list names the filter that is too narrow, and
  in which dungeons your search would find something.
- The filter for enemy forces is gone. It filtered nothing: a submission
  below 100% is never accepted, and a timed run had them anyway.
- "Reset" in the filter panel no longer leaves old labels behind.

## 2026.09.09.2

- Route authors can now change or withdraw their own routes: edit the
  submission issue to update, comment /withdraw to take it out. A route keeps
  its identity across edits, so favourites and best times survive.
- A "View submission" button in the route details hands you the address the
  route came from - for your own submissions, the page where you change or
  withdraw it.

## 2026.09.09.1

Two new routes across two dungeons.

### New routes

- **Altar of Fangs +17** — Altar of Fangs, +17 and up, Meta, by Ego26 (15 pulls)
- **Kings Rest +16** — King's Rest, +16 and up, Meta, by Ego26 (12 pulls)

## 2026.09.08.3

Dungeon data rebuilt against Mythic Dungeon Tools 6.2.16.

## 2026.09.08.2

Maintenance release. No changes to routes or dungeon data.

## 2026.09.08.1

- After `/routes submit`, the copy window now says when the route arrives in
  the game: with the next data update, up to four a day.
- The map preview no longer lingers on screen after you close MDT or switch to
  another section.

## 2026.09.06.2

- The submission link from `/routes submit` now opens the form in your game's
  language — German clients get the German template, everyone else the English
  one.

## 2026.09.06.1

The library is no longer empty: the first player-submitted route is in.

### New route

- **Its a honor to run with you guys!** — Den of Nalorakk, +10 to +16, Meta, by Ego26 (15 pulls)

## 2026.09.05.1 — first release

MDT Route Library adds a route catalogue inside the Mythic Dungeon Tools
window. Browse routes, put one on the map, keep the ones you like — without
leaving the game.

**The library is still empty.** This release brings the addon and the dungeon
data for the current season; the routes come from players. Adding one takes a
minute: build it in MDT, type `/routes submit`, paste the code into a
submission on GitHub. Approved routes go out with the next update.

### What it does

- A browsable list inside MDT's own window, grouped by dungeon. Search by
  name, author or dungeon; filter by key level, pull count or enemy forces.
- Enemy forces shown as a percentage of what the dungeon needs, so you see
  before you commit whether a route actually finishes the key.
- Every pull broken down into the enemies it contains, with a running total.
- Enemy details on hover: 3D model, level, type, health, and every ability —
  interrupts outlined, dispel types colour coded.
- A map preview you can pan and zoom, with the pull under your cursor
  highlighted in the list beside it.
- Favourites move to their own section at the top.

### It leaves your MDT alone

Nothing is written to your preset list when the addon loads. *Show on map*
uses a single preview slot per dungeon that gets overwritten next time. *Save
to MDT* makes a permanent copy that becomes an ordinary preset of yours — the
addon never touches it again. Your own presets are never modified or deleted.

### Commands

- `/routes` — open the browser
- `/routes submit` — pack the route currently open in MDT for submission
- `/routes status` — data age and MDT connection
- `/routes cleanup` — remove preview presets from MDT

### Requirements

Mythic Dungeon Tools. Built and tested against MDT 6.2.13 (Interface 120100).

Not affiliated with Blizzard Entertainment, and not an official part of Mythic
Dungeon Tools.
