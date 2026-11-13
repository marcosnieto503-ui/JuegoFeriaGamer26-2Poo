extends Node
class_name ControlNotificaciones

const cajaNotifRUTA = "../../Celular/ScrollNotificaciones/CajaNotificaciones"

static func ingresar_notificacion_random():
	if Utils.PUBLICACIONES.is_empty():
		push_warning("(logica_jugable) El dict Utils.Publicaciones esta vacio, no hay noti que meter")
		return
	var notif = FactoryEscenas.crear_scene_notificacion()
	var publi_a_asignar = Utils.PUBLICACIONES.get(Utils.PUBLICACIONES.keys().pick_random())
	if publi_a_asignar == null:
		push_error("No hay mas publicaciones para mostrar, array vacio mostro.")
		return
	Utils.excluirPublicacion(publi_a_asignar)
	
	var arbol = Engine.get_main_loop() as SceneTree
	var control = arbol.root.get_node("Gameplay/Utils/ControlNotificaciones")
	var cajaNotif = control.get_node(cajaNotifRUTA)
	cajaNotif.add_child(notif)
	
	notif.asignarPubli(publi_a_asignar)
	GlobalEfectos.efectoNotiRecibida(Vector2(1360,640),2)
	GlobalAudioSignals.playNotiRecibida()
	#print("NOTIFICACION ALEATORIA INGRESADA")
