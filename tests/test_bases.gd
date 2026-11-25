extends GutTest


class TallyState:
	extends GameState
	var count: int = 0

	func to_dict() -> Dictionary:
		return {"count": count, "version": version}

	func copy() -> GameState:
		var other := TallyState.new()
		other.count = count
		other.version = version
		other.seats = seats.duplicate()
		return other


func test_a_copied_state_is_its_own() -> void:
	var state := TallyState.new()
	state.seats = [&"one"]
	var other := state.copy() as TallyState
	other.count = 3
	other.seats.append(&"two")
	assert_eq(state.count, 0)
	assert_eq(state.seats.size(), 1)


func test_no_platform_asks_for_nothing() -> void:
	var platform := NoPlatform.new()
	platform.unlock(&"anything")
	assert_eq(platform.platform_name(), "none")


func test_an_intent_and_an_event_keep_what_they_are_given() -> void:
	var intent := Intent.new(&"one", &"move", {"dir": 1})
	var event := Event.new(&"moved", 2)
	assert_eq([intent.seat, intent.action, intent.args["dir"]], [&"one", &"move", 1])
	assert_eq([event.kind, event.tick], [&"moved", 2])
