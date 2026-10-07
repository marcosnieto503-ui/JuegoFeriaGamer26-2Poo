extends Node2D

@onready var animFeedback = $"Señales"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animFeedback.set_visible(false)
	pass # Replace with function body.

func displayAnimFeedback(anim:String,posicion:Vector2, duracion:float):
	animFeedback.position = posicion
	animFeedback.set_visible(true)
	animFeedback.set_animation(anim)
	animFeedback.play()
	await get_tree().create_timer(duracion).timeout  # espera 1.5 segundos
	animFeedback.visible = false
	animFeedback.stop()
