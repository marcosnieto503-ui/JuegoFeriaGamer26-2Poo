extends Node

@onready var timer = $TimerNotis

@export var NOTIS_MANUAL :bool = true
@export var ciclosDeTiempo :float
##Si el valor aleatorio elegido del 1 al 10 es menor o igual a este valor, se considera true
@export var probabilidad :float

@onready var cajaNotif = $"../Celular/ScrollNotificaciones/CajaNotificaciones"

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
		#print("SALE NOTI")
		ingresarNotiRandom()
	else:
		#print("NO SALE NOTI")
		pass

func ingresarNotiRandom():
	ControlNotificaciones.ingresar_notificacion_random()


func _unhandled_input(event: InputEvent) -> void:
	if !NOTIS_MANUAL:
		return
	if event.is_action_pressed("espacio"):
		ingresarNotiRandom()
