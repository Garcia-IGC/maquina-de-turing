extends RigidBody3D

@export var magnetic_sensitivity: float = 1.0
var magnetized: bool = false
var magnet_source: Vector3

func apply_magnetic_force(source_position: Vector3, strength: float):
	var direction = (source_position - global_transform.origin)
	var distance = direction.length()
	if distance < 2.0: # rango efectivo
		magnetized = true
		direction = direction.normalized()
		var force = direction * strength * magnetic_sensitivity / max(distance, 0.1)
		apply_central_force(force)

func detach():
	magnetized = false
