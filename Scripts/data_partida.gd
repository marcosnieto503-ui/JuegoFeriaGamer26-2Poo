extends Node

@onready var reacciones = $/root/Gameplay/EscenaReacciones

var PUBLIS_PUBLICADAS :Array[Publicacion] = []
var PUBLIS_DESCARTADAS :Array[Publicacion] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		reacciones.displayAnimFeedback("bien_hecho",Vector2(1300,350),2)
		pass
	else:
		reacciones.displayAnimFeedback("mal_hecho",Vector2(225,350),2)
		pass
	
	if playerAccion == "PUBLICAR":
		PUBLIS_PUBLICADAS.append(publi)
	else:
		PUBLIS_DESCARTADAS.append(publi)


func animBienHecho():
	pass
func animMalHecho():
	pass
