extends Control

@onready var anim: AnimationPlayer = $AnimationPlayer

var presionado: bool = false

func _on_mouse_entered() -> void:
	if not presionado:
		anim.play("focus")

func _on_button_down() -> void:
	presionado = true
	anim.play("presionado")

func _on_mouse_exited() -> void:
	if not presionado:
		anim.play_backwards("focus")
