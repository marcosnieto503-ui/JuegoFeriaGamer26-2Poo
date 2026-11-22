extends Node


var MaxTabsNum = 3 #po
var ARTICULO_ACTIVO = false
#el tabsActivas empieza en uno para usarlo como indice en las pesta;as
var PUBLICACIONES :Dictionary[int,Publicacion]  #////////////////////////////
var PUBLIS_EXCLUIDAS : Dictionary[int,Publicacion]  # Publicaciones que ya han llegado al telefono, no vuelven a aparecer
var RECURSOS : Dictionary[int,Texture2D] = {}#------ las imagenes se ven y asignan desde el inspector del nodo gameplay




var cajaNotis:Control
var tabsContainer:Control
var tabPublicacion = preload("res://Escenas/VentanaPublicacion/ventana_publicacion.tscn")

signal _link_Clickeado(id :int)
signal _publi_ingresada

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
func puedeEntrarPubli() -> bool:
	if ARTICULO_ACTIVO:
		return tabsContainer.get_tab_count() < MaxTabsNum +2
	return tabsContainer.get_tab_count() < MaxTabsNum +1

func liberarTabIndex(i:int):
	TabIndexes[i] = false
var TabIndexes:Dictionary[int,bool] = {
	1:false,
	2:false,
	3:false
}
func ingresarPublicacion(publi : Publicacion):
	if !puedeEntrarPubli():
		return
	var tabIndex:int
	for i in TabIndexes.keys():
		if TabIndexes[i] == false:
			tabIndex = i
			TabIndexes[i] = true
			break
	if !tabIndex:
		push_error("NO HAY TAB INDICE LIBRE EN EL DICCIONARIO")
		return
	var tabPubli = FactoryEscenas.crear_tab_publicacion() #tabPublicacion = ventana_publicacion
	tabPubli.name = "Publicacion "+ str(tabIndex)
	
	tabsContainer.add_child(tabPubli)
	tabsContainer.set_current_tab(tabsContainer.get_tab_count()-1)
	
	tabPubli.inicializar(publi,tabIndex)
	_publi_ingresada.emit()

#esto se llama cuando una publi llega al telefono, para que no vuelva a aparecer
func excluirPublicacion(publi: Publicacion):
	PUBLICACIONES.erase(publi.get_id())
	PUBLIS_EXCLUIDAS.set(publi.get_id(),publi)
	print("-Publicacion excluida, no volvera a aparecer: ", publi.get_id())
