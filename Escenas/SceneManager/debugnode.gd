extends Node


@export_category("FUNCIONES DEBUG SWITCH")
@export var funcionesTeclasActivadas:bool = false

@export var sceneManager:Node

@export_category("DALTONISMO FILTRO")
@export var filtroAaplicar:GameSettings.ENUM_FILTROS_DALTONISMO
func _ready() -> void:
	pass


#debuyggg --------------
@export var posReaccionPlayer:Vector2 = Vector2(100,100)
func _input(event: InputEvent) -> void:
	if !funcionesTeclasActivadas:
		return
	if event.is_action_pressed("espacio"):
		
		print("(DEGUG BNODE)",sceneManager.getEscenaActual())
		var gameplay = sceneManager.getEscenaActual()
		gameplay.DEBUGreaccionPlayer()
	
	if event.is_action_pressed("ui_left"):
		#act=iva y descativa el filtro elegido en el einspector
		if GameSettings.filtro_activo:
			GameSettings.AsignarFiltroDaltonismo(GameSettings.ENUM_FILTROS_DALTONISMO.DESACTIVADO)
		else:
			GameSettings.AsignarFiltroDaltonismo(filtroAaplicar)
		print("DEBUG NODE FILTRO APLICADO")
