class_name BoardPicture
extends RefCounted

## What a board shows, said in shapes and colours, with nothing of any one game in it. A game turns
## its own state into a picture, and the board draws the picture.
##
## The terrain is every cell of the board, row by row, each naming one of the terrain looks, such
## as a flat ground or a raised cell. The things are everything that acts, each kept by its id, so
## the board can move the same node when a thing moves.


## One shape of a look. offset is where its centre sits, from the middle of the cell's ground, in
## cells. rotation turns it, in degrees. A shape is a box, a cylinder, an octagon, a prism or a
## sphere.
class Part:
	var shape: StringName = &"box"
	var size := Vector3.ONE
	var offset := Vector3.ZERO
	var colour := Color.WHITE
	var rotation := Vector3.ZERO

	func _init(
		part_shape: StringName = &"box",
		part_size := Vector3.ONE,
		part_offset := Vector3.ZERO,
		part_colour := Color.WHITE,
		part_rotation := Vector3.ZERO
	) -> void:
		shape = part_shape
		size = part_size
		offset = part_offset
		colour = part_colour
		rotation = part_rotation


## One thing that acts, at a cell, drawn as its parts.
class Thing:
	var id: String = ""
	var cell := Vector2i.ZERO
	var parts: Array[Part] = []

	func _init(thing_id: String = "", thing_cell := Vector2i.ZERO) -> void:
		id = thing_id
		cell = thing_cell


var size := Vector2i.ZERO
## One look name per cell, row by row.
var terrain: Array[StringName] = []
## The one shape each terrain look is drawn with.
var terrain_looks: Dictionary[StringName, Part] = {}
var things: Array[Thing] = []


func terrain_at(cell: Vector2i) -> StringName:
	return terrain[cell.y * size.x + cell.x]
