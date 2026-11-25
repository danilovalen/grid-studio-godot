class_name StepResult
extends RefCounted

## What a step returns: the new state and the events of the step, in the order they happened.

var state: GameState
var events: Array[Event] = []


func _init(p_state: GameState = null, p_events: Array[Event] = []) -> void:
	state = p_state
	events = p_events
