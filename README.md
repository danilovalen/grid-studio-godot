# Grid Studio for Godot

The studio's shared Godot toolkit. Each game pulls it in as a git submodule at `addons/studio/`, pinned to
one commit, and moves it forward on purpose.

Two layers:

- **`shell/`**, for any game: the stage, input actions and prompts, the Theme and components, the motion table,
  saves and the profile, unlocks and achievements, audio and music, text tables, the platform adapter, the grid.
- **`core/`**, for turn-based and tick-based grid games (wee, Cell, Seeds): the rules' shape, state, intents and
  events, the run host, beats, the board kept by id, the cell picker, the board camera, maps as data.

Nothing goes in until a game's step needs it.

## The one rule

**The toolkit never names a game.** No file here mentions a game's pieces, levels or rules. When a game needs
something of its own, the toolkit offers a hook and the game fills it. Each game's own checks hold this
against its own words.

## Working on it

- Style: `gdformat --check .` and `gdlint .` from this folder (gdtoolkit 4.5.0).
- Tests: `tests/`, run by GUT from a game that includes the toolkit.
- Typed GDScript throughout; every base says its job in its first lines and marks what a game must fill in
  `@abstract` (Godot 4.5 and later).
