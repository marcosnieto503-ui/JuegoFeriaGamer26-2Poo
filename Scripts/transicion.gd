extends CanvasLayer

@onready var anim: AnimationPlayer = $AnimationPlayer

func cambiar_escena(ruta: String) -> void:
	if anim.is_playing() and anim.current_animation == "fade_out":
		return
	anim.play("fade_out")
	await anim.animation_finished
	get_tree().change_scene_to_file(ruta)
	anim.play("fade_in")
	
