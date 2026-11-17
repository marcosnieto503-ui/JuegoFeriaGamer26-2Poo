extends Control

##Lo que hace este script es que la el fondo se mueve
##conforme el puntero lo hace ,.,
@onready var inicio := position

var desplazamiento := 0.035
var suavidad := 4.0

func _process(delta):
	var centro := get_viewport_rect().size / 2.0
	var destino := inicio - (get_viewport().get_mouse_position() - centro) * desplazamiento
	position = position.lerp(destino, suavidad * delta)
