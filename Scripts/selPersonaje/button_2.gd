extends Button

@export var sprite: Sprite2D

func _pressed() -> void:
	sprite.texture = load(PersistenciaPersonaje.ruta_reaccion("feliz"))
