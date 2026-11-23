extends Control

#Esto se coloca por si cambio la ubicacion de la escena Godot automaticamente
#Haga el cambio

@onready var camara: Camera2D = $CameraEnfoque
@onready var musica: AudioStreamPlayer = $Musica
@onready var escritorio: Control = $Escritorio

#No se coloca tipo de nodo a boton para que quede dinamico boton_escritorio .-,

func _ir_a_escena(boton, ruta: String) -> void:
	await camara.enfocar(boton.obtener_punto_camara())
	#Transicion.cambiarEscena(ruta)

func _on_hojas_pressed() -> void:
	#_ir_a_escena($Escritorio/Botones/Hojas, escena_creditos)
	GameManager.CAMBIAR_DE_ESCENA(GameManager.ENUMESCENAS.MENUCREDITOS)
	
func _on_laptop_pressed() -> void:
	#_ir_a_escena($Escritorio/Botones/Laptop, escena_juego)
	GameManager.CAMBIAR_DE_ESCENA(GameManager.ENUMESCENAS.INTRODUCCION,1)



func _on_llaves_pressed() -> void:
	get_tree().quit()

func _on_mouse_pressed() -> void:
	#Transicion.cambiarEscena("res://Escenas/Menu/ComoJugar/Controles.tscn")
	GameManager.CAMBIAR_DE_ESCENA(GameManager.ENUMESCENAS.COMOJUGAR)
