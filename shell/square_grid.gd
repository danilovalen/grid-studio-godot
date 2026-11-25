class_name SquareGrid
extends Grid

## Square cells lying on the ground: a cell's column runs along x, its row along z, its level up y.
## A cell's point is its centre on its level's floor.

var cell_size: float = 1.0
var level_height: float = 1.0


func to_world(cell: Vector3i) -> Vector3:
	return Vector3((cell.x + 0.5) * cell_size, cell.z * level_height, (cell.y + 0.5) * cell_size)


func to_cell(point: Vector3) -> Vector3i:
	return Vector3i(
		floori(point.x / cell_size), floori(point.z / cell_size), roundi(point.y / level_height)
	)


func neighbours(cell: Vector3i) -> Array[Vector3i]:
	return [
		cell + Vector3i(0, -1, 0),
		cell + Vector3i(1, 0, 0),
		cell + Vector3i(0, 1, 0),
		cell + Vector3i(-1, 0, 0),
	]
