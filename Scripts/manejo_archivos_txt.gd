extends Node

#este script conecta los recujros multimedia con sus publicaciones
# y tambien lee los archiuvos de texto y los conviuerte en objetos

@export var RECURSOS_PUBLIS : Dictionary[int,Texture2D] = {
	0: preload("res://Assets/Publis/NoIMAGEN.png")
}#------ las imagenes se ven y asignan desde el inspector
@export var RECURSOS_ARTICULOS : Dictionary[int,Texture2D] = {
	0: preload("res://Assets/Publis/NoIMAGEN.png")
}

func _ready() -> void:
	Utils.RECURSOS = RECURSOS_PUBLIS
	Utils.RECURSOS_ARTICULOS = RECURSOS_ARTICULOS
	leer_archivo_publi()
	leer_archivo_articulos()


const rutaPublis = "res://Recursos/DATA_PUBLICACIONES.txt"
const rutaArticulos = "res://Recursos/DATA_ARTICULOS.txt"

const accionesPosibles = [
	"PUBLICAR",
	"INAPROPIADO",
	"FORMATO",
	"NO_RELACIONADA",
	"INFORMACION_ERRONEA"
]
const tiposArticulosPosibles = [
	"WIKI",
	"NOTICIA"
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
			Utils.PUBLICACIONES.set(idA,publiNueva)
			
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

func leer_archivo_articulos():
	var ruta = rutaArticulos
	if not FileAccess.file_exists(ruta):
		push_error("Archivo no encontrado: " + ruta)
		return
	
	var archivo = FileAccess.open(ruta, FileAccess.READ)
	if archivo == null:
		push_error("Error al abrir: " + str(FileAccess.get_open_error()))
		return
	var nombre = "NULL" #nombre del articulo, util como identificador pq no se muestra en pantalla
	var tipo = "NULL"
	var id = null
	var cat = "NULL" #Categoria del articulo, si aplica
	var titular = "NULL"
	var textoArray = [] #cuerpo de la noticiaa, array de lineas
	
	var estadoLectura = "noLeyendo"
	
	while not archivo.eof_reached():
		var linea = archivo.get_line()
		
		linea = linea.strip_edges()
		if linea.begins_with("//"):
			continue
		if linea == "[LINEAVACIA]" and estadoLectura == "texto":
			textoArray.append("[br][color=#00000000]L[/color][br]")
			continue
		
		if linea.begins_with("#i"):
			estadoLectura = "nombre"
			continue
		elif linea.begins_with("#f"):
			if len(textoArray) == 0:
				textoArray.append("NULL")
			if id == null:
				push_error("Id null en el articulo : ",nombre)
			
			var articulo = Articulo.new(nombre,tipo,id,cat,titular,"".join(textoArray))
			Utils.ARTICULOS.append(articulo)
			
			nombre = "NULL" 
			tipo = "NULL"
			id = null
			cat = "NULL" 
			titular = "NULL"
			textoArray.clear()
			
			estadoLectura = "noLeyendo"
		
		if estadoLectura == "noLeyendo":
			continue
		match estadoLectura:
			"nombre":
				if linea.begins_with("-name:"):
					nombre = linea.trim_prefix("-name:")
					estadoLectura = "tipo"
			"tipo":
				if linea.begins_with("-tipo:"):
					tipo = linea.trim_prefix("-tipo:")
					if tipo not in tiposArticulosPosibles:
						tipo = "INVALIDO"
						push_error("Tipo de articulo invalido para el articulo: ",nombre)
					estadoLectura = "id"
			"id":
				if linea.begins_with("-id:"):
					id = linea.trim_prefix("-id:").to_int()
					estadoLectura = "cat"
			"cat":
				if linea.begins_with("-cat:"):
					cat = linea.trim_prefix("-cat:")
					estadoLectura = "titular"
			"titular":
				if linea.begins_with("-titular:"):
					titular = linea.trim_prefix("-titular:")
					estadoLectura = "texto"
			"texto":
				textoArray.append(linea)
