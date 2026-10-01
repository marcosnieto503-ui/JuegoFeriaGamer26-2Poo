extends Node

var NOTIFICACION_ACTIVA = false
@onready var cajaNotis = $/root/Gameplay/Celular/ScrollNotificaciones/CajaNotificaciones
@onready var tabPublicacion = $/root/Gameplay/Laptop/Pestañas/Publicacion

func desactivar_press_notis():
	for hijo in cajaNotis.get_children():
		hijo.desactivarBoton()
func activar_press_notis():
	for hijo in cajaNotis.get_children():
		hijo.activarBoton()

var PUBLICACIONES :Array[Publicacion] = []

const RUTAS_RECURSOS = {
	1 :"ruta1",
	2 :"ruta2",
	3 :"ruta3",
	4 :"ruta4"
}
#ee funciones utiles accesibnles desde todo el proyecto
const rutaPublis = "res://Recursos/DATA_PUBLICACIONES.txt"

func ingresarPublicacion(publi : Publicacion):
	tabPublicacion.set_text(publi.get_textoPubli() + "\n\n" + "["+publi.get_tipo()+"]")
	#NOTIFICACION_ACTIVA = true

func leer_archivo_publi():
	var ruta = rutaPublis
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
	
	var estadoLectura = "noLeyendo"
	
	while not archivo.eof_reached():
		var linea = archivo.get_line()
		
		linea = linea.strip_edges()
		if linea.begins_with("//") or linea == "":
			continue
		
		if linea.begins_with("#i"):
			estadoLectura = "textoNoti"
			continue
		elif linea.begins_with("#f"):
			if len(tpArray) == 0:
				tpArray.append("NULL")
				
			var publiNueva = Publicacion.new(tnA,idA,tipo,"".join(tpArray))
			PUBLICACIONES.append(publiNueva)
			
			tnA = "NULL"
			idA = "NULL"
			tipo = "NULL"
			tpArray.clear()
			
			estadoLectura = "noLeyendo"
		
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
					
				
				
				
		
	
	
