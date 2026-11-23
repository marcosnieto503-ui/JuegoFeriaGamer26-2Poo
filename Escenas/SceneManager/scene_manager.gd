extends Node

var GameplayScene:PackedScene = preload("res://Escenas/Gameplay/gameplay.tscn")
var testScene:PackedScene = preload("res://Escenas/test1.tscn")

var menuPrincipalScene:PackedScene = preload("res://MENUS/Escenas/Menu/Menu.tscn")
var entrarAlJuegoScene:PackedScene = preload("res://MENUS/Escenas/Intro.tscn")
var menuCreditosScene:PackedScene = preload("res://MENUS/Escenas/Menu/Creditos/Creditos.tscn")
var introduccionScene:PackedScene  = preload("res://MENUS/Escenas/selPersonaje/introduccion.tscn")
var menuComoJugarScene:PackedScene = preload("res://MENUS/Escenas/Menu/ComoJugar/Controles.tscn")
var seleccionPersonajeScene:PackedScene = preload("res://MENUS/Escenas/selPersonaje/seleccion_personaje.tscn")
var pantallaResultadosScene:PackedScene = preload("res://MENUS/Escenas/Final/Final.tscn")
 
var Dict_SCENES:Dictionary[GameManager.ENUMESCENAS,PackedScene] = {
	GameManager.ENUMESCENAS.GAMEPLAY:GameplayScene,
	GameManager.ENUMESCENAS.TEST1:testScene,
	GameManager.ENUMESCENAS.MAINMENU:menuPrincipalScene,
	GameManager.ENUMESCENAS.ENTRARALJUEGO:entrarAlJuegoScene,
	GameManager.ENUMESCENAS.INTRODUCCION:introduccionScene,
	GameManager.ENUMESCENAS.COMOJUGAR:menuComoJugarScene,
	GameManager.ENUMESCENAS.MENUCREDITOS:menuCreditosScene,
	GameManager.ENUMESCENAS.SELECCIONPERSONAJE:seleccionPersonajeScene,
	GameManager.ENUMESCENAS.GAMEFINALRESULTS:pantallaResultadosScene
	}


@export var pantallaNegra:ColorRect
@export var duracionFundidoANegro:float = 4
@export var EscenaInicial:GameManager.ENUMESCENAS


var ACTUAl_SCENE:Node


func _ready() -> void:
	GameManager.Scene_Manager = self
	
	duracionDesfundidoLocal = duracionFundidoANegro
	if Dict_SCENES.has(EscenaInicial):
		cargarEscenaDirecto(Dict_SCENES.get(EscenaInicial))
	else:
		push_error("(SCENE MANAGER) la escena seleccionada no existe : ", EscenaInicial)

func cargarEscenaDirecto(packedScene:PackedScene):
	ACTUAl_SCENE = packedScene.instantiate()
	add_child(ACTUAl_SCENE)
	if not ACTUAl_SCENE.is_node_ready():
		await ACTUAl_SCENE.ready
	if ACTUAl_SCENE.has_method("INICIALIZAR_ESCENA"):
		await ACTUAl_SCENE.INICIALIZAR_ESCENA()
	print("Escen manager ACTUAK SCENE: ",ACTUAl_SCENE)

func getEscenaActual() -> Node:
	return ACTUAl_SCENE



var _cambiando := false
func SWITCH_SCENE(nextScene:GameManager.ENUMESCENAS,duracionFundido:float =duracionFundidoANegro): #fundido no hace naodraaaaaa hace que fundoine
	if _cambiando:
		return    # evita dos cambios a la vez
	if !Dict_SCENES.has(nextScene):
		push_error("(SCENE MANAEGR) NO EXISTE LA ESCENA CORERSPONDIENTE A: %" % nextScene)
		return
	_cambiando = true
	fundido_negro(duracionFundido)
	await tweenFundido.finished
	
	if is_instance_valid(ACTUAl_SCENE):
		if ACTUAl_SCENE.has_method("SALIR_DE_ESCENA"):
			await ACTUAl_SCENE.SALIR_DE_ESCENA()
		remove_child(ACTUAl_SCENE)    # sale del árbol ya, sin esperar
		ACTUAl_SCENE.queue_free()     # se libera al final del frame
	ACTUAl_SCENE = Dict_SCENES[nextScene].instantiate()
	add_child(ACTUAl_SCENE)
	if not ACTUAl_SCENE.is_node_ready():
		await ACTUAl_SCENE.ready
	
	if ACTUAl_SCENE.has_method("INICIALIZAR_ESCENA"):
		await ACTUAl_SCENE.INICIALIZAR_ESCENA()
	
	desfundido_negro()
	await tweenDesfundido.finished
	_cambiando = false



var duracionDesfundidoLocal:float

var tweenFundido:Tween
func fundido_negro(time:float):
	duracionDesfundidoLocal = time
	pantallaNegra.color.a = 0
	pantallaNegra.show()
	
	if tweenFundido:
		tweenFundido.kill()
	tweenFundido = create_tween()
	tweenFundido.finished.connect(fundidoCompleto)
	tweenFundido.tween_property(pantallaNegra,"color:a",1,time)

func fundidoCompleto():
	print("(SCENe manager) fundido cokmpoleto wiiiiii-")

var tweenDesfundido:Tween
func desfundido_negro():
	pantallaNegra.color.a = 1
	pantallaNegra.show()
	
	if tweenDesfundido:
		tweenDesfundido.kill()
	tweenDesfundido = create_tween()
	tweenDesfundido.finished.connect(desfundidoCompleto)
	await tweenDesfundido.tween_property(pantallaNegra,"color:a",0,duracionDesfundidoLocal)

func desfundidoCompleto():
	pantallaNegra.hide()
	print("(SCENE MANAGER) Dedfundidp compolemto siuuu asdasd")
