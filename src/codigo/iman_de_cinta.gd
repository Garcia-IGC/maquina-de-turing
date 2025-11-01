extends Node3D

@export var magnet_strength: float = 15.0
@onready var area: Area3D = $Area3D

func _physics_process(delta):
	for body in area.get_overlapping_bodies():
		if body.has_method("apply_magnetic_force"):
			print("Magnet detected:", body.name)
			body.apply_magnetic_force(global_transform.origin, magnet_strength)
	
