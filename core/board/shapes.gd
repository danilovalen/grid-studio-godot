class_name Shapes
extends RefCounted

## Makes the mesh for one part of a look, at its size and in its colour.

const SHAPES: Array[StringName] = [&"box", &"cylinder", &"octagon", &"prism", &"sphere"]


static func mesh(part: BoardPicture.Part) -> Mesh:
	var made: PrimitiveMesh
	match part.shape:
		&"cylinder", &"octagon":
			var round := CylinderMesh.new()
			round.top_radius = part.size.x / 2.0
			round.bottom_radius = part.size.x / 2.0
			round.height = part.size.y
			round.radial_segments = 8 if part.shape == &"octagon" else 24
			made = round
		&"prism":
			var prism := PrismMesh.new()
			prism.size = part.size
			made = prism
		&"sphere":
			var ball := SphereMesh.new()
			ball.radius = part.size.x / 2.0
			ball.height = part.size.y
			made = ball
		_:
			var box := BoxMesh.new()
			box.size = part.size
			made = box
	var material := StandardMaterial3D.new()
	material.albedo_color = part.colour
	made.material = material
	return made
