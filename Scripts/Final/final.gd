extends Node2D

@onready var avatar: Sprite2D = $Hojas/ContenidoHoja/Divisiones/Perfil/Retrato/Personaje

func _ready() -> void:
	avatar.texture = PersistenciaPersonaje.obtener_reaccion("feliz")
