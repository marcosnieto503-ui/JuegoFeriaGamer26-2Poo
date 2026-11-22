extends Node

@onready var ComOverlay:Control #inicializado en el ready de ControlComentarios


func procesarComment(c:Comentario,p:Publicacion):
	if ComOverlay:
		ComOverlay._inicializar(c,p)

func procesarComentarioEnPuntuacion(c:Comentario):
	ProgresoPuntuacion.Ingresar_Comentario_Correcto(c)
	print("(Utils_Comentario) comentario con id %s procesado en puntuacion" % c.get_id())
