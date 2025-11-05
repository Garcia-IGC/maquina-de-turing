extends StaticBody3D

@onready var empujador =  get_node("../../Empujador")
# Called when the node enters the scene tree for the first time.
func _input_event(camera, event, position, normal, shape_idx):
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			empujador.move_once()
