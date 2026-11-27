class_name ThingView
extends Node3D

## Draws one thing of a board picture, and later plays its motions. It never decides a rule.

var _drawn: String = ""

@onready var _body: Node3D = %Body


## Draws the shapes. If they are the same as last time, the meshes are kept.
func present(shapes: Array[BoardPicture.Shape]) -> void:
	var drawn := "\n".join(
		shapes.map(func(shape: BoardPicture.Shape) -> String: return shape.describe())
	)
	if drawn == _drawn:
		return
	_drawn = drawn
	for child in _body.get_children():
		_body.remove_child(child)
		child.queue_free()
	for shape in shapes:
		var shown := MeshInstance3D.new()
		shown.mesh = shape.mesh()
		shown.position = shape.offset
		shown.rotation_degrees = shape.rotation
		_body.add_child(shown)
