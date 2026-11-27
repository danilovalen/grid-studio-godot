class_name Board
extends Node3D

## Draws a board picture. Its terrain goes in one grid map, and its things are nodes kept by id.
## Drawing the same picture again creates nothing new, and a thing that moved is the same node,
## moved.

const PIECE: PackedScene = preload("res://addons/studio/core/board/piece.tscn")

var grid := SquareGrid.new()
var _pieces: Dictionary[String, BoardPiece] = {}
var _terrain_items: Dictionary[StringName, int] = {}
var _terrain_drawn: String = ""

@onready var _terrain: GridMap = $Terrain
@onready var _pieces_layer: Node3D = $Pieces


## Draws the whole picture from nothing, reusing every node that is still there.
func present(picture: BoardPicture) -> void:
	_present_terrain(picture)
	_present_pieces(picture)


## The node drawing a thing, or null if the board has none with that id.
func piece_node(id: String) -> BoardPiece:
	return _pieces.get(id)


func _present_terrain(picture: BoardPicture) -> void:
	var said := var_to_str([picture.size, picture.terrain, _looks_said(picture)])
	if said == _terrain_drawn:
		return
	_terrain_drawn = said
	_terrain.clear()
	_terrain.mesh_library = _library(picture)
	_terrain.cell_size = Vector3(grid.cell_size, grid.level_height, grid.cell_size)
	_terrain.cell_center_y = false
	for y in picture.size.y:
		for x in picture.size.x:
			var look := picture.terrain_at(Vector2i(x, y))
			_terrain.set_cell_item(Vector3i(x, 0, y), _terrain_items[look])


## One library item per terrain look.
func _library(picture: BoardPicture) -> MeshLibrary:
	var library := MeshLibrary.new()
	_terrain_items.clear()
	for look: StringName in picture.terrain_looks:
		var item := _terrain_items.size()
		_terrain_items[look] = item
		library.create_item(item)
		var part := picture.terrain_looks[look]
		library.set_item_mesh(item, Shapes.mesh(part))
		var turn := Basis.from_euler(part.rotation * PI / 180.0)
		library.set_item_mesh_transform(item, Transform3D(turn, part.offset))
	return library


static func _looks_said(picture: BoardPicture) -> String:
	var lines := PackedStringArray()
	for look: StringName in picture.terrain_looks:
		var part := picture.terrain_looks[look]
		lines.append(
			var_to_str([look, part.shape, part.size, part.offset, part.colour, part.rotation])
		)
	return "\n".join(lines)


func _present_pieces(picture: BoardPicture) -> void:
	var still: Dictionary[String, bool] = {}
	for thing in picture.things:
		still[thing.id] = true
		var node: BoardPiece = _pieces.get(thing.id)
		if node == null:
			node = PIECE.instantiate()
			node.name = "Piece %s" % thing.id.validate_node_name()
			_pieces_layer.add_child(node)
			_pieces[thing.id] = node
		node.position = grid.to_world(Vector3i(thing.cell.x, thing.cell.y, 0))
		node.present(thing.parts)
	for id: String in _pieces.keys():
		if not still.has(id):
			_pieces[id].queue_free()
			_pieces.erase(id)
