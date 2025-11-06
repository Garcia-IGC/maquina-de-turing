extends StaticBody3D

@onready var area = $Area3D
@onready var mesh = $Lector

var color_actual: String = "nada" # Valor por defecto

func _ready() -> void:
	# Configura el color visual del lector
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.752, 0.457, 0.0, 1.0) # Naranja para distinguirlo
	mesh.set_surface_override_material(0, mat)

	# Conectamos la señal del área si no está conectada en el editor
	if not area.is_connected("body_entered", Callable(self, "_on_body_entered")):
		area.connect("body_entered", Callable(self, "_on_body_entered"))
	if not area.is_connected("body_exited", Callable(self, "_on_body_exited")):
		area.connect("body_exited", Callable(self, "_on_body_exited"))

# ---------------------------------------------------------
# Señales del área
# ---------------------------------------------------------
func _on_body_entered(body):
	if body and body.has_method("get_color_data"):
		var color = body.get_color_data()
		color_actual = color
		print("🎨 Cuerpo detectado con color:", color)

func _on_body_exited(body):
	# Cuando el cuerpo sale, el lector queda sin color
	if body and body.has_method("get_color_data"):
		print("🚪 Cuerpo salió del lector.")
		color_actual = "nada"

# ---------------------------------------------------------
# Devuelve el color detectado por el lector
# ---------------------------------------------------------
func get_color_tag() -> String:
	return color_actual
