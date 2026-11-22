extends Node


@export var GameplayNode:Node2D
@export var visualsNode:Node
@export var logicaJugableNode:Node
@export var AUDIONode:Node
@export var efectoNotiRecibidaNode:Node
@export var camaraNode:Camera2D
@export var pantallaPausa:CanvasLayer


var gameplayPausado:bool = false

func _ready() -> void:
	pantallaPausa.hide()


func _input(event: InputEvent) -> void:
	if !GameplayNode.ESCENA_CORRIENDO:
		return
	if event.is_action_pressed("_Escape"):
		if !gameplayPausado:
			pausarGameplay()
		else:
			reanudarGameplay()


func pausarGameplay():
	if gameplayPausado:
		return
	gameplayPausado = true
	logicaJugableNode.pausarCicloGameplay()
	visualsNode.pausarTransicion()
	AUDIONode.pausarSonidos()
	efectoNotiRecibidaNode.pausarEfecto()
	camaraNode.pausarCamara()
	pantallaPausa.show()

func reanudarGameplay():
	if !gameplayPausado:
		return
	logicaJugableNode.reanudarCicloGameplay()
	visualsNode.reanudarTransicion()
	AUDIONode.reanudarSonidos()
	efectoNotiRecibidaNode.reanudarEfecto()
	camaraNode.reanudarCamara()
	pantallaPausa.hide()
	gameplayPausado = false
