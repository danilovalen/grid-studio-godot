extends GutTest

## The board draws a picture, and drawing again reuses its nodes. The same picture makes nothing
## new, and an entity that moved or changed its look keeps its node.

const BOARD: PackedScene = preload("res://addons/studio/core/board/board.tscn")

const BOX := BoardPicture.Shape.Kind.BOX

var board: Board


func before_each() -> void:
	board = BOARD.instantiate()
	add_child_autofree(board)


func _picture(crate_cell: Vector2i, crate_colour: Color) -> BoardPicture:
	var picture := BoardPicture.new()
	picture.size = Vector2i(3, 2)
	picture.terrain_looks = {
		&"ground": BoardPicture.Shape.new(BOX, Vector3(1, 0.1, 1), Vector3(0, -0.05, 0)),
		&"raised": BoardPicture.Shape.new(BOX, Vector3.ONE, Vector3(0, 0.5, 0)),
	}
	picture.terrain.assign([&"raised", &"ground", &"ground", &"ground", &"ground", &"raised"])
	var crate := BoardPicture.Entity.new("crate", crate_cell)
	crate.shapes = [BoardPicture.Shape.new(BOX, Vector3(0.8, 0.8, 0.8), Vector3.ZERO, crate_colour)]
	var lamp := BoardPicture.Entity.new("lamp", Vector2i(2, 0))
	lamp.shapes = [BoardPicture.Shape.new(BoardPicture.Shape.Kind.SPHERE, Vector3(0.5, 0.5, 0.5))]
	picture.entities = [crate, lamp]
	return picture


func _count_nodes(node: Node) -> int:
	var count := 1
	for child in node.get_children():
		count += _count_nodes(child)
	return count


func test_the_terrain_fills_every_cell() -> void:
	board.picture = _picture(Vector2i(1, 0), Color.RED)
	var terrain: GridMap = board.get_node("Terrain")
	assert_eq(terrain.get_used_cells().size(), 6)


func test_the_same_picture_twice_makes_no_new_node() -> void:
	board.picture = _picture(Vector2i(1, 0), Color.RED)
	var before := _count_nodes(board)
	var crate := board.entity_view("crate")
	board.picture = _picture(Vector2i(1, 0), Color.RED)
	assert_eq(_count_nodes(board), before)
	assert_same(board.entity_view("crate"), crate)


func test_an_entity_that_moves_is_the_same_node_moved() -> void:
	board.picture = _picture(Vector2i(1, 0), Color.RED)
	var crate := board.entity_view("crate")
	var was := crate.position
	board.picture = _picture(Vector2i(1, 1), Color.RED)
	assert_same(board.entity_view("crate"), crate)
	assert_ne(crate.position, was)


func test_an_entity_that_changes_its_look_keeps_its_node() -> void:
	board.picture = _picture(Vector2i(1, 0), Color.RED)
	var crate := board.entity_view("crate")
	board.picture = _picture(Vector2i(1, 0), Color.BLUE)
	assert_same(board.entity_view("crate"), crate)


func test_an_entity_that_left_is_removed() -> void:
	board.picture = _picture(Vector2i(1, 0), Color.RED)
	var picture := _picture(Vector2i(1, 0), Color.RED)
	picture.entities.resize(1)
	board.picture = picture
	assert_null(board.entity_view("lamp"))
	assert_eq(board.get_node("Entities").get_child_count(), 1)


func test_an_entity_that_comes_back_keeps_its_name() -> void:
	board.picture = _picture(Vector2i(1, 0), Color.RED)
	var picture := _picture(Vector2i(1, 0), Color.RED)
	picture.entities.resize(1)
	board.picture = picture
	board.picture = _picture(Vector2i(1, 0), Color.RED)
	assert_eq(String(board.entity_view("lamp").name), "Entity lamp")


func test_the_grid_sets_how_big_a_cell_and_a_level_are() -> void:
	board.grid.level_height = 2.0
	board.picture = _picture(Vector2i(1, 0), Color.RED)
	var terrain: GridMap = board.get_node("Terrain")
	var raised: Transform3D = terrain.mesh_library.get_item_mesh_transform(1)
	assert_eq(raised.basis.get_scale(), Vector3(1, 2, 1))
	assert_eq(raised.origin, Vector3(0, 1, 0))
	assert_eq(board.entity_view("crate").scale, Vector3(1, 2, 1))


func test_a_picture_set_before_the_board_is_ready_is_drawn_when_it_is() -> void:
	var early: Board = BOARD.instantiate()
	early.picture = _picture(Vector2i(1, 0), Color.RED)
	add_child_autofree(early)
	assert_not_null(early.entity_view("crate"))
	assert_eq(early.entity_view("crate").get_node("%Body").get_child_count(), 1)


func test_shapes_set_before_the_view_is_ready_are_drawn_when_it_is() -> void:
	var view: EntityView = preload("res://addons/studio/core/board/entity_view.tscn").instantiate()
	view.shapes = [BoardPicture.Shape.new()]
	add_child_autofree(view)
	assert_eq(view.get_node("%Body").get_child_count(), 1)
