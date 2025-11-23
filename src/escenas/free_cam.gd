extends Camera3D

@export var speed := 1.0
@export var fast_speed := 10
var mouse_sensitivity := 0.002

var mouse_free := false  # false = cámara libre, mouse atrapado

func _ready():
	# El mouse parte atrapado (modo FPS)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	# ---------------------------------------------------
	# 🔄 Toggle ALT → liberar o capturar el mouse
	# ---------------------------------------------------
	if event is InputEventKey and event.pressed and event.keycode == KEY_ALT:
		mouse_free = !mouse_free

		if mouse_free:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

		print("Mouse libre:", mouse_free)

	# ---------------------------------------------------
	# 🎥 Rotación de la cámara (solo cuando mouse atrapado)
	# ---------------------------------------------------
	if not mouse_free and event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clamp(rotation.x, -1.5, 1.5)


func _process(delta):
	var vel = fast_speed if Input.is_key_pressed(KEY_SHIFT) else speed
	var dir = Vector3.ZERO

	if Input.is_key_pressed(KEY_W): dir -= transform.basis.z
	if Input.is_key_pressed(KEY_S): dir += transform.basis.z
	if Input.is_key_pressed(KEY_A): dir -= transform.basis.x
	if Input.is_key_pressed(KEY_D): dir += transform.basis.x
	if Input.is_key_pressed(KEY_E): dir += transform.basis.y
	if Input.is_key_pressed(KEY_Q): dir -= transform.basis.y

	global_position += dir * vel * delta
