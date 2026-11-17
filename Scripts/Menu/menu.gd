extends Control

@onready var anim: AnimationPlayer = $Escritorio/Botones/Celular/AnimationCelular
@onready var camara: Camera2D = $CameraEnfoque

func _on_hojas_pressed() -> void:
	await camara.enfocar($Escritorio/Botones/Hojas/PuntoCamara)
	Transicion.cambiarEscena("res://Escenas/Menu/Creditos.tscn")
	
func _on_laptop_pressed() -> void:
	await camara.enfocar($Escritorio/Botones/Laptop/PuntoCamara)
	Transicion.cambiarEscena("res://Escenas/selPersonaje/introduccion.tscn")

func _on_celular_pressed() -> void:
	$Escritorio.set_process(false)
	anim.play("acercar")
	await camara.enfocar($Escritorio/Botones/Celular/PuntoCamara)

func _on_atras_pressed() -> void:
	$Escritorio.set_process(true)
	anim.play_backwards("acercar")
	camara.volver()

func _on_llaves_pressed() -> void:
	get_tree().quit()
