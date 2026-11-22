extends Node


@export var visualsNode:Node
@export var logicaJugableNode:Node
@export var camaraNode:Camera2D
@onready var canvasBloqueaBotones = $BloqueoBotones
@export var pausaManager:Node
@export var AUDIONode:Node
@export var GameplayNode:Node2D

@export var timer:Timer
@export var duracionAlarmaSonando:float = 4

func _ready() -> void:
	visualsNode._transicion_terminada.connect(terminaLaPartida)
	canvasBloqueaBotones.hide()
	timer.timeout.connect(terminaTimer)

func terminaLaPartida():
	print("(FIN PARTIDFA MANAGER) terminal apa partidaaaaa ---------------")
	pausaManager.reanudarGameplay()
	canvasBloqueaBotones.show()
	camaraNode.reiniciar_camara()
	logicaJugableNode.pausarCicloGameplay()
	AUDIONode.pausarSonidos()
	GameplayNode.BotonToLaptop.hide()
	GameplayNode.BotonToCelular.hide()
	timer.start(duracionAlarmaSonando)

func terminaTimer():
	GameManager.CAMBIAR_DE_ESCENA(GameManager.ENUMESCENAS.TEST1)
	pass
