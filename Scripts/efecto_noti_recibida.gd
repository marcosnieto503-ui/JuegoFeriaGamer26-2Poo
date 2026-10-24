extends Node2D



func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

var tween
func reproducirEfecto(pos:Vector2,times:int):
	print("REPRODUCIDO EN: ",pos)
	#times es el numero de veces que se reproduce el efecto de parpadeo
	if tween and tween.has_tweeners():
		tween.kill()
	tween = create_tween()
	
	position = pos
	for i in range(times):
		tween.tween_property(self,"modulate",Color(0.125, 0.286, 0.792),0.2)
		#await tween.finished
		tween.tween_property(self,"modulate",Color(0.125, 0.286, 0.792,0.0),0.2)
		#await tween.finished
