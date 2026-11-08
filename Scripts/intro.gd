extends Control

#Animacion entrada del juego logo --> menu
@onready var anim: AnimationPlayer = $AnimationPlayer
func _ready() -> void:
	anim.play("logo")
	await anim.animation_finished
	
	anim.play_backwards("logo")
	await anim.animation_finished
	
	get_tree().change_scene_to_file("res://Escenas/Menu.tscn")
