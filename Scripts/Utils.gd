extends Node

var publis = []
#ee funciones utiles accesibnles desde todo el proyecto
const rutaPublis = "res://Recursos/publicaciones.txt"

func leer_archivo_publi(ruta:String):
	if not FileAccess.file_exists(ruta):
		push_error("Archivo no encontrado: " + ruta)
		return
		
	var archivo = FileAccess.open(ruta, FileAccess.READ)
	if archivo == null:
		push_error("Error al abrir: " + str(FileAccess.get_open_error()))
		return
		
	var num_linea := 0
	var textoNoti
	var dataPublic: PackedStringArray = []
	var leyendoPubli = false
	var procesando = false
	
	while not archivo.eof_reached():
		var linea = archivo.get_line()
		
		if (linea.begins_with("#") and leyendoPubli == false):
			textoNoti = linea.lstrip("#").rstrip("#")

		if (linea.begins_with("*") and procesando == false):
			procesando = true
			continue
		if (procesando):
			if (linea.begins_with("*")):
				publis.append(dataPublicacion.new(textoNoti,"\n".join(dataPublic)))
				break
			dataPublic.append(linea)
	
	
