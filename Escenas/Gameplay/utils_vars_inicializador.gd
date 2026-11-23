extends Node


@onready var cajaNotificacionesNode =  $"../Celular/ScrollNotificaciones/CajaNotificaciones"
@onready var tabsContainerNode = $"../Laptop/Pestañas"
@onready var reaccionesSceneNode = $"../EscenaReacciones"
@onready var audioNode = $"../AUDIO"

func _ready() -> void:
	Utils.cajaNotis = cajaNotificacionesNode
	Utils.tabsContainer = tabsContainerNode
	DataPartida.reacciones = reaccionesSceneNode
	ControlNotificaciones.cajaNotif = cajaNotificacionesNode
	GlobalAudioSignals.AUDIO = audioNode
	print("AUDIO asignado: ", audioNode, " -> ", GlobalAudioSignals.AUDIO)
