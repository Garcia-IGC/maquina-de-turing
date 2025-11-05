extends Area3D

func _on_body_entered(body):
	print("cuelpo detestado")
	if body.has_method("get_color_data"):
		var color = body.get_color_data()
		print("Color detectado:", color)
