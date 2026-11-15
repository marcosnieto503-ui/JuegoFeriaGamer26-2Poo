extends Control

@onready var anim: AnimationPlayer = $Escritorio/Botones/Celular/AnimationCelular

func _on_hojas_pressed() -> void:
	$Escritorio.set_process(false)
	Transicion.ir_a("res://Escenas/Menu/Creditos.tscn", $Escritorio/Botones/Hojas)

func _on_laptop_pressed() -> void:
	pass # Aqui va a ir seleccion de personaje

func _on_celular_pressed() -> void:
	#Como este boton solo se acerca no necesita transicion y el zoom Vector2
	#es mas alto
	$Escritorio.set_process(false)
	anim.play("acercar")
	Transicion.ir_a("", $Escritorio/Botones/Celular, Vector2(4.5, 4.5), false)

func _on_atras_pressed() -> void:
	anim.play_backwards("acercar")
	Transicion.ir_a("", null, Vector2.ONE, false)
	$Escritorio.set_process(true)

func _on_llaves_pressed() -> void:
	get_tree().quit()
