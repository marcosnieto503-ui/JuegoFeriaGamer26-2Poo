extends CanvasLayer

@onready var anim: AnimationPlayer = $AnimationPlayer

var cambiando = false

func cambiarEscena(ruta: String, conFade := true) -> void:
	if cambiando or ruta.is_empty():
		return
	
	cambiando = true

	if conFade:
		anim.play("fade_out")
		await anim.animation_finished
	
	get_tree().change_scene_to_file(ruta)
	
	if conFade:
		anim.play("fade_in")
		await anim.animation_finished
	
	cambiando = false
