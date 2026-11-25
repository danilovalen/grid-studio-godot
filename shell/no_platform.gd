class_name NoPlatform
extends Platform

## No store: the web build and development. Asks for nothing and does nothing.


func platform_name() -> String:
	return "none"


func unlock(_achievement: StringName) -> void:
	pass
