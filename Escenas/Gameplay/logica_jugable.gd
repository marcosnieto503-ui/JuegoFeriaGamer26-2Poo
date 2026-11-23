extends Node

@onready var timer = $TimerNotis

@export var NOTIS_MANUAL :bool = true
@export var ciclosDeTiempo :float
##Si el valor aleatorio elegido del 1 al 10 es menor o igual a este valor, se considera true
@export var probabilidad :float

@onready var cajaNotif = $"../Celular/ScrollNotificaciones/CajaNotificaciones"

@onready var logicaComments = $logicaJugableComentarios

func _ready() -> void:
	if NOTIS_MANUAL:
		print("---MODO DEBUG NOTIS NO LLEGASN EN AUTOMATICO")
		return
	#iniciarTimer()


func iniciarCicloGameplay():
	iniciarTimer()
	logicaComments.iniciarTimer()
	await  get_tree().create_timer(1).timeout
	ingresarNotiRandom()
func terminarCicloGameplay():
	timer.stop()
	logicaComments.timer.stop()

func pausarCicloGameplay():
	if timer.is_paused():
		return
	timer.set_paused(true)
	if logicaComments.timer.is_paused():
		return
	logicaComments.timer.set_paused(true)
	print("Logica_jugable) timer pausado")
func reanudarCicloGameplay():
	if !timer.is_paused():
		return
	timer.set_paused(false)
	if !logicaComments.timer.is_paused():
		return
	logicaComments.timer.set_paused(false)
	print("Logica_jugable) timer reanudado")


func iniciarTimer():
	timer.start(ciclosDeTiempo)

func _on_timer_timeout() -> void:
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
