extends TextureButton

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sombra: TextureRect = $Sombra

func _ready() -> void:
	sombra.texture = texture_normal

func _on_mouse_entered() -> void:
	anim.play("mouse_entered")

func _on_mouse_exited() -> void:
	anim.play_backwards("mouse_entered")
