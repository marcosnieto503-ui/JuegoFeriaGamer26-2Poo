extends Node2D

@onready var personaje: Sprite2D = $Avatar

func _ready() -> void:
	PersistenciaPersonaje.guardar("Mujer", "Negro", "Trenzas")
	cambiar_emocion("triste")

func cambiar_emocion(reaccion: String) -> void:
	personaje.texture = PersistenciaPersonaje.obtener_reaccion(reaccion)

func _on_button_pressed() -> void:
	cambiar_emocion("feliz")

func _on_button_2_pressed() -> void:
	cambiar_emocion("triste")

func _on_button_3_pressed() -> void:
	cambiar_emocion("enojado")

func _on_button_4_pressed() -> void:
	cambiar_emocion("sorprendido")
