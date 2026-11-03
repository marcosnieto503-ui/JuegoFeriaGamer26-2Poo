extends Node

var rutaComentarios = "res://Recursos/DATA_COMENTARIOS.txt"

func _ready() -> void:
	await get_tree().process_frame
	leerArchivoComentarios()

func _hay_publis_procesadas() -> bool:
	if Utils.PUBLIS_EXCLUIDAS.is_empty():
		return false
	return true

func _get_comentario_random() -> Comentario:
	if !_hay_publis_procesadas():
		return null
	var publi = Utils.PUBLIS_EXCLUIDAS.get(Utils.PUBLIS_EXCLUIDAS.keys().pick_random())
	print("------PUBLI RANDOM ELEGIDA: ",publi)
	var comment = publi.getComentarioRandom()
	if !comment:
		return null
	return comment




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
			print("-------COMENTARIO LEIDO: ",comentario)
		
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
