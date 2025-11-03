extends RigidBody3D
@export var color_tag: String
@onready var mesh = $MeshInstance3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mat = StandardMaterial3D.new()
	if color_tag == "rojo":
		mat.albedo_color = Color(1, 0, 0) # rojo
		mesh.set_surface_override_material(0, mat)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func get_color_data():
	return color_tag
