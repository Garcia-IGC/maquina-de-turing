extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProjectSettings.set_setting("physics/3d/solver/solver_iterations", 32)
	ProjectSettings.set_setting("physics/3d/solver/contact_max_separation", 0.01)
	ProjectSettings.set_setting("physics/3d/solver/contact_max_allowed_penetration", 0.001)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
