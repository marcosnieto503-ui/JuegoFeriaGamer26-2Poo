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
	aplicarModulateRandomUserIcon()
	GlobalAudioSignals.playUiRetroEffect1()

func aplicarModulateRandomUserIcon():
	$Control/UserIcon.modulate = Color.from_hsv(randf(), 0.9, 1)

func _on_button_c_pressed() -> void:
	GlobalAudioSignals.playNoticieroClosed()
	UtilsComentarios.procesarComment(comentario,publi)
	queue_free()
