extends Node

var tabsActivas = 1 
var ARTICULO_ACTIVO = false
#el tabsActivas empieza en uno para usarlo como indice en las pesta;as
var PUBLICACIONES :Array[Publicacion] = []  #////////////////////////////
var RECURSOS : Dictionary[int,Texture2D] = {}#------ las imagenes se ven y asignan desde el inspector del nodo gameplay

var ARTICULOS : Array[Articulo] = []
#a este diccionario de imagenes se le asignan desde el scirp del gameplay, desde el inmspector
var RECURSOS_ARTICULOS : Dictionary[int,Texture2D] = {} 


@onready var cajaNotis = $/root/Gameplay/Celular/ScrollNotificaciones/CajaNotificaciones
@onready var tabsContainer = $/root/Gameplay/Laptop/Pestañas
@onready var tabPublicacion = preload("res://Escenas/ventana_publicacion.tscn")

signal _link_Clickeado(id :int)

var TABS_BLOQUEADAS = false
func bloquear_cambio_tabs():
	if not TABS_BLOQUEADAS:
		for i in tabsContainer.get_tab_count():
			tabsContainer.set_tab_disabled(i, true)
		TABS_BLOQUEADAS = true
	else:
		for i in tabsContainer.get_tab_count():
			tabsContainer.set_tab_disabled(i, false)
		TABS_BLOQUEADAS = false

func desactivar_press_notis():
	for hijo in cajaNotis.get_children():
		hijo.desactivarBoton()
func activar_press_notis():
	for hijo in cajaNotis.get_children():
		hijo.activarBoton()

#ee funciones utiles accesibnles desde todo el proyecto

func ingresarPublicacion(publi : Publicacion):
	if tabsActivas > 3:
		return
	var tabNoti = tabPublicacion.instantiate() #tabPublicacion = ventana_publicacion
	tabNoti.name = "Publicacion "+ str(tabsActivas)
	
	tabsContainer.add_child(tabNoti)
	tabsContainer.set_current_tab(tabsActivas)
	
	tabsActivas += 1
	print("CONTADOR de TABS: " + str(tabsActivas))
	
	tabNoti.inicializar(publi)
	


func ingresarArticulo(data:String):
	tabsContainer.add_child(preload("res://Escenas/noticiero.tscn").instantiate())
	tabsContainer.set_current_tab(tabsActivas)
	print("NOTICIA AGREGADA")
