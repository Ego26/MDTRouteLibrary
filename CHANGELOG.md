# Changelog

## Unreleased

<!-- Anything done to the addon itself goes here, one short line per change,
     written for players. New, changed and removed routes are added
     automatically at release time by tools/changelog.mjs - do not list them
     here. This section is emptied with every release. -->

## 2026.10.29.1

Maintenance release. No changes to routes or dungeon data.

## 2026.10.28.1

Dungeon data rebuilt against Mythic Dungeon Tools 6.3.26.

## 2026.10.27.1

Dungeon data rebuilt against Mythic Dungeon Tools 6.3.25.

## 2026.10.26.1

Dungeon data rebuilt against Mythic Dungeon Tools 6.3.23.

## 2026.10.25.1

Dungeon data rebuilt against Mythic Dungeon Tools 6.3.22.

## 2026.10.24.1

Maintenance release. No changes to routes or dungeon data.

## 2026.10.23.2

Dungeon data rebuilt against Mythic Dungeon Tools 6.3.20.

## 2026.10.23.1

Dungeon data rebuilt against Mythic Dungeon Tools 6.3.16.

## 2026.10.21.1

Dungeon data rebuilt against Mythic Dungeon Tools 6.3.10.

## 2026.10.20.1

- Russian translation, contributed by Hollicsh.

## 2026.10.19.1

Maintenance release. No changes to routes or dungeon data.

## 2026.10.18.1

Dungeon data rebuilt against Mythic Dungeon Tools 6.3.9.

## 2026.10.17.1

Dungeon data rebuilt against Mythic Dungeon Tools 6.3.8.

## 2026.10.16.1

### Top Routes — the routes the best groups actually run

A new tab next to *Community* and *My routes*, built on the Raider.IO
leaderboard. It answers the question you would otherwise alt-tab for:
which composition cleared this dungeon at this key level, how fast, and
where is the route they ran.

**It is not just the world first.** The top of any leaderboard is a single
composition on a single key level — in Altar of Fangs, ranks 1 to 21 are
all Blood Death Knights at +20. Ten routes like that answer one question
and no others. So the selection covers what people actually ask:

- **Every tank specialisation.** The first Guardian Druid in Altar of Fangs
  is rank 28, the first Protection Warrior rank 107, the first Vengeance
  Demon Hunter rank 211. They are all in.
- **A wide spread of key levels**, from +11 up to the current top. A
  world-first run is not what you play on a +12: it opens with four mobs
  and takes 28 minutes, where a +12 opens with eleven and is done in 21.
- **Quick and safe, side by side.** On the same key level a fast run sits
  next to a careful one, and each entry says which it is.

Filter by key level, pace, class and specialisation; the lists only ever
offer values that lead somewhere. Every run carries its group in class
colours, its clear time, its rank, and a link back to raider.io.

**And they are the real routes, not estimates.** Raider.IO records which
enemies died and when — not which of nine identically named ones it was, or
where a pull ended. Rebuilding a route from that was possible; it looked
convincing and it was not the route that was played.

The run's own combat log knows both. Nearly every one of these groups
records, and Warcraftlogs hands out what the log contains: which instance of
an enemy fell, where it stood, when it was first hit. Raider.IO never names
the report — but it names the roster, the realm and the time, and that is
enough to find it. Measured against three real keystone.guru routes, the
result matches 96, 100 and 98 per cent of the enemies.

Where no report turns up, the run is left out. An entry that only links to
keystone.guru gives you nothing you did not already have — you would leave
the window, open the route there, copy the MDT string and switch back, which
is the exact detour this addon exists to remove.

Said just as plainly: **they are not identical copies.** Against the three
comparison routes, between zero and six enemies differ, and the boundaries
between pulls land less reliably than the choice of enemies. What is in a
route is in the log; where exactly one pull ends is inferred from the gaps
between first contacts, not read off. Every route names the Warcraftlogs
report it came from, so you can check.

A run is only listed when it was timed with the full enemy forces, its
owner allows the route to be shown, a route was actually published, and its
combat log could be found. Without all four it stays out.

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
- Updated for World of Warcraft 12.1.5.

## 2026.10.08.2

Dungeon data rebuilt against Mythic Dungeon Tools 6.3.5.

## 2026.10.08.1

Dungeon data rebuilt against Mythic Dungeon Tools 6.3.4.

## 2026.10.07.1

Dungeon data rebuilt against Mythic Dungeon Tools 6.3.2.

## 2026.09.25.1

Dungeon data rebuilt against Mythic Dungeon Tools 6.2.20.

## 2026.09.22.1

Dungeon data rebuilt against Mythic Dungeon Tools 6.2.19.

## 2026.09.21.1

Dungeon data rebuilt against Mythic Dungeon Tools 6.2.18.

## 2026.09.09.2

Maintenance release. No changes to routes or dungeon data.

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
