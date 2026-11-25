@abstract class_name Grid
extends RefCounted

## The one place that turns a cell (column, row, level) into a point in the world and back.
## Square today; another grid (hex) is another version of this, nothing else changes.

@abstract func to_world(cell: Vector3i) -> Vector3

@abstract func to_cell(point: Vector3) -> Vector3i

@abstract func neighbours(cell: Vector3i) -> Array[Vector3i]
