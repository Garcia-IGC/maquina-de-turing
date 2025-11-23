extends StaticBody3D

@export var marker: Node3D
@export var red_piece_scene: PackedScene
func _input_event(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		print("▶ Click detectado, colocando pieza roja…")
		poner_pieza_roja()


func poner_pieza_roja() -> void:
	if marker == null or red_piece_scene == null:
		push_error("Asigna marker y red_piece_scene en el inspector")
		return

	var pieza = red_piece_scene.instantiate()
	pieza.global_transform = marker.global_transform
	get_tree().current_scene.add_child(pieza)
