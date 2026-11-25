@abstract class_name Platform
extends RefCounted

## A store's or console's services behind one face: its name, achievements, and later cloud saves.
## The game talks to this, never to a store directly.

@abstract func platform_name() -> String

@abstract func unlock(achievement: StringName) -> void
