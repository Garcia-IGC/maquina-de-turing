extends Node3D

@export var belt_speed: float = 0.04
@export var direction: Vector3 = Vector3(0, 0, -1)
@onready var magnets = $Imanes.get_children()
@onready var area: Area3D = $Area3D

func _physics_process(delta):
	for body in area.get_overlapping_bodies():
		if body is RigidBody3D:
			body.sleeping = false
			body.apply_central_force(direction.normalized() * belt_speed * 1)

	for magnet in magnets:
		magnet.translate(direction.normalized() * belt_speed * 1)
