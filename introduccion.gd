extends Control

signal introduccion_terminada

const TEXTO_INTRO := "[center]" \
	+ "[font_size=130]¡BIENVENIDO![/font_size]\n\n" \
	+ "Gracias por elegir nuestro juego.\n\n" \
	+ "Ahora mismo eres un administrador de una página de la Universidad del Norte. " \
	+ "Te vas a encargar de decidir qué se puede publicar y qué no en la página de la universidad.\n\n" \
	+ "Para eso debes identificar las noticias falsas de las reales.\n\n" \
	+ "Pero antes de jugar, veamos cómo quieres lucir." \
	+ "[/center]"

# Segundos por cada letra (menor = más rápido)
const VELOCIDAD := 0.04
# El sonido suena cada cuántas letras
const SONIDO_CADA := 2

@onready var texto: RichTextLabel = $MarginContainer/VBoxContainer/Texto
@onready var boton: Button = $MarginContainer/VBoxContainer/BotonContinuar
@onready var sonido: AudioStreamPlayer = get_node_or_null("SonidoTecleo")

var total: int = 0
var progreso: float = 0.0
var escribiendo: bool = false

func _ready() -> void:
	boton.visible = false
	boton.pressed.connect(_on_continuar_pressed)

	texto.bbcode_enabled = true
	texto.text = TEXTO_INTRO
	texto.visible_characters = 0

	# Esperamos un frame para que el texto termine de procesarse
	await get_tree().process_frame
	total = texto.get_parsed_text().length()
	print("Total de letras: ", total)
	print("Texto: ", texto.get_parsed_text())
	escribiendo = true

func _process(delta: float) -> void:
	if not escribiendo:
		return

	progreso += delta / VELOCIDAD
	var nuevo: int = mini(int(progreso), total)

	if nuevo > texto.visible_characters:
		texto.visible_characters = nuevo
		if sonido != null and nuevo % SONIDO_CADA == 0:
			sonido.pitch_scale = randf_range(0.9, 1.1)
			sonido.play()

	if nuevo >= total:
		_terminar()

func _terminar() -> void:
	escribiendo = false
	texto.visible_characters = -1
	boton.visible = true

func _input(event: InputEvent) -> void:
	if not escribiendo:
		return
	var salto: bool = false
	if event is InputEventMouseButton and event.pressed:
		salto = true
	if event.is_action_pressed("ui_accept"):
		salto = true
	if salto:
		_terminar()

func _on_continuar_pressed() -> void:
	introduccion_terminada.emit()
	get_tree().change_scene_to_file("res://seleccion_personaje.tscn")
