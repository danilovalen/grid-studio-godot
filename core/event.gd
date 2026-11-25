class_name Event
extends RefCounted

## Something that happened during a step: its kind, the tick it happened on, and its details.
## Screens, sounds and feats read events; nothing else is told.

var kind: StringName
var tick: int = 0
var data: Dictionary = {}


func _init(p_kind: StringName = &"", p_tick: int = 0, p_data: Dictionary = {}) -> void:
	kind = p_kind
	tick = p_tick
	data = p_data
