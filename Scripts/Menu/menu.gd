extends Control
@onready var fade: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	fade.play("fade_in")
	await fade.animation_finished
	
func _on_llaves_pressed() -> void:
	get_tree().quit()
