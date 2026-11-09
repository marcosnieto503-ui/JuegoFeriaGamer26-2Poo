extends TextureButton



func _on_mouse_entered() -> void:
	GlobalAudioSignals.playHoverNoti()
