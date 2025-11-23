extends RigidBody3D

@export var max_magnetic_force: float = 12.0
@export var min_distance: float = 0.05   # 5.5 cm


func apply_magnetic_force(target_position: Vector3, strength: float):
	var direction: Vector3 = target_position - global_transform.origin
	var distance: float = direction.length()

	if distance < 0.001:
		return

	var force_strength: float = clamp(
		strength / (distance * distance),
		0.0,
		max_magnetic_force
	)

	# ------------------- ATRACCIÓN NORMAL -------------------
	if distance > min_distance:
		print("atrayendo")
		var force: Vector3 = direction.normalized() * force_strength
		apply_central_force(force)

	# ------------------- PEGADO SUAVE (CENTRADO) -------------------
	else:
		print("sue")
		var new_pos: Vector3 = global_transform.origin.lerp(target_position, 0.18)
		global_transform.origin = new_pos
