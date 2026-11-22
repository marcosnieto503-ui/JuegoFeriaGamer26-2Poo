extends Node

var GameplayScene = preload("res://Escenas/Gameplay/gameplay.tscn")



func _ready() -> void:
	pass

@export var gameplayTest:Node
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("espacio"):
		print(gameplayTest)
		gameplayTest.INICIALIZAR_ESCENA()

func SWITCH_SCENE(nextScene:GameManager.ENUMESCENAS):
	fundido_negro()

func fundido_negro():
	pass
