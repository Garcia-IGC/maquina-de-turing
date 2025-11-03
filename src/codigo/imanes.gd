extends StaticBody3D

@export var belt_speed: float = 0.04
@export var direction: Vector3 = Vector3(1, 0, 0)
@onready var magnets = $Magnets.get_children()

func _process(delta):
	for magnet in magnets:
		magnet.translate(direction.normalized() * belt_speed * delta)
