extends Node2D



func _ready() -> void:
	pass


var tween:Tween
func reproducirEfecto(pos:Vector2,times:int):
	#print("REPRODUCIDO EN: ",pos)
	#times es el numero de veces que se reproduce el efecto de parpadeo
	if tween and tween.has_tweeners():
		tween.kill()
	tween = create_tween().set_loops(times)
	
	position = pos
	tween.tween_property(self,"modulate",Color(0.125, 0.286, 0.792),0.2)
	tween.tween_property(self,"modulate",Color(0.125, 0.286, 0.792,0.0),0.2)


func pausarEfecto():
	if tween and tween.is_valid():
		tween.pause()
func reanudarEfecto():
	if tween and tween.is_valid():
		tween.play()
