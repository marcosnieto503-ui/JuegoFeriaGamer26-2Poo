extends PanelContainer

var comentario:Comentario

@onready var cajaComment = $VBoxContainer/PanelContainer/RichTextLabel2
@onready var cajaPubliText = $VBoxContainer/RichTextLabel

func asignarComentario(com:Comentario) -> bool:
	if !com:
		return false
	comentario = com
	return true  

func _ready():
	inicializar()

func inicializar():
	if !comentario:
		push_error("NO HAY COMENTARIO ASIGNADO")
		return
	cajaComment.set_text(comentario.get_texto())
	cajaPubliText.set_text(Utils.PUBLIS_EXCLUIDAS.get(comentario.get_id()).get_textoPubli())
