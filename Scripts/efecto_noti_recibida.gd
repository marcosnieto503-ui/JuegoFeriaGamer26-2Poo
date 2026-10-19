extends Node2D





func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("espacio"):
		reproducirEfecto(Vector2(200,200),2)

var tween
func reproducirEfecto(pos:Vector2,times:int):
	#times es el numero de veces que se reproduce el efecto de parpadeo
	if tween:
		tween.kill()
	tween = create_tween()
	
	position = pos
	for i in range(times):
		tween.tween_property(self,"modulate",Color(0.125, 0.286, 0.792),0.2)
		#await tween.finished
		tween.tween_property(self,"modulate",Color(0.125, 0.286, 0.792,0.0),0.2)
		#await tween.finished
