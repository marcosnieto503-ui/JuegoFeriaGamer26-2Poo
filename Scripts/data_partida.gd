extends Node

#-----------------------------
#este nodo maneja el progreso de la partida, procesa las decisiones y reproduce el feedbacjk visual
#-----------------------

@export var DURACION_FEEDBACK_ANIMACION :float

@onready var reacciones = $/root/Gameplay/EscenaReacciones

var PUBLIS_PUBLICADAS :Array[Publicacion] = []
var PUBLIS_DESCARTADAS :Array[Publicacion] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# esta autoasignacion se hace porqu el script es un autoload y las variables enm el inspector no se aplican automatiacmente al autoload por alguna razon
	DataPartida.DURACION_FEEDBACK_ANIMACION = DURACION_FEEDBACK_ANIMACION
	print("podd, ",DataPartida.DURACION_FEEDBACK_ANIMACION)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func procesarPubli(publi:Publicacion, playerAccion :String):
	var accionEsperada = publi.get_accion()
	if accionEsperada == "invalido":
		push_error("Accion invalida en publicacion de ID: " + str(publi.get_id()))
		return
	
	if playerAccion == accionEsperada:
		reacciones.displayAnimFeedback("bien_hecho",Vector2(1340,350),DURACION_FEEDBACK_ANIMACION)
		GlobalAudioSignals.playCorrectAnswer()
	else:
		reacciones.displayAnimFeedback("mal_hecho",Vector2(225,350),DURACION_FEEDBACK_ANIMACION)
		GlobalAudioSignals.playWrongAnswer()
	
	if playerAccion == "PUBLICAR":
		PUBLIS_PUBLICADAS.append(publi)
	else:
		PUBLIS_DESCARTADAS.append(publi)


func animBienHecho():
	pass
func animMalHecho():
	pass
