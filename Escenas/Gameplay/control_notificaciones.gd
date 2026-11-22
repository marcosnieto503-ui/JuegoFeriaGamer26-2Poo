extends Node

var cajaNotif:Control

func ingresar_notificacion_random():
	if Utils.PUBLICACIONES.is_empty():
		push_warning("(control notificaciones) El dict Utils.Publicaciones esta vacio, no hay noti que meter")
		return
	var notif = FactoryEscenas.crear_scene_notificacion()
	var publi_a_asignar = Utils.PUBLICACIONES.get(Utils.PUBLICACIONES.keys().pick_random())
	if publi_a_asignar == null:
		push_error("(cibtrik notificacioemes)No hay mas publicaciones para mostrar, array vacio mostro.")
		return
	Utils.excluirPublicacion(publi_a_asignar)
	
	cajaNotif.add_child(notif)
	
	notif.asignarPubli(publi_a_asignar)
	GlobalEfectos.efectoNotiRecibida(Vector2(1360,640),2)
	GlobalAudioSignals.playNotiRecibida()
	#print("NOTIFICACION ALEATORIA INGRESADA")
