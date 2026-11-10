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

func _on_button_2_pressed() -> void:
	#mete comentario
	var c = cComentarios.DEBUG_get_comment_from_publi(11)
	if !c:
		push_error("- NO HAY COMENTARIO PA PILLAR")
		return
	var com = CommentScene.instantiate()
	print("SE ASIGNA O NO: ",com.asignarComentario(c))
	cajaComentarios.add_child(com)
	print("-- -- 2 COMENTARIO PEGAO CORRECTAMENTE")

func _on_button_down() -> void:
	if !Utils.PUBLICACIONES.has(11):
		push_error("NO EXISTE PUBLICACION CON ID: 11 EN EL ARRAY PUBLICACIONES")
		return
	var p = Utils.PUBLICACIONES.get(11)
	Utils.ingresarPublicacion(p)
	Utils.excluirPublicacion(p)
	
	return
	
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
