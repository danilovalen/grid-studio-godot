class_name Board
extends Node3D

## Draws a board picture. Its terrain goes in one grid map, and each thing is a ThingView kept by
## its id. Drawing the same picture again creates nothing new, and a thing that moved is the same
## node, moved.

const THING_VIEW: PackedScene = preload("res://addons/studio/core/board/thing_view.tscn")

var grid := SquareGrid.new()
var _views: Dictionary[String, ThingView] = {}
var _terrain_items: Dictionary[StringName, int] = {}
var _terrain_drawn: String = ""

@onready var _terrain: GridMap = $Terrain
@onready var _things: Node3D = $Things


## Draws the whole picture from nothing, reusing every node that is still there.
func present(picture: BoardPicture) -> void:
	_present_terrain(picture)
	_present_things(picture)


## The view drawing a thing, or null if the board has none with that id.
func thing_view(id: String) -> ThingView:
	return _views.get(id)


func _present_terrain(picture: BoardPicture) -> void:
	var looks := PackedStringArray()
	for look: StringName in picture.terrain_looks:
		looks.append("%s %s" % [look, picture.terrain_looks[look].describe()])
	var said := var_to_str([picture.size, picture.terrain, looks])
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
		var shape := picture.terrain_looks[look]
		library.set_item_mesh(item, shape.mesh())
		var turn := Basis.from_euler(shape.rotation * PI / 180.0)
		library.set_item_mesh_transform(item, Transform3D(turn, shape.offset))
	return library


func _present_things(picture: BoardPicture) -> void:
	var still: Dictionary[String, bool] = {}
	for thing in picture.things:
		still[thing.id] = true
		var view: ThingView = _views.get(thing.id)
		if view == null:
			view = THING_VIEW.instantiate()
			view.name = "Thing %s" % thing.id.validate_node_name()
			_things.add_child(view)
			_views[thing.id] = view
		view.position = grid.to_world(Vector3i(thing.cell.x, thing.cell.y, 0))
		view.present(thing.shapes)
	for id: String in _views.keys():
		if not still.has(id):
			_views[id].queue_free()
			_views.erase(id)
