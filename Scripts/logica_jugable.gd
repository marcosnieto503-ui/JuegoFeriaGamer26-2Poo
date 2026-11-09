extends Node

@onready var timer = $Timer

@export var NOTIS_MANUAL :bool = true
@export var ciclosDeTiempo :float
@export var probabilidad :float

@onready var cajaNotif = $"../Celular/ScrollNotificaciones/CajaNotificaciones"
const NOTIFICACION = preload("res://Escenas/notificacion.tscn")

signal _noti_recibida

func _ready() -> void:
	if NOTIS_MANUAL:
		print("---MODO DEBUG NOTIS NO LLEGASN EN AUTOMATICO")
		return
	iniciarTimer()

func iniciarTimer():
	timer.start(ciclosDeTiempo)

func _on_timer_timeout() -> void:
	#prints("CICLO HECHO")
	saleNoti()
	iniciarTimer()

func saleNoti():
	if randf_range(0,10) <= probabilidad:
		print("SALE NOTI")
		ingresarNotiRandom()
	else:
		print("NO SALE NOTI")

func ingresarNotiRandom():
	var notif = NOTIFICACION.instantiate()
	var publi_a_asignar = Utils.PUBLICACIONES.get(Utils.PUBLICACIONES.keys().pick_random())
	if publi_a_asignar == null:
		push_error("No hay mas publicaciones para mostrar, array vacio mostro.")
		return
	Utils.excluiurPublicacion(publi_a_asignar)
	cajaNotif.add_child(notif)
	notif.asignarPubli(publi_a_asignar)
	GlobalEfectos.efectoNotiRecibida(Vector2(1360,640),2)
	_noti_recibida.emit()
	print("NOTIFICACION ALEATORIA INGRESADA")


func _unhandled_input(event: InputEvent) -> void:
	if !NOTIS_MANUAL:
		return
	if event.is_action_pressed("espacio"):
		ingresarNotiRandom()
