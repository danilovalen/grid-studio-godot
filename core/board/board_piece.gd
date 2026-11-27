class_name BoardPiece
extends Node3D

## One thing on the board that acts. It draws its parts and later plays motions on them. It never
## decides a rule.

var _parts_drawn: String = ""

@onready var _body: Node3D = %Body


## Draws the parts. If they are the same as last time, the meshes are kept.
func present(parts: Array[BoardPicture.Part]) -> void:
	var said := _describe(parts)
	if said == _parts_drawn:
		return
	_parts_drawn = said
	for child in _body.get_children():
		_body.remove_child(child)
		child.queue_free()
	for part in parts:
		var shown := MeshInstance3D.new()
		shown.mesh = Shapes.mesh(part)
		shown.position = part.offset
		shown.rotation_degrees = part.rotation
		_body.add_child(shown)


static func _describe(parts: Array[BoardPicture.Part]) -> String:
	var lines := PackedStringArray()
	for part in parts:
		lines.append(var_to_str([part.shape, part.size, part.offset, part.colour, part.rotation]))
	return "\n".join(lines)
