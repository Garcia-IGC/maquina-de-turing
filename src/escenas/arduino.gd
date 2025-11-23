extends StaticBody3D

@onready var empujador_borrar = get_node("../Empujador")
@onready var empujador_blanco = get_node("../Empujador2")
@onready var empujador_rojo = get_node("../Empujador3")
@onready var cinta = get_node("../Cinta2")
@onready var lector = get_node("../Lector")

var estado_actual: int = 0
var posicion_cabezal: int = 0

@export var tiempo_mov_cinta: float = 3.0
@export var velocidad_cinta: float = 0.00275

var matriz_de_suma = [
	[ ["rojo", 1, "R"], ["rojo", 0, "R"], ["nada", 4, "nada"] ],
	[ ["blanco", 4, "nada"], ["rojo", 1, "R"], ["nada", 2, "L"] ],
	[ ["nada", 4, "nada"], ["nada", 3, "R"], ["nada", 4, "nada"] ]
]

var matriz_de_resta = [
	[ ["blanco",1,"R"], ["rojo",0,"R"], ["nada",7,"nada"] ],
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

var matriz_activa = null   # matriz seleccionada en inicio
var estados_halt: Array = []   # lista de estados de HALT según matriz seleccionada

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

		# 1) LEER PRIMER COLOR
		var primer_color: String = await lector_leer_color()
		print("Primer color detectado:", primer_color)

		# 2) ELEGIR MATRIZ SEGÚN COLOR
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

		# 3) SALTAR DOS CELDAS A LA DERECHA
		print("⏭ Saltando dos espacios antes de empezar...")
		await mover_cabezal("R")
		await mover_cabezal("R")

		# 4) EMPIEZA EL PROCESO NORMAL
		await ejecutar_maquina()

# --------------------------------------------------------------
# BUCLE PRINCIPAL
# --------------------------------------------------------------
func ejecutar_maquina():
	if matriz_activa == null:
		push_error("matriz_activa no definida. Abortando.")
		return

	while true:
		# condición dinámica de HALT
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
# Escritura
# --------------------------------------------------------------
func escribir_en_cinta(simbolo: String, color_actual: String):
	if simbolo == color_actual:
		return

	if simbolo == "nada":
		await mover_empujador(empujador_borrar)
		await get_tree().create_timer(0.3).timeout
		return

	# Borrar antes de escribir
	await mover_empujador(empujador_borrar)
	await get_tree().create_timer(0.3).timeout

	# Mover una celda a la izquierda para escribir
	await mover_cabezal("L")
	await get_tree().create_timer(0.3).timeout

	# Escribir (activar empujador correspondiente)
	match simbolo:
		"blanco":
			await mover_empujador(empujador_blanco)
		"rojo":
			await mover_empujador(empujador_rojo)

	await get_tree().create_timer(0.3).timeout

	# Volver: mover una celda a la derecha (dejamos al final del proceso que avance si debe)
	await mover_cabezal("R")

# --------------------------------------------------------------
# Empujador
# --------------------------------------------------------------
func mover_empujador(empujador: Node3D):
	# asume que empujador tiene método move_once() definido por ti
	if empujador == null:
		return

	empujador.move_once()
	await get_tree().create_timer(1.5).timeout
	empujador.move_once()
	await get_tree().create_timer(1.5).timeout

# --------------------------------------------------------------
# Movimiento de cinta / cabezal
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
	cinta.belt_speed = velocidad
	print("▶️ Moviendo cinta:", velocidad)
	await get_tree().create_timer(tiempo_mov_cinta).timeout
	cinta.belt_speed = 0
	print("⏹️ Cinta detenida")
	await get_tree().create_timer(1.5).timeout
