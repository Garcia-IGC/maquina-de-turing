extends RigidBody3D

@export var max_magnetic_force: float = 30.0
@export var min_distance: float = 70

func _physics_process(delta):
	# Si la velocidad es casi cero, duerme el cuerpo
	pass

func apply_magnetic_force(target_position: Vector3, strength: float):
	var direction = target_position - global_transform.origin
	var distance = direction.length()

	# Evita división por cero
	if distance < 0.01:
		return

	# Calcular fuerza con atenuación
	var force_strength = clamp(strength / (distance * distance), 0, max_magnetic_force)

	# Evita aplicar fuerza si ya está muy cerca (para reducir solapamiento)
	if distance > min_distance:
		var force = direction.normalized() * force_strength
		apply_central_force(force)
	else:
		# Si está muy cerca, "corrige" la posición suavemente
		global_transform.origin = global_transform.origin.lerp(target_position, 0.1)
