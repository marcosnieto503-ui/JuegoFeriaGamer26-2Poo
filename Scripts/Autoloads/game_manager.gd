extends Node

var GameplayScene = preload("res://Escenas/Gameplay/gameplay.tscn")
var testScene = preload("res://Escenas/test1.tscn")

var Scene_Manager:Node

enum ENUMESCENAS {
	GAMEPLAY,
	MAINMENU,
	CHARACTERCREATION,
	GAMEFINALRESULTS,
	ENTRARALJUEGO,
	INTRODUCCION,
	COMOJUGAR,
	MENUCREDITOS,
	SELECCIONPERSONAJE,
	TEST1
}


func CAMBIAR_DE_ESCENA(nextScene:GameManager.ENUMESCENAS,fundido:bool = false):
	if !Scene_Manager:
		push_error("No hay scene manager po")
		return
	Scene_Manager.SWITCH_SCENE(nextScene,fundido)
