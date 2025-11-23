extends StaticBody3D

func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Click en el objeto 3D!")
		get_node("../../Cinta2").belt_speed = 0.01
