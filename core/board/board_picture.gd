class_name BoardPicture
extends RefCounted

## What a board shows, said in shapes and colours, with nothing of any one game in it. A game turns
## its own state into a picture, and the board draws the picture.
##
## The terrain is every cell of the board, row by row, each naming one of the terrain looks, such
## as a flat ground or a raised cell. The entities are everything that acts, each kept by its id, so
## the board can move the same node when an entity moves.


## One shape of an entity or a terrain look. offset is where its centre sits, from the middle of the
## cell's ground, in cells. rotation turns it, in degrees.
class Shape:
	enum Kind { BOX, CYLINDER, OCTAGON, PRISM, SPHERE }

	var kind := Kind.BOX
	var size := Vector3.ONE
	var offset := Vector3.ZERO
	var colour := Color.WHITE
	var rotation := Vector3.ZERO

	func _init(
		shape_kind := Kind.BOX,
		shape_size := Vector3.ONE,
		shape_offset := Vector3.ZERO,
		shape_colour := Color.WHITE,
		shape_rotation := Vector3.ZERO
	) -> void:
		kind = shape_kind
		size = shape_size
		offset = shape_offset
		colour = shape_colour
		rotation = shape_rotation

	## The mesh of this shape, at its size and in its colour.
	func mesh() -> Mesh:
		var made: PrimitiveMesh
		match kind:
			Kind.CYLINDER, Kind.OCTAGON:
				var round := CylinderMesh.new()
				round.top_radius = size.x / 2.0
				round.bottom_radius = size.x / 2.0
				round.height = size.y
				round.radial_segments = 8 if kind == Kind.OCTAGON else 24
				made = round
			Kind.PRISM:
				var prism := PrismMesh.new()
				prism.size = size
				made = prism
			Kind.SPHERE:
				var ball := SphereMesh.new()
				ball.radius = size.x / 2.0
				ball.height = size.y
				made = ball
			Kind.BOX:
				var box := BoxMesh.new()
				box.size = size
				made = box
		var material := StandardMaterial3D.new()
		material.albedo_color = colour
		made.material = material
		return made

	## Everything that decides how the shape looks, in one line, to tell two shapes apart.
	func describe() -> String:
		return var_to_str([kind, size, offset, colour, rotation])


## One entity that acts, at a cell, drawn as its shapes.
class Entity:
	var id: String = ""
	var cell := Vector2i.ZERO
	var shapes: Array[Shape] = []

	func _init(entity_id: String = "", entity_cell := Vector2i.ZERO) -> void:
		id = entity_id
		cell = entity_cell


var size := Vector2i.ZERO
## One look name per cell, row by row.
var terrain: Array[StringName] = []
## The one shape each terrain look is drawn with.
var terrain_looks: Dictionary[StringName, Shape] = {}
var entities: Array[Entity] = []


## The look name at a cell. The cell must be inside the board.
func terrain_at(cell: Vector2i) -> StringName:
	return terrain[cell.y * size.x + cell.x]
