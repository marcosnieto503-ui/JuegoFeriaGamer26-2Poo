extends Control

func _ready() -> void:
	#Este await es la espera para poder ir al menu del juego en el inicio
	await get_tree().create_timer(1.5).timeout
	Transicion.ir_a("res://Escenas/Menu/Menu.tscn")
