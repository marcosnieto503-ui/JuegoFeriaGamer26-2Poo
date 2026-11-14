extends Control

##Lo que hace este script es que la el fondo se mueve
##conforme el puntero lo hace ,.,

@export var max_desplazamiento := Vector2(20, 12)
@export var suavidad := 4.0

var pos_inicial: Vector2

func _ready():
	pos_inicial = position

func _process(delta):
	var pantalla := get_viewport().get_visible_rect().size
	var offset := (get_viewport().get_mouse_position() / pantalla) * 2.0 - Vector2.ONE
	position = position.lerp(pos_inicial - offset * max_desplazamiento, suavidad * delta)
