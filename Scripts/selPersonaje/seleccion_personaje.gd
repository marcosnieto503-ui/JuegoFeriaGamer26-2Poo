extends Control

@export_file("*.tscn") var siguiente_escena: String = ""

const CARPETA := "res://Assets/selPersonaje/Personajes/"
const CLAVES_PASOS := ["genero", "piel", "accesorio"]
const LISTA_GENEROS := ["Hombre", "Mujer", "Otro"]
const LISTA_PIELES := ["Blanco", "Negro"]
const LISTA_ACCESORIOS := {
	"Hombre": ["Cabello corto", "Cabello largo", "Trenzas"],
	"Mujer": ["Cabello corto", "Cabello largo", "Trenzas"],
	"Otro": ["Moño", "Corbata", "Sombrero"],
}

@onready var piel: TextureRect = $Personaje/Piel
@onready var accesorio: TextureRect = $Personaje/Accesorio
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var botones: Array[Node] = $ContenedoresOpciones.get_children()

var paso: int = 0
var eleccion := {"genero": "", "piel": "", "accesorio": ""}
var terminado: bool = false

func _ready() -> void:
	for i in botones.size():
		botones[i].pressed.connect(_on_opcion_click.bind(i))
		botones[i].mouse_entered.connect(_on_opcion_hover.bind(i))
		botones[i].mouse_exited.connect(_on_opcion_hover_salir)
	
	_actualizar_botones()

func _opciones_actuales() -> Array:
	match paso:
		0: return LISTA_GENEROS
		1: return LISTA_PIELES
		2: return LISTA_ACCESORIOS[eleccion["genero"]]
	return []

func _actualizar_botones() -> void:
	var opciones := _opciones_actuales()
	for i in botones.size():
		if i < opciones.size():
			botones[i].text = opciones[i]
			botones[i].show()
		else:
			botones[i].hide()

func _cargar(ruta: String) -> Texture2D:
	return load(ruta) if ResourceLoader.exists(ruta) else null

func _on_opcion_hover(indice: int) -> void:
	if terminado or indice >= _opciones_actuales().size(): return
	var opc: String = _opciones_actuales()[indice]
	
	match paso:
		0:
			piel.texture = _cargar(CARPETA + "piel_%s_gris.png" % PersistenciaPersonaje.GENEROS[opc])
		1:
			piel.texture = _cargar(CARPETA + "piel_%s_%s.png" % [PersistenciaPersonaje.GENEROS[eleccion["genero"]], PersistenciaPersonaje.PIELES[opc]])
		2:
			accesorio.texture = _cargar(CARPETA + "acc_%s_%s.png" % [PersistenciaPersonaje.GENEROS[eleccion["genero"]], PersistenciaPersonaje.ACCESORIOS[opc]])

func _on_opcion_hover_salir() -> void:
	if terminado: return
	match paso:
		0:
			piel.texture = null
		1:
			piel.texture = _cargar(CARPETA + "piel_%s_gris.png" % PersistenciaPersonaje.GENEROS[eleccion["genero"]])
		2:
			accesorio.texture = null

func _on_opcion_click(indice: int) -> void:
	if terminado: return
	eleccion[CLAVES_PASOS[paso]] = _opciones_actuales()[indice]
	paso += 1
	if paso < 3:
		_actualizar_botones()
	else:
		_finalizar()

func _finalizar() -> void:
	terminado = true
	PersistenciaPersonaje.guardar(eleccion["genero"], eleccion["piel"], eleccion["accesorio"])
	piel.texture = PersistenciaPersonaje.obtener_reaccion("feliz")
	anim.play("final")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"final":
		if not siguiente_escena.is_empty():
			Transicion.cambiarEscena(siguiente_escena)
		else:
			print("Personaje guardado con éxito: ", eleccion)
