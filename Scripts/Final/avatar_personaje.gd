extends TextureRect

@onready var avatar: Sprite2D = $Avatar

func _ready() -> void:
	avatar.texture = PersistenciaPersonaje.obtener_reaccion("Feliz")
