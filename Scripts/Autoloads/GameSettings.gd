extends Node

var filtroDaltonismoNode:ColorRect #se asigna en el mismo nodo

var filtro_activo = false

enum ENUM_FILTROS_DALTONISMO {
	DESACTIVADO,
	PROTANOPIA,
	DEUTERANOPIA,
	TRITANOPIA
}

func AsignarFiltroDaltonismo(opcion:GameSettings.ENUM_FILTROS_DALTONISMO = GameSettings.ENUM_FILTROS_DALTONISMO.DESACTIVADO):
	if !filtroDaltonismoNode:
		push_error("No hay nodo filtro daltonismo asignado")
		return
	var shader:ShaderMaterial = filtroDaltonismoNode.material
	shader.set_shader_parameter("modo", int(opcion))
	if opcion != GameSettings.ENUM_FILTROS_DALTONISMO.DESACTIVADO:
		filtro_activo = true
	else:
		filtro_activo = false
