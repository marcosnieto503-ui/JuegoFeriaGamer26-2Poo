extends PanelContainer

var comentario:Comentario
var publi:Publicacion

@onready var cajaComment = $Control/CommentCaja

func asignarComentario(com:Comentario,p:Publicacion) -> bool:
	if !com or !p:
		return false
	comentario = com
	publi = p
	return true  

func _ready():
	if comentario:
		inicializar()

func inicializar():
	cajaComment.set_text(comentario.get_texto())


func _on_button_c_pressed() -> void:
	UtilsComentarios.procesarComment(comentario,publi)
