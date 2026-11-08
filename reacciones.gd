extends AnimatedSprite2D
@export var tamaño_gifs : Vector2 = Vector2(400, 400) # eto es el tamaño al q se van a escalar los gif
# @export var tamaño_idle : Vector2 = Vector2.ONE# eto es el tamaño del idle creo
func reaccionar(tipo : String) -> void:
	if sprite_frames.has_animation(tipo) :
		play(tipo)
	else:
		push_warning("no existe la animacion, echale ojo")
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_finished.connect(_on_animation_finished)
	frame_changed.connect(_ajustar_tamaño)
	animation_changed.connect(_ajustar_tamaño)
	play("idle")
	_ajustar_tamaño()

func _ajustar_tamaño() -> void:
	if animation == "idle":
		return
	var tex := sprite_frames.get_frame_texture(animation, frame)
	if tex == null:
		return
	var tam := tex.get_size()
	var factor := minf(tamaño_gifs.x / tam.x, tamaño_gifs.y / tam.y)
	scale = Vector2(factor, factor)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_W):
		reaccionar("reaccion1")
	pass


func _on_animation_finished() -> void:
	if animation != "idle" :
		play("idle")
