extends Button


@onready var tabs = $"../Laptop/Pestañas"
@onready var testEscena = preload("res://Escenas/ventana_publicacion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


@onready var CommentScene = preload("res://Escenas/comentario.tscn")
@onready var cajaComentarios = $"../Laptop/Pestañas/PRINCIPAL/PanelContainer/COMENTARIOS"

@onready var cComentarios = $"../Utils/ControlComentarios"


func _on_button_check_pressed() -> void:
	print("-------HAY PUBLICS PROCESADAS: ",cComentarios._hay_publis_procesadas())
	print(" ------ COM RANDOM: ", cComentarios._get_comentario_random())


func _on_button_down() -> void:
	var p = Utils.PUBLICACIONES.get(1)
	Utils.ingresarPublicacion(p)
	print(p.get_textoNoti())
	
	
	if !cComentarios._hay_publis_procesadas():
		return
	print("HAY COMENTARIOS")
	var scene = CommentScene.instantiate()
	var com = cComentarios._get_comentario_random()
	print("COMENTARION A ASIGNAR: ",com)
	if !scene.asignarComentario(com):
		scene.queue_free()
		return
	cajaComentarios.add_child(scene)
	print("COMENTARIO PEGAO")
	
	return
	if Utils.PUBLICACIONES.has(11):
		Utils.ingresarPublicacion(Utils.PUBLICACIONES.get(11))
	
	return
	print("cantidfad articulos: ",len(Utils.ARTICULOS))
	var ar = Utils.ARTICULOS.get(0)
	print(ar.get_nombre())
	print(ar.get_tipo())
	print(ar.get_id())
	print(ar.get_categoria())
	print("TITULAR: ",ar.get_titular())
	print("")
	print("TEXTO: ",ar.get_texto())
	print(ar._img)
