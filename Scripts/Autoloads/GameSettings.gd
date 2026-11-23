extends Node

var filtroDaltonismoNode:ColorRect #se asigna en el mismo nodo

var filtro_activo = false

enum ENUM_FILTROS_DALTONISMO {
	DESACTIVADO,
	PROTANOPIA,
	DEUTERANOPIA,
	TRITANOPIA
}

var filtroActual:GameSettings.ENUM_FILTROS_DALTONISMO = GameSettings.ENUM_FILTROS_DALTONISMO.DESACTIVADO

func AsignarFiltroDaltonismo(opcion:GameSettings.ENUM_FILTROS_DALTONISMO = GameSettings.ENUM_FILTROS_DALTONISMO.DESACTIVADO):
	if !filtroDaltonismoNode:
		push_error("No hay nodo filtro daltonismo asignado")
		return
	if opcion == filtroActual:
		return
	var shader:ShaderMaterial = filtroDaltonismoNode.material
	shader.set_shader_parameter("modo", int(opcion))
	if opcion != GameSettings.ENUM_FILTROS_DALTONISMO.DESACTIVADO:
		filtro_activo = true
	else:
		filtro_activo = false
	filtroActual = opcion


func AsignarVolumen(value:float = 0):
	var bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	var busFondo = AudioServer.get_bus_index("MusicaFondo")
	AudioServer.set_bus_volume_db(busFondo, linear_to_db(value))
