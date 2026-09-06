# Changelog

## Unreleased

<!-- Anything done to the addon itself goes here, one short line per change,
     written for players. New, changed and removed routes are added
     automatically at release time by tools/changelog.mjs - do not list them
     here. This section is emptied with every release. -->

- After `/routes submit`, the copy window now says when the route arrives in
  the game: with the next data update, up to four a day.

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
