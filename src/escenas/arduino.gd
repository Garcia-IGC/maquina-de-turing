extends StaticBody3D

@onready var empujador_borrar = get_node("../Empujador")
@onready var empujador_rojo = get_node("../Empujador3")
@onready var cinta = get_node("../Cinta2")
@onready var lector = get_node("../Lector")

var estado_actual: int = 0
var posicion_cabezal: int = 0

@export var tiempo_mov_cinta: float = 8.70
@export var velocidad_cinta: float = 0.05

var matriz_de_suma = [
	[ ["rojo", 1, "R"], ["rojo", 0, "R"], ["nada", 0, "R"] ],
	[ ["blanco", 4, "nada"], ["rojo", 1, "R"], ["nada", 2, "L"] ],
	[ ["nada", 4, "nada"], ["nada", 3, "R"], ["nada", 4, "nada"] ]
]

var matriz_de_resta = [
	[ ["blanco",1,"R"], ["rojo",0,"R"], ["nada",0,"R"] ],
	[ ["blanco",7,"nada"], ["rojo",1,"R"], ["nada",2,"L"] ],
	[ ["nada",6,"R"], ["nada",3,"L"], ["nada",7,"nada"] ],
	[ ["blanco",4,"L"], ["rojo",3,"L"], ["nada",7,"nada"] ],
	[ ["blanco",7,"nada"], ["rojo",4,"L"], ["nada",5,"R"] ],
	[ ["blanco",7,"nada"], ["nada",0,"R"], ["nada",7,"nada"] ]
]

var colores = {
	"blanco": 0,
	"rojo": 1,
	"nada": 2
}

var matriz_activa = null
var estados_halt: Array = []

# --------------------------------------------------------------
# INICIO CON CLICK
# --------------------------------------------------------------
func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("🧠 Iniciando máquina de Turing…")

		estado_actual = 0
		posicion_cabezal = 0
		matriz_activa = null
		estados_halt.clear()

		var primer_color: String = await lector_leer_color()
		print("Primer color detectado:", primer_color)

		if primer_color == "rojo":
			matriz_activa = matriz_de_suma
			estados_halt = [3, 4]
			print("➡ Usando MATRIZ DE SUMA (halt: 3,4)")
		elif primer_color == "blanco":
			matriz_activa = matriz_de_resta
			estados_halt = [6, 7]
			print("➡ Usando MATRIZ DE RESTA (halt: 6,7)")
		else:
			print("❌ Primer color inválido o 'nada' → HALT")
			return

		await mover_cabezal("R")
		await mover_cabezal("R")

		await ejecutar_maquina()

# --------------------------------------------------------------
func ejecutar_maquina():
	if matriz_activa == null:
		push_error("matriz_activa no definida. Abortando.")
		return

	while true:
		if estado_actual in estados_halt:
			break

		var color_actual: String = await lector_leer_color()
		var indice_color: int = colores.get(color_actual, 2)
		var accion = matriz_activa[estado_actual][indice_color]

		var escribir: String = accion[0]
		var nuevo_estado: int = accion[1]
		var movimiento: String = accion[2]

		print("📖 Estado:", estado_actual,
			" Leyó:", color_actual,
			" → Escribe:", escribir,
			" → Estado:", nuevo_estado,
			" Mov:", movimiento)

		await escribir_en_cinta(escribir, color_actual)
		estado_actual = nuevo_estado
		await mover_cabezal(movimiento)

	print("✅ HALT alcanzado (estado %d)" % estado_actual)

# --------------------------------------------------------------
# Lector
# --------------------------------------------------------------
func lector_leer_color() -> String:
	if lector == null:
		return "nada"

	if lector.has_method("get_color_tag"):
		var color = lector.get_color_tag()
		if color == "" or color == null:
			return "nada"
		return color

	return "nada"

# --------------------------------------------------------------
# Escritura (CORREGIDA)
# --------------------------------------------------------------
func escribir_en_cinta(simbolo: String, color_actual: String):
	if simbolo == color_actual:
		return

	if simbolo == "nada":
		await mover_empujador(empujador_borrar)
		await get_tree().create_timer(0.3).timeout
		return

	# Si simbolo == "blanco", NO hacemos nada porque ya estaba blanco.

	if simbolo == "rojo":
		# borrar antes de escribir rojo
		await mover_empujador(empujador_borrar)
		await get_tree().create_timer(0.3).timeout

		# mover a la izquierda para escribir
		await mover_cabezal("L")

		await mover_empujador(empujador_rojo)
		await get_tree().create_timer(0.3).timeout

		# volver al centro
		await mover_cabezal("R")

# --------------------------------------------------------------
# Empujador
# --------------------------------------------------------------
func mover_empujador(empujador: Node3D):
	if empujador == null:
		return

	empujador.move_once()
	await get_tree().create_timer(1.5).timeout

# --------------------------------------------------------------
func mover_cabezal(direccion: String):
	match direccion:
		"R":
			await mover_cinta_temporal(1)
		"L":
			await mover_cinta_temporal(-1)

func mover_cinta_temporal(sentido: int):
	var velocidad = velocidad_cinta * sentido
	cinta.belt_speed = velocidad
	await get_tree().create_timer(tiempo_mov_cinta).timeout
	cinta.belt_speed = 0
	await get_tree().create_timer(1.5).timeout
