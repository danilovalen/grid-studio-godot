class_name EntityView
extends Node3D

## Draws one entity of a board picture. It never decides a rule.

## The shapes this entity is drawn as. Setting them redraws it, and setting the same shapes again
## keeps its meshes. If you change a shape in place, nothing is redrawn until they are set again.
var shapes: Array[BoardPicture.Shape] = []:
	set = _set_shapes

var _drawn: String = ""

@onready var _body: Node3D = %Body


func _ready() -> void:
	_redraw()


func _set_shapes(new_shapes: Array[BoardPicture.Shape]) -> void:
	shapes = new_shapes
	if is_node_ready():
		_redraw()


func _redraw() -> void:
	var now := "\n".join(
		shapes.map(func(shape: BoardPicture.Shape) -> String: return shape.describe())
	)
	if now == _drawn:
		return
	_drawn = now
	for child in _body.get_children():
		_body.remove_child(child)
		child.queue_free()
	for shape in shapes:
		var shown := MeshInstance3D.new()
		shown.mesh = shape.mesh()
		shown.position = shape.offset
		shown.rotation_degrees = shape.rotation
		_body.add_child(shown)
