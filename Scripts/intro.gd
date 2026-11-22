extends Control

@export_file("*.tscn") var siguiente_escena: String = "res://Escenas/Menu/Menu.tscn"

func _ready() -> void:
	Volumen.ocultar()

func _exit_tree() -> void:
	Volumen.mostrar()

func _on_timer_timeout() -> void:
	Transicion.cambiarEscena(siguiente_escena)
