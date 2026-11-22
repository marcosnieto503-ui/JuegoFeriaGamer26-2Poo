extends Control

#Esto se coloca por si cambio la ubicacion de la escena Godot automaticamente
#Haga el cambio
@export_file("*.tscn") var escena_creditos: String = "res://Escenas/Menu/Creditos.tscn"
@export_file("*.tscn") var escena_juego: String = "res://Escenas/selPersonaje/introduccion.tscn"

@onready var camara: Camera2D = $CameraEnfoque
@onready var musica: AudioStreamPlayer = $Musica
@onready var escritorio: Control = $Escritorio
@onready var anim: AnimationPlayer = $Escritorio/Botones/Celular/AnimationCelular

#No se coloca tipo de nodo a boton para que quede dinamico boton_escritorio .-,

func _ir_a_escena(boton, ruta: String) -> void:
	await camara.enfocar(boton.obtener_punto_camara())
	Transicion.cambiarEscena(ruta)

func _on_hojas_pressed() -> void:
	_ir_a_escena($Escritorio/Botones/Hojas, escena_creditos)
	
func _on_laptop_pressed() -> void:
	_ir_a_escena($Escritorio/Botones/Laptop, escena_juego)

func _on_celular_pressed() -> void:
	escritorio.pausar_movimiento()
	anim.play("acercar")
	await camara.enfocar($Escritorio/Botones/Celular.obtener_punto_camara())

func _on_atras_pressed() -> void:
	escritorio.reanudar_movimiento()
	anim.play_backwards("acercar")
	camara.volver()

func _on_llaves_pressed() -> void:
	get_tree().quit()

func _on_mouse_pressed() -> void:
	Transicion.cambiarEscena("res://Escenas/Menu/ComoJugar/Controles.tscn")
