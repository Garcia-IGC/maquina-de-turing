extends Node3D

@export var distance_meters: float = 5.0
@export var speed: float = 5
@export var direction: Vector3 = Vector3(1, 0, 0)

var moving := false
var returning := false
var start_position: Vector3

func _ready():
	start_position = global_transform.origin

func move_once():
	if not moving and not returning:
		moving = true

func _physics_process(delta):
	if moving:
		# Avanza
		var move_step = direction.normalized() * speed * delta
		global_translate(move_step)

		if (global_transform.origin - start_position).length() >= distance_meters:
			moving = false
			returning = true

	elif returning:
		# Regresa
		var move_step = -direction.normalized() * speed * delta
		global_translate(move_step)

		if (global_transform.origin - start_position).length() <= 0.01:
			returning = false
			global_transform.origin = start_position
			print("Movimiento completo (ida y vuelta)")
