extends Camera2D

@onready var centro: Vector2 = get_viewport_rect().size / 2

# Lo que hace esto es mover la camara de manera inmersiva con el mouse
func _process(delta: float) -> void:
	offset = (get_viewport().get_mouse_position() - centro) * 0.04
