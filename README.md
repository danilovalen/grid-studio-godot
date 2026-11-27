# Grid Studio for Godot

The studio's shared Godot toolkit. Each game pulls it in as a git submodule at `addons/studio/`, pinned to
one commit, and moves it forward on purpose.

Two layers:

- **`shell/`**, for any game: the grid, and the platform adapter.
- **`core/`**, for turn-based and tick-based grid games: the rules' shape, the game state, intents and events, and the
  board.

Something goes in only when a game needs it.

## The one rule

**The toolkit never names a game.** No file here mentions a game's pieces, levels or rules. When a game needs
something of its own, the toolkit offers a hook and the game fills it. Each game's own checks hold this
against its own words.

## Working on it

- Style: `gdformat --check .` and `gdlint .` from this folder (gdtoolkit 4.5.0).
- Tests: `tests/`, run by GUT from a game that includes the toolkit.
- Every script is typed GDScript. Each base class says its job in its first lines, and marks what a game must fill in
  with `@abstract`.
