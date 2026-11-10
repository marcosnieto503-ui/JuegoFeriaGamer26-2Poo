extends Node

var rutaComentarios = "res://Recursos/DATA_COMENTARIOS.txt"
var escenaComentario = preload("res://Escenas/ComentarioScene/comentario.tscn")
@onready var cajaComentarios = $"../../Laptop/Pestañas/PRINCIPAL/PanelContainer/ScrollContainer/CajaComentarios"

func _ready() -> void:
	await get_tree().process_frame
	leerArchivoComentarios()

func _hay_publis_para_escoger() -> bool:
	if DataPartida.PUBLIS_PARA_COMENTARIOS.is_empty():
		return false
	return true

func _ingresar_comentario_random() -> void:
	if !_hay_publis_para_escoger():
		return
	var publi = DataPartida.PUBLIS_PARA_COMENTARIOS.pick_random()
	print("(control_comentarios)------PUBLI RANDOM ELEGIDA: ",publi, " ID: ",publi.get_id())
	if !publi.hayComentarios():
		print("(Logica_jugable_comentarios) LA PUBLI CON ID:",publi.get_id()," NO TIENE COMENTARIOS")
		return
	var comment = publi.getComentarioRandom()
	ingresar_comentario(comment)
	#sssssssss
	publi._comentarios.erase(comment)
	if !publi.hayComentarios():
		DataPartida.PUBLIS_PARA_COMENTARIOS.erase(publi)


#sim importar si fue descartada o publicada
func DEBUG_get_comment_from_publi(id:int) -> Comentario:
	var publi:Publicacion
	if Utils.PUBLIS_EXCLUIDAS.has(id):
		publi = Utils.PUBLIS_EXCLUIDAS[id]
	else:
		print("No existe la publbli : ",id," En publis excluidas")
		return
	var com = publi.getComentarioRandom()
	if !com:
		print("No hay comentarios en la public: ",id)
		return
	else:
		return com


func ingresar_comentario(c:Comentario):
	var com = escenaComentario.instantiate()
	if !com.asignarComentario(c):
		return
	cajaComentarios.add_child(com)
	print("(control_comentarios) COMENTARIO AGREGADO A LA ESCENA CORRECTAMENTE")

#LECTURA DE ARCHIVO
func leerArchivoComentarios():
	var ruta = rutaComentarios
	if not FileAccess.file_exists(ruta):
		push_error("Archivo no encontrado: " + ruta)
		return
	
	var archivo = FileAccess.open(ruta, FileAccess.READ)
	if archivo == null:
		push_error("Error al abrir: " + str(FileAccess.get_open_error()))
		return
	var texto = "NULL"
	var id = null
	var r1 = "NULL"
	var r2 = "NULL"
	var r3 = "NULL"
	
	var estadoLectura = "noLeyendo"
	
	while not archivo.eof_reached():
		var linea = archivo.get_line()
		
		linea = linea.strip_edges()
		if linea.begins_with("//"):
			continue
		
		if linea.begins_with("#i"):
			estadoLectura = "texto"
			continue
		elif linea.begins_with("#f"):
			if id == null:
				push_error("Id null en el articulo : ",texto)
			
			var comentario = Comentario.new(texto,id,r1,r2,r3)
			
			texto = "NULL" 
			id = null
			r1 = "NULL"
			r2 = "NULL"
			r3 = "NULL"
			
			estadoLectura = "noLeyendo"
			
			if !Utils.PUBLICACIONES.keys().has(comentario._id):
				push_error("NO EXISTE PUBLICACION CON ESTE ID PARA SIGNARLE COMENTARIO: ",id)
				continue
			Utils.PUBLICACIONES.get(comentario._id).addComentario(comentario)
			print("-------COMENTARIO LEIDO: ",comentario,"\n")
		
		if estadoLectura == "noLeyendo":
			continue
		match estadoLectura:
			"texto":
				if linea.begins_with("-texto:"):
					texto = linea.trim_prefix("-texto:")
					estadoLectura = "id"
			"id":
				if linea.begins_with("-id:"):
					id = linea.trim_prefix("-id:").to_int()
					estadoLectura = "r1"
			"r1":
				if linea.begins_with("-r1:"):
					r1 = linea.trim_prefix("-r1:")
					estadoLectura = "r2"
			"r2":
				if linea.begins_with("-r2:"):
					r2 = linea.trim_prefix("-r2:")
					estadoLectura = "r3"
			"r3":
				if linea.begins_with("-r3:"):
					r3 = linea.trim_prefix("-r3:")
