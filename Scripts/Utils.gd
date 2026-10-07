extends Node

var tabsActivas = 1 
#el tabsActivas empieza en uno para usarlo como indice en las pesta;as

@onready var cajaNotis = $/root/Gameplay/Celular/ScrollNotificaciones/CajaNotificaciones
@onready var tabsPublisContainer = $/root/Gameplay/Laptop/Pestañas
@onready var tabPublicacion = preload("res://Escenas/ventana_publicacion.tscn")

var TABS_BLOQUEADAS = false
func bloquear_cambio_tabs():
	if not TABS_BLOQUEADAS:
		for i in tabsPublisContainer.get_tab_count():
			tabsPublisContainer.set_tab_disabled(i, true)
		TABS_BLOQUEADAS = true
	else:
		for i in tabsPublisContainer.get_tab_count():
			tabsPublisContainer.set_tab_disabled(i, false)
		TABS_BLOQUEADAS = false

func desactivar_press_notis():
	for hijo in cajaNotis.get_children():
		hijo.desactivarBoton()
func activar_press_notis():
	for hijo in cajaNotis.get_children():
		hijo.activarBoton()

var PUBLICACIONES :Array[Publicacion] = []  #////////////////////////////


const RUTAS_RECURSOS = {
	1 :"ruta1",
	2 :"ruta2",
	3 :"ruta3",
	4 :"ruta4",
	5 :"ruta1",
	6 :"ruta2",
	7 :"ruta3",
	8 :"ruta4",
	9 :"ruta1",
	10 :"ruta2",
	11 :"ruta3",
	12 :"ruta4",
	13 :"po"
}
#ee funciones utiles accesibnles desde todo el proyecto
const rutaPublis = "res://Recursos/DATA_PUBLICACIONES.txt"

func ingresarPublicacion(publi : Publicacion):
	if tabsActivas > 3:
		return
	var tabNoti = tabPublicacion.instantiate() #tabPublicacion = ventana_publicacion
	tabNoti.name = "Publicacion "+ str(tabsActivas)
	
	tabsPublisContainer.add_child(tabNoti)
	tabsPublisContainer.set_current_tab(tabsActivas)
	
	tabsActivas += 1
	print("CONTADOR de TABS: " + str(tabsActivas))
	
	tabNoti.inicializar(publi)



const accionesPosibles = [
	"PUBLICAR",
	"INAPROPIADO",
	"FORMATO",
	"NO_RELACIONADA",
	"INFORMACION_ERRONEA"
]

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
	var accion = "NULL"
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
				
			var publiNueva = Publicacion.new(tnA,idA,tipo,accion,"".join(tpArray))
			PUBLICACIONES.append(publiNueva)
			
			tnA = "NULL"
			idA = "NULL"
			tipo = "NULL"
			accion = "NULL"
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
					estadoLectura = "accion"
			"accion":
				if linea.begins_with("-A:"):
					accion = linea.trim_prefix("-A:")
					if accion not in accionesPosibles:
						accion = "invalido"
					estadoLectura = "textoPubli"
			"textoPubli":
				tpArray.append(linea)
					
				
				
				
		
	
	
