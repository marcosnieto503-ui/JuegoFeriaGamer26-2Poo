extends AudioStreamPlayer

@export var hover: AudioStreamPlayer
@export var click: AudioStreamPlayer

func _ready() -> void:
	SonidoUi.hover = hover
	SonidoUi.click = click
	print(hover)
