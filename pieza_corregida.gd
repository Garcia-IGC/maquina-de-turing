extends RigidBody3D

@export var color_tag: String 

@export var max_magnetic_force: float = 4.5
@export var min_distance: float = 0.15
@export var snap_speed: float = 6.0

@onready var meshh: MeshInstance3D = $Mesh
@onready var mesh: MeshInstance3D = $ImanCorregido/MeshInstance3D
@onready var iman_pieza: Node3D = $ImanCorregido


func _ready() -> void:
	var mat: StandardMaterial3D = StandardMaterial3D.new()

	mat.albedo_color = Color(1, 0, 0)

	match color_tag:
		"rojo":
			mat.albedo_color = Color(1, 0, 0)
		"blanco":
			mat.albedo_color = Color(1, 1, 1)
		"negro":
			mat.albedo_color = Color(0, 0, 0)

	meshh.set_surface_override_material(0, mat)


func apply_magnetic_force(target_position: Vector3, strength: float) -> void:
	var direction: Vector3 = target_position - global_position
	var distance: float = direction.length()

	if distance < 0.001:
		return

	# ---------------------------
	# ZONA DE ATRACCIÓN NORMAL
	# ---------------------------
	if distance > min_distance:
		var force_strength: float = clamp(strength / (distance * distance), 0.0, max_magnetic_force)
		var force: Vector3 = direction.normalized() * force_strength
		apply_central_force(force)
		return

	# ---------------------------
	# ZONA SUAVE (LERP + DAMP)
	# ---------------------------

	linear_damp = 10.0
	angular_damp = 10.0

	var dt: float = get_physics_process_delta_time()
	global_position = global_position.lerp(target_position, snap_speed * dt)

	# CENTRAR SOLO IMÁN VISUAL
	var pos_im: Vector3 = iman_pieza.global_position
	pos_im.x = target_position.x
	pos_im.z = target_position.z
	iman_pieza.global_position = pos_im
	
func get_color_data():
	return color_tag
