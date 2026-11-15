extends CanvasLayer

@onready var anim: AnimationPlayer = $AnimationPlayer

var pos_inicial: Vector2
var zoom_inicial: Vector2
var en_zoom := false

func ir_a(ruta := "", boton: Control = null, zoom_obj := Vector2(2.2, 2.2), con_fade := true) -> void:
	var cam := get_viewport().get_camera_2d()
	var t: Tween
	
	#Aqui lo hice con tween porque si no con AnimationPlayer si despues muevo los objetos
	#me toca manualmente cambiar cada key de la animacion no aguanta ñ-ñ
	if boton or ruta == "":
		if not en_zoom:
			pos_inicial = cam.global_position
			zoom_inicial = cam.zoom
			en_zoom = true
			
		var destino := boton.get_global_transform() * boton.pivot_offset if boton else pos_inicial
		var z := zoom_obj if boton else zoom_inicial
		if boton:
			pos_inicial = cam.global_position
			zoom_inicial = cam.zoom
		t = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		t.tween_property(cam, "global_position", destino, 0.8)
		t.tween_property(cam, "zoom", z, 0.8)

	if con_fade:
		anim.play("fade_out")
		await anim.animation_finished
		get_tree().change_scene_to_file(ruta)
		anim.play("fade_in")
	else:
		await t.finished
	
	if ruta != "":
		en_zoom = false
		get_tree().change_scene_to_file(ruta)
		if con_fade:
			anim.play("fade_in")
	elif not boton:
		en_zoom = false
