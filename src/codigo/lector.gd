extends StaticBody3D

@onready var mesh = $Lector
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.752, 0.457, 0.0, 1.0) # rojo
	mesh.set_surface_override_material(0, mat)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
