extends Camera2D

# Lo que hace esto es mover la camara de manera inmersiva con el mouse
var centro = get_viewport_rect().size / 2
func _process(delta: float) -> void:
	position = (get_viewport().get_mouse_position() - centro) * 0.04
