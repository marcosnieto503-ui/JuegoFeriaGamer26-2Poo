extends Node
class_name FactoryEscenas

const ventanaPublicacion = preload("res://Escenas/VentanaPublicacion/ventana_publicacion.tscn")
const escenaNotificacion = preload("res://Escenas/NotificacionScene/notificacion.tscn")

static func crear_tab_publicacion() -> Control:
	return ventanaPublicacion.instanciate()

static func crear_scene_notificacion() -> Control:
	return escenaNotificacion.instantiate()
