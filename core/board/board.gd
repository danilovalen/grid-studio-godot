class_name Board
extends Node3D

## Draws a board picture. Its terrain goes in one grid map, and each entity is a EntityView kept by
## its id. Drawing the same picture again creates nothing new, and an entity that moved is the same
## node, moved.

const ENTITY_VIEW: PackedScene = preload("res://addons/studio/core/board/entity_view.tscn")

var grid := SquareGrid.new()
var _views: Dictionary[String, EntityView] = {}
var _terrain_items: Dictionary[StringName, int] = {}
var _terrain_drawn: String = ""

@onready var _terrain: GridMap = $Terrain
@onready var _entities: Node3D = $Entities


## Draws a picture. Nodes for entities still in it are reused.
func present(picture: BoardPicture) -> void:
	_present_terrain(picture)
	_present_entities(picture)


## The view drawing an entity, or null if the board has none with that id.
func entity_view(id: String) -> EntityView:
	return _views.get(id)


func _present_terrain(picture: BoardPicture) -> void:
	var looks := PackedStringArray()
	for look: StringName in picture.terrain_looks:
		looks.append("%s %s" % [look, picture.terrain_looks[look].describe()])
	var drawn := var_to_str([picture.size, picture.terrain, looks])
	if drawn == _terrain_drawn:
		return
	_terrain_drawn = drawn
	_terrain.clear()
	_terrain.mesh_library = _library(picture)
	_terrain.cell_size = Vector3(grid.cell_size, grid.level_height, grid.cell_size)
	_terrain.cell_center_y = false
	# A grid map's cells are (x, height, y), so the board's rows run along its third axis.
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


func _present_entities(picture: BoardPicture) -> void:
	var still: Dictionary[String, bool] = {}
	for entity in picture.entities:
		still[entity.id] = true
		var view: EntityView = _views.get(entity.id)
		if view == null:
			view = ENTITY_VIEW.instantiate()
			view.name = "Entity %s" % entity.id.validate_node_name()
			_entities.add_child(view)
			_views[entity.id] = view
		view.position = grid.to_world(Vector3i(entity.cell.x, entity.cell.y, 0))
		view.present(entity.shapes)
	for id: String in _views.keys():
		if not still.has(id):
			_entities.remove_child(_views[id])
			_views[id].queue_free()
			_views.erase(id)
