extends Node

var GameplayScene = preload("res://Escenas/Gameplay/gameplay.tscn")
var testScene = preload("res://Escenas/test1.tscn")

var Scene_Manager:Node



enum ENUMESCENAS {
	GAMEPLAY,
	MAINMENU,
	CHARACTERCREATION,
	GAMEFINALRESULTS,
	TEST1
}



func CAMBIAR_DE_ESCENA(nextScene:GameManager.ENUMESCENAS):
	Scene_Manager.SWITCH_SCENE(nextScene)
