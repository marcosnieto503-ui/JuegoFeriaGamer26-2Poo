extends TextureButton

@onready var anim: AnimationPlayer = $AnimationPlayer

#todos los botones van a hacer esto
func _on_mouse_entered() -> void:
	anim.play("mouse_entered")

func _on_mouse_exited() -> void:
	anim.play_backwards("mouse_entered")
