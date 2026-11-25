class_name Intent
extends RefCounted

## What a player asked for: a seat, an action and its arguments.
## Plain data; the rules decide what it does.

var seat: StringName
var action: StringName
var args: Dictionary = {}


func _init(p_seat: StringName = &"", p_action: StringName = &"", p_args: Dictionary = {}) -> void:
	seat = p_seat
	action = p_action
	args = p_args
