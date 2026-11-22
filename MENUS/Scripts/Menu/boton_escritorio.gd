extends TextureButton

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var punto_camara: Control = $PuntoCamara

func obtener_punto_camara() -> Control:
	return punto_camara

func _on_mouse_entered() -> void:
	anim.play("mouse_entered")

func _on_mouse_exited() -> void:
	anim.play_backwards("mouse_entered")

func _on_musica_pressed() -> void:
	anim.play("volumen")

func _on_general_pressed() -> void:
	pass
