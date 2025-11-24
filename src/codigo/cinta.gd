extends Node3D

@export var belt_speed: float = 0
@onready var path: Path3D = $Node3D2/Path3D
@onready var follows: Array = []

func _ready():
	# Filtrar solo los PathFollow3D
	follows = []
	for child in path.get_children():
		if child is PathFollow3D:
			follows.append(child)

	# Asignar offsets únicos para que no se peguen
	var count := follows.size()
	for i in range(count):
		follows[i].progress_ratio = float(i) / float(count)  # 0.0 a 1.0
func _physics_process(delta):
	for pf in follows:
		pf.progress_ratio = fmod(pf.progress_ratio + belt_speed * delta * 0.1, 1.0)
