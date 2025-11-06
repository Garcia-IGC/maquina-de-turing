extends RigidBody3D

@export var max_magnetic_force: float = 10.0
@export var min_distance: float = 0.1

func _physics_process(delta):
	# Si la pieza está casi quieta y muy cerca del imán, duerme el cuerpo (se pega)
	pass


func apply_magnetic_force(target_position: Vector3, strength: float):
	var direction = target_position - global_transform.origin
	var distance = direction.length()

	# Si está muy cerca, la pegamos y salimos
	

	# Evita división por cero(
	if distance == 0:
		return

	# Calcular fuerza con atenuación cuadrática (1 / distancia^2)
	var force_strength = clamp(strength / (distance * distance), 0, max_magnetic_force)
	var force = direction.normalized() * force_strength

	# Aplicar fuerza
	if force_strength != 0:
		apply_central_force(force)

func is_magnetic():
	return 1
