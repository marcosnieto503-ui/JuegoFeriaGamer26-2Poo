extends CheckButton

@export var camaraNode:Camera2D


func _on_toggled(toggled_on: bool) -> void:
	match toggled_on:
		true:
			camaraNode.reiniciar_camara()
			camaraNode.zoomPermitido = false
		false:
			camaraNode.zoomPermitido = true
