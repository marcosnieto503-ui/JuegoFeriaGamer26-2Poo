extends Control


@onready var avatar: TextureRect = $MarginContainer/VBoxContainer/Fila/Avatar
@onready var nombre: Label = $MarginContainer/VBoxContainer/Fila/Textos/Nombre
@onready var rol: Label = $MarginContainer/VBoxContainer/Fila/Textos/Rol

var integrantes := [
	{"nombre": "Marcos Escorcia", "rol": "Programador", "foto": "res://MENUS/Assets/Creditos/Avatares/marcos.jpg"},
	{"nombre": "Kevin Pacheco", "rol": "Artista", "foto": "res://MENUS/Assets/Creditos/Avatares/kevin.jpeg"},
	{"nombre": "Karol Bono", "rol": "Música", "foto": "res://MENUS/Assets/Creditos/Avatares/karol.jpg"},
	{"nombre": "Sebastian Perez", "rol": "Música", "foto": "res://Assets/Creditos/Avatares/karol.jpg"},
	{"nombre": "Martin Vergara", "rol": "Música", "foto": "res://Assets/Creditos/Avatares/karol.jpg"},
]

var indice := 0

func _ready() -> void:
	mostrar_integrante()

func mostrar_integrante() -> void:
	var datos = integrantes[indice]
	nombre.text = datos["nombre"]
	rol.text = datos["rol"]
	avatar.texture = load(datos["foto"])

func _on_alante_pressed() -> void:
	indice = posmod(indice + 1, integrantes.size())
	mostrar_integrante()

func _on_atras_pressed() -> void:
	indice = posmod(indice - 1, integrantes.size())
	mostrar_integrante()

func _on_salir_pressed() -> void:
	#Transicion.cambiarEscena(escena_anterior)
	GameManager.CAMBIAR_DE_ESCENA(GameManager.ENUMESCENAS.MAINMENU)
