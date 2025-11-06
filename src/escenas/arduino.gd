extends StaticBody3D

@onready var empujador_borrar = get_node("../Empujador")
@onready var empujador_blanco = get_node("../Empujador2")
@onready var empujador_rojo = get_node("../Empujador3")
@onready var cinta = get_node("../Cinta2")
@onready var lector = get_node("../Lector")

var estado_actual: int = 0
var posicion_cabezal: int = 0

@export var tiempo_mov_cinta: float = 3.0
@export var velocidad_cinta: float = 0.0167

var matriz_de_suma = [
  [ ["rojo", 1, "R"], ["rojo", 0, "R"], ["nada", 4, "nada"] ],
  [ ["blanco", 4, "nada"], ["rojo", 1, "R"], ["nada", 2, "L"] ],
  [ ["nada", 4, "nada"], ["nada", 3, "R"], ["nada", 4, "nada"] ]
 ]

var colores = {
	"blanco": 0,
	"rojo": 1,
	"nada": 2
}

# --------------------------------------------------------------
# Inicio con clic
# --------------------------------------------------------------
func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("🧠 Iniciando máquina de Turing…")
		await ejecutar_maquina()

# --------------------------------------------------------------
# Bucle principal
# --------------------------------------------------------------
func ejecutar_maquina():
	while true:
		if estado_actual in [3, 4]:
			break

		var color_actual = await lector_leer_color()
		var indice_color = colores.get(color_actual, 2)
		var accion = matriz_de_suma[estado_actual][indice_color]

		var escribir = accion[0]
		var nuevo_estado = accion[1]
		var movimiento = accion[2]

		print("📖 Estado:", estado_actual, "Leyó:", color_actual, "→ Escribe:", escribir, "→ Estado:", nuevo_estado, "Mov:", movimiento)

		await escribir_en_cinta(escribir, color_actual)
		estado_actual = nuevo_estado
		await mover_cabezal(movimiento)

	print("✅ HALT alcanzado (estado %d)" % estado_actual)


# --------------------------------------------------------------
# Lectura del color real desde el lector
# --------------------------------------------------------------
func lector_leer_color() -> String:
	if lector.has_method("get_color_tag"):
		var color = lector.get_color_tag()
		if color == "" or color == null:
			return "nada"
		return color
	else:
		return "nada"

# --------------------------------------------------------------
# Escritura en la cinta según símbolo
# --------------------------------------------------------------
func escribir_en_cinta(simbolo: String, color_actual: String):
	if simbolo == color_actual:
		print("✏️ No se necesita escribir, el color ya es", simbolo)
		return

	if simbolo == "nada":
		await mover_empujador(empujador_borrar)
		await get_tree().create_timer(0.3).timeout
		return

	print("🧹 Borrando antes de escribir", simbolo)
	await mover_empujador(empujador_borrar)
	await get_tree().create_timer(0.3).timeout

	print("⬅️ Moviendo una celda a la izquierda")
	await mover_cabezal("L")
	await get_tree().create_timer(0.3).timeout

	print("✏️ Escribiendo color:", simbolo)
	match simbolo:
		"blanco":
			await mover_empujador(empujador_blanco)
		"rojo":
			await mover_empujador(empujador_rojo)
	await get_tree().create_timer(0.3).timeout

	print("➡️➡️ Moviendo dos celdas a la derecha")
	await mover_cabezal("R")
	await get_tree().create_timer(0.3).timeout
	

# --------------------------------------------------------------
# Movimiento físico del empujador (usa tu método interno)
# --------------------------------------------------------------
func mover_empujador(empujador: Node3D):
	empujador.move_once()
	await get_tree().create_timer(1.5).timeout
	empujador.move_once()
	await get_tree().create_timer(1.5).timeout

# --------------------------------------------------------------
# Movimiento del cabezal (cinta)
# --------------------------------------------------------------
func mover_cabezal(direccion: String):
	match direccion:
		"R":
			await mover_cinta_temporal(1)
		"L":
			await mover_cinta_temporal(-1)
		_:
			return

func mover_cinta_temporal(sentido: int):
	var velocidad = velocidad_cinta * sentido
	cinta.set("belt_speed", velocidad)

	print("▶️ Moviendo cinta:", velocidad)
	await get_tree().create_timer(tiempo_mov_cinta).timeout

	cinta.belt_speed = 0
	print("⏹️ Cinta detenida")
	await get_tree().create_timer(1.5).timeout
