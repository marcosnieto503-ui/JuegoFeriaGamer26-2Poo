extends TextureButton

@onready var anim: AnimationPlayer = $AnimationPlayer

func _on_mouse_entered() -> void:
	anim.play("focus")
	
func _on_mouse_exited() -> void:
		anim.play_backwards("focus")
