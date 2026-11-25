extends GutTest


func test_a_cell_comes_back_from_its_point() -> void:
	var grid := SquareGrid.new()
	for cell: Vector3i in [Vector3i(0, 0, 0), Vector3i(3, 5, 1), Vector3i(-2, 7, 0)]:
		assert_eq(grid.to_cell(grid.to_world(cell)), cell)


func test_a_point_is_the_cell_centre() -> void:
	var grid := SquareGrid.new()
	grid.cell_size = 2.0
	assert_eq(grid.to_world(Vector3i(1, 2, 0)), Vector3(3.0, 0.0, 5.0))


func test_a_cell_has_four_neighbours() -> void:
	var near := SquareGrid.new().neighbours(Vector3i(2, 2, 0))
	assert_eq(near.size(), 4)
	assert_true(near.has(Vector3i(2, 1, 0)) and near.has(Vector3i(1, 2, 0)))
