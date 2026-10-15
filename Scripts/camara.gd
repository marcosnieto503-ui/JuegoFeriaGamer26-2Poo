extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var tween_actual: Tween

func zoom_hacia(posicion_objetivo: Vector2, nivel_zoom: float, duracion: float = 0.4):
	if tween_actual:
		tween_actual.kill()
	var zoom_clampeado = clamp(nivel_zoom, 0.3, 1.7)
	
	tween_actual = create_tween()
	tween_actual.set_parallel(true)
	tween_actual.tween_property(self, "global_position", posicion_objetivo, duracion).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_actual.tween_property(self, "zoom", Vector2(zoom_clampeado, zoom_clampeado), duracion).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween_actual.finished
	
func reiniciar_camara(duracion: float = 0.3):
	if tween_actual:
		tween_actual.kill()

	tween_actual = create_tween()
	tween_actual.set_parallel(true)
	tween_actual.tween_property(self, "global_position", Vector2.ZERO, duracion).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_actual.tween_property(self, "zoom", Vector2.ONE, duracion).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween_actual.finished
