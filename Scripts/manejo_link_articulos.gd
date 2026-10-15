extends Node

@onready var tabsContainer = $/root/Gameplay/Laptop/Pestañas
@onready var tabNoticiero = preload("res://Escenas/noticiero.tscn")
@onready var tabWiki = preload("res://Escenas/wiki.tscn")
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#esta señal la envian las ventanas publicacion al clickear un link
	Utils._link_Clickeado.connect(ingresarArticulo) #la señal envia el id de la publi

func ingresarArticulo(id_articulo:int):
	var ar = buscarArticulo(id_articulo)
	if ar == null:
		push_error("ARTICULO CON ID: ",id_articulo," NO EXISTE")
		return;
	
	var sceneArticulo
	if ar.get_tipo() == "NOTICIA":
		sceneArticulo = tabNoticiero.instantiate()
	elif ar.get_tipo() == "WIKI":
		sceneArticulo = tabWiki.instantiate()
	else:
		push_error("TIPO DE ARTICULO INVALIDO FUAP, NOMBRE: ",ar.get_nombre())
		return
	
	tabsContainer.add_child(sceneArticulo)
	sceneArticulo.inicializar(ar)
	tabsContainer.set_current_tab(tabsContainer.get_tab_count()-1) #recien agregada
	print("----NOTICIA AGREGADA")
	
	Utils.ARTICULO_ACTIVO = true
	

func buscarArticulo(id:int) -> Articulo:
	
	var artic :Articulo = null
	
	for ar in Utils.ARTICULOS:
		if ar.get_id() == id:
			artic = ar
	
	if artic == null:
		return null
	else:
		return artic
