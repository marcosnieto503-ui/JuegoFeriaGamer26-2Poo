extends Control

@export_file("*.tscn") var siguiente_escena: String = "res://Escenas/Menu/Menu.tscn"

func _on_timer_timeout() -> void:
	Transicion.cambiarEscena(siguiente_escena)
