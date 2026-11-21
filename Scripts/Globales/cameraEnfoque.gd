extends Camera2D

#Esto lo que hace es hacer un pequeño zoom algun punto en este caso algun boton
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var pos_inicial := global_position

var ultima_anim := ""

func enfocar(punto: CanvasItem, nombre_anim := "zoom_normal") -> void:
	global_position = punto.global_position
	ultima_anim = nombre_anim
	anim.play(nombre_anim)

func volver() -> void:
	if ultima_anim != "":
		anim.play_backwards(ultima_anim)
	global_position = pos_inicial
