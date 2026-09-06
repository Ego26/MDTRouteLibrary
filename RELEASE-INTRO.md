MDT Route Library adds a route catalogue inside the Mythic Dungeon Tools
window. Browse routes, put one on the map, keep the ones you like — without
leaving the game.

## What it does

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

Your own presets are never modified or deleted. *Show on map* uses a single
preview slot per dungeon that gets overwritten next time; *Save to MDT* makes a
permanent copy that becomes an ordinary preset of yours, which the addon never
touches again.

## Adding your own route

Build it in MDT, type `/routes submit`, and paste the code into a submission on
GitHub. The checks run by themselves — a route that misses the full enemy
forces, or one for a dungeon outside the current season, is turned down with a
note saying why. Everything that passes goes out with the next update.

## Commands

- `/routes` — open the browser
- `/routes submit` — pack the route currently open in MDT for submission
- `/routes status` — data age and MDT connection
- `/routes cleanup` — remove preview presets from MDT

Requires Mythic Dungeon Tools. Not affiliated with Blizzard Entertainment, and
not an official part of Mythic Dungeon Tools.
