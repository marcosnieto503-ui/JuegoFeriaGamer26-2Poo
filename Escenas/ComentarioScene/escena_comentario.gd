extends PanelContainer

var comentario:Comentario

@onready var cajaComment = $VBoxContainer/CommentContainer/CommentCaja
@onready var cajaPubliText = $VBoxContainer/PubliCOntainer/PubliCaja

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
	var publiT:String = Utils.PUBLIS_EXCLUIDAS.get(comentario.get_id()).get_textoPubli()
	publiT = publiT.erase(75,publiT.length()-75)
	publiT = publiT.insert(publiT.length()-1,"....")
	cajaPubliText.set_text(publiT)
