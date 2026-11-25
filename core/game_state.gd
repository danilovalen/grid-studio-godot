@abstract class_name GameState
extends RefCounted

## A game's whole state as plain data: its seats, a version, and the game's own fields.
## Never a node. A step returns a new state; the old one is kept for undo and replays.
## A game also offers a static `from_dict` beside `to_dict`.

var seats: Array[StringName] = []
var version: int = 0

@abstract func to_dict() -> Dictionary

@abstract func copy() -> GameState
