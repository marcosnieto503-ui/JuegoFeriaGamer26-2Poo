extends Node

@onready var ComOverlay:Control


func procesarComment(c:Comentario,p:Publicacion):
	if ComOverlay:
		ComOverlay._inicializar(c,p)
