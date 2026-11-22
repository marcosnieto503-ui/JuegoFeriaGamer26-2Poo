extends Node

var GameplayScene = preload("res://Escenas/Gameplay/gameplay.tscn")


var ACTUAl_SCENE:Node


enum ENUMESCENAS {
	GAMEPLAY,
	MAINMENU,
	CHARACTERCREATION,
	GAMEFINALRESULTS
}

var Dict_SCENES:Dictionary[ENUMESCENAS,PackedScene] = {
	ENUMESCENAS.GAMEPLAY:GameplayScene
}


func _ready() -> void:
	pass
