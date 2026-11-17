extends Control

signal personaje_elegido(datos: Dictionary)

const GENEROS := ["Hombre", "Mujer", "Otro"]
const PIELES := ["Blanco", "Negro"]
const ACCESORIOS := {
	"Hombre": ["Cabello corto", "Cabello largo", "Trenzas"],
	"Mujer": ["Cabello corto", "Cabello largo", "Trenzas"],
	"Otro": ["Moño", "Corbata", "Sombrero"],
}

# El personaje se pega al borde inferior de la pantalla
const PISO_Y := 1080.0
# Tamaño del personaje final (múltiplos de 88 para que el pixel art quede nítido)
const TAMANO_FINAL := 1056.0
# Cuánto se "hunde" bajo el borde inferior (más = se ve menos cuerpo)
const AJUSTE_PIES := 25.0

const RUTA_FONDO_FINAL := "res://imagenes/fondo_final.png"
const ARCHIVO_ACCESORIO := {
	"Cabello corto": "corto",
	"Cabello largo": "largo",
	"Trenzas": "trenzas",
	"Moño": "mono",
	"Corbata": "corbata",
	"Sombrero": "sombrero",
}

# Cuerpos: piel_<genero>_<color>.png
const CARPETA := "res://personajes/"
const ARCHIVO_GENERO := {"Hombre": "hombre", "Mujer": "mujer", "Otro": "otro"}
const ARCHIVO_PIEL := {"Gris": "gris", "Blanco": "blanco", "Negro": "negro"}

# Accesorios: uno distinto por cada género
const RUTA_ACCESORIO := {
	"Hombre": {
		"Cabello corto": "res://personajes/acc_hombre_corto.png",
		"Cabello largo": "res://personajes/acc_hombre_largo.png",
		"Trenzas": "res://personajes/acc_hombre_trenzas.png",
	},
	"Mujer": {
		"Cabello corto": "res://personajes/acc_mujer_corto.png",
		"Cabello largo": "res://personajes/acc_mujer_largo.png",
		"Trenzas": "res://personajes/acc_mujer_trenzas.png",
	},
	"Otro": {
		"Moño": "res://personajes/acc_otro_mono.png",
		"Corbata": "res://personajes/acc_otro_corbata.png",
		"Sombrero": "res://personajes/acc_otro_sombrero.png",
	},
}

const RUTA_FONDO_2 := "res://imagenes/fondo_2_tablones.png"

@onready var fondo: TextureRect = $Fondo
@onready var piel: TextureRect = $Piel
@onready var accesorio: TextureRect = $Accesorio
@onready var botones: Array = [$Opcion1, $Opcion2, $Opcion3]
@onready var nota: Label = $Nota
@onready var mensaje: Label = $Mensaje

var fondo_original: Texture2D
var paso: int = 0
var eleccion := {"genero": "", "piel": "", "accesorio": ""}
var terminado: bool = false

func _ready() -> void:
	fondo_original = fondo.texture
	piel.texture = null
	accesorio.texture = null
	for i in botones.size():
		botones[i].pressed.connect(_on_opcion.bind(i))
		botones[i].mouse_entered.connect(_on_hover.bind(i))
		botones[i].mouse_exited.connect(_on_hover_salir)
	_mostrar_paso()

func _opciones_actuales() -> Array:
	match paso:
		0:
			return GENEROS
		1:
			return PIELES
		_:
			return ACCESORIOS[eleccion["genero"]]

func _mostrar_paso() -> void:
	var opciones: Array = _opciones_actuales()
	for i in botones.size():
		if i < opciones.size():
			botones[i].text = opciones[i]
			botones[i].visible = true
		else:
			botones[i].visible = false

	if paso == 1 and ResourceLoader.exists(RUTA_FONDO_2):
		fondo.texture = load(RUTA_FONDO_2)
	else:
		fondo.texture = fondo_original
	
func _ruta_cuerpo(genero: String, color: String) -> String:
	return CARPETA + "piel_" + ARCHIVO_GENERO[genero] + "_" + ARCHIVO_PIEL[color] + ".png"

func _on_hover(indice: int) -> void:
	if terminado:
		return
	match paso:
		0:
			piel.texture = _cargar(_ruta_cuerpo(GENEROS[indice], "Gris"))
		1:
			piel.texture = _cargar(_ruta_cuerpo(eleccion["genero"], PIELES[indice]))
		2:
			var nombre: String = _opciones_actuales()[indice]
			accesorio.texture = _cargar(RUTA_ACCESORIO[eleccion["genero"]][nombre])

func _on_hover_salir() -> void:
	if terminado:
		return
	match paso:
		0:
			piel.texture = null
		1:
			piel.texture = _cargar(_ruta_cuerpo(eleccion["genero"], "Gris"))
		2:
			accesorio.texture = null

func _on_opcion(indice: int) -> void:
	var nombre: String = _opciones_actuales()[indice]

	match paso:
		0:
			eleccion["genero"] = nombre
			piel.texture = _cargar(_ruta_cuerpo(nombre, "Gris"))
		1:
			eleccion["piel"] = nombre
			piel.texture = _cargar(_ruta_cuerpo(eleccion["genero"], nombre))
		2:
			eleccion["accesorio"] = nombre
			accesorio.texture = _cargar(RUTA_ACCESORIO[eleccion["genero"]][nombre])
			await _terminar()
			return

	paso += 1
	_mostrar_paso()

func _terminar() -> void:
	PersistenciaPersonaje.personaje = eleccion.duplicate()
	terminado = true
	for b in botones:
		b.disabled = true
	nota.visible = false
	await get_tree().create_timer(1.0).timeout
	_mostrar_final()
	await get_tree().create_timer(3.0).timeout
	print("Personaje elegido: ", eleccion)
	personaje_elegido.emit(eleccion)
	
	
func _mostrar_final() -> void:
	for b in botones:
		b.visible = false

	if ResourceLoader.exists(RUTA_FONDO_FINAL):
		fondo.texture = load(RUTA_FONDO_FINAL)

	var pantalla: Vector2 = size  # tamaño de la escena (1920 x 1080)

	# Personaje feliz centrado
	var ruta: String = CARPETA + "feliz_" \
		+ ARCHIVO_GENERO[eleccion["genero"]] + "_" \
		+ ARCHIVO_PIEL[eleccion["piel"]] + "_" \
		+ ARCHIVO_ACCESORIO[eleccion["accesorio"]] + ".png"
	piel.texture = _cargar(ruta)
	accesorio.texture = null
	piel.size = Vector2(TAMANO_FINAL, TAMANO_FINAL)
	piel.position = Vector2(
		(pantalla.x - piel.size.x) / 2.0,
		PISO_Y - piel.size.y + AJUSTE_PIES
	)

	# Mensaje centrado, arriba del personaje
	mensaje.text = "¡Gran elección!"
	mensaje.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mensaje.size = Vector2(pantalla.x, 150)
	mensaje.position = Vector2(0, 50)
	mensaje.visible = true
	mensaje.pivot_offset = mensaje.size / 2.0
	mensaje.scale = Vector2.ZERO
	var tween := create_tween()
	tween.tween_property(mensaje, "scale", Vector2.ONE, 0.5) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
func _cargar(ruta: String) -> Texture2D:
	if ResourceLoader.exists(ruta):
		return load(ruta)
	push_warning("No encuentro la imagen: " + ruta)
	return null
