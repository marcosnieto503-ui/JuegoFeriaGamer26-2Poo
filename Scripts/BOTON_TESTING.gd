extends Button


@onready var tabs = $"../../Laptop/Pestañas"
@onready var testEscena = preload("res://Escenas/VentanaPublicacion/ventana_publicacion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


@onready var CommentScene = preload("res://Escenas/ComentarioScene/comentario.tscn")
@onready var cajaComentarios = $"../../Laptop/Pestañas/PRINCIPAL/PanelContainer/ScrollContainer/CajaComentarios"

@onready var cComentarios = $"../../Utils/ControlComentarios"


func _on_check_hay_publis_excluidas_pressed() -> void:
	print("-------HAY PUBLICS PROCESADAS: ",cComentarios._hay_publis_para_escoger())


@export var IDpubliAMeter:int
func _on_mete_comentario_11_pressed() -> void:
	if !Utils.PUBLICACIONES.has(29):
		print("(BOTON METER COMENTARIO) La publi 11 no essta en el array pulicaciones")
		return
	var publi = Utils.PUBLICACIONES.get(29)
	Utils.excluirPublicacion(publi)
	
	var c = cComentarios.DEBUG_get_comment_from_publi(29)
	if !c:
		push_error("- NO HAY COMENTARIO PA PILLAR")
		return
	print("(BOTON METER COMENTARIO) metiendo comentario")
	cComentarios.ingresar_comentario(c,publi)

var soloPublisConComments = false
func _on_mete_com_random_pressed() -> void:
	if !soloPublisConComments:
		for p:Publicacion in Utils.PUBLICACIONES.values():
			if p.hayComentarios():
				DataPartida.PUBLIS_PARA_COMENTARIOS.append(p)
		soloPublisConComments = true
	
	if DataPartida.PUBLIS_PARA_COMENTARIOS.is_empty():
		push_error("No hay publis disponibles")
		return
	var p = DataPartida.PUBLIS_PARA_COMENTARIOS.pick_random()
	var c = p.getComentarioRandom()
	cComentarios.ingresar_comentario(c,p)
	print("(BOTON TESTIN) comentario random ingresado")



func _on_button_down() -> void:
	if !Utils.PUBLICACIONES.has(IDpubliAMeter):
		push_error("NO EXISTE PUBLICACION CON ID: 11 EN EL ARRAY PUBLICACIONES")
		return
	var p = Utils.PUBLICACIONES.get(IDpubliAMeter)
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
