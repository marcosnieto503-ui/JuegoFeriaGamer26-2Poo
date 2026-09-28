extends Node

var PUBLICACIONES = []

const RUTAS_RECURSOS = {
	1 :"ruta1",
	2 :"ruta2",
	3 :"ruta3",
	4 :"ruta4"
}
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
	
	var tnA = "NULL"
	var idA = "NULL"
	var tipo = "NULL"
	var tpArray = []
	
	var estadoLectura = ""
	
	while not archivo.eof_reached():
		var linea = archivo.get_line()
		
		linea = linea.strip_edges()
		if linea.begins_with("//") or linea.begins_with(""):
			continue
			
		if linea.begins_with("#i"):
			estadoLectura = "textoNoti"
			continue
		elif linea.begins_with("#f"):
			if len(tpArray) == 0:
				tpArray.append("NULL")
				#contnad
				#nand
				#,,,,
		
		match estadoLectura:
			"textoNoti":
				if linea.begins_with("-tn:"):
					tnA = linea.trim_prefix("-tn:")
					estadoLectura = "id"
			"id":
				if linea.begins_with("-id:"):
					idA = linea.trim_prefix("-id:").to_int()
					estadoLectura = "tipo"
			"tipo":
				if linea.begins_with("-tipo:"):
					tipo = linea.trim_prefix("-tipo:")
					estadoLectura = "textoPubli"
			"textoPubli":
				tpArray.append(linea)
					
				
				
				
		
	
	
