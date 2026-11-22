extends Node

@export var manejoTxtPublisArticulos:Node
@onready var controlComentarios = $"../Utils/ControlComentarios"

func _ready() -> void:
	print(manejoTxtPublisArticulos)
	print(controlComentarios)


func leer_recursos_txt():
	await get_tree().process_frame
	await manejoTxtPublisArticulos.leer_archivo_publi()
	await manejoTxtPublisArticulos.leer_archivo_articulos()
	await controlComentarios.leerArchivoComentarios()
	print("(RECURSOS_TXT_MANAGER) REcursos de texto leidos correctamente")
