class_name Board
extends Node3D

## Draws a board picture: its terrain in one grid map, and each entity as an EntityView kept by its
## id, so an entity that moves is the same node, moved.

const ENTITY_VIEW: PackedScene = preload("res://addons/studio/core/board/entity_view.tscn")

var grid := SquareGrid.new()
## What the board shows. Setting it redraws the board, reusing the nodes of entities still in it.
## If you change the picture in place, nothing is redrawn until it is set again.
var picture: BoardPicture = null:
	set = _set_picture
var _views: Dictionary[String, EntityView] = {}
var _terrain_items: Dictionary[StringName, int] = {}
var _terrain_drawn: String = ""

@onready var _terrain: GridMap = $Terrain
@onready var _entities: Node3D = $Entities


func _ready() -> void:
	_redraw()


func _set_picture(new_picture: BoardPicture) -> void:
	picture = new_picture
	if is_node_ready():
		_redraw()


## The view drawing an entity, or null if the board has none with that id.
func entity_view(id: String) -> EntityView:
	return _views.get(id)


func _redraw() -> void:
	if picture == null:
		return
	_redraw_terrain()
	_redraw_entities()


func _redraw_terrain() -> void:
	var looks := PackedStringArray()
	for look: StringName in picture.terrain_looks:
		looks.append("%s %s" % [look, picture.terrain_looks[look].describe()])
	var drawn := var_to_str([picture.size, picture.terrain, looks])
	if drawn == _terrain_drawn:
		return
	_terrain_drawn = drawn
	_terrain.clear()
	_terrain.mesh_library = _library()
	_terrain.cell_size = _cell_scale()
	_terrain.cell_center_y = false
	# A grid map's cells are (x, height, y), so the board's rows run along its third axis.
	for y in picture.size.y:
		for x in picture.size.x:
			var look := picture.terrain_at(Vector2i(x, y))
			assert(_terrain_items.has(look), "terrain look %s has no shape" % look)
			_terrain.set_cell_item(Vector3i(x, 0, y), _terrain_items[look])


## One library item per terrain look.
func _library() -> MeshLibrary:
	var library := MeshLibrary.new()
	_terrain_items.clear()
	for look: StringName in picture.terrain_looks:
		var item := _terrain_items.size()
		_terrain_items[look] = item
		library.create_item(item)
		library.set_item_mesh(item, _merged(picture.terrain_looks[look]))
	return library


## A look's shapes as one mesh, a surface for each surface of each shape, placed and scaled to the
## cell.
func _merged(look: BoardPicture.Look) -> ArrayMesh:
	var merged := ArrayMesh.new()
	var scale := _cell_scale()
	for shape in look.shapes:
		var part := shape.mesh()
		var turn := Basis.from_euler(shape.rotation * PI / 180.0)
		var placed := Transform3D(Basis.from_scale(scale) * turn, shape.offset * scale)
		for surface in part.get_surface_count():
			var tool := SurfaceTool.new()
			tool.append_from(part, surface, placed)
			tool.set_material(part.surface_get_material(surface))
			tool.commit(merged)
	return merged


func _redraw_entities() -> void:
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
		view.scale = _cell_scale()
		view.shapes = entity.shapes
	for id: String in _views.keys():
		if not still.has(id):
			_entities.remove_child(_views[id])
			_views[id].queue_free()
			_views.erase(id)


## How big one cell across and one level up are in the world.
func _cell_scale() -> Vector3:
	return Vector3(grid.cell_size, grid.level_height, grid.cell_size)
