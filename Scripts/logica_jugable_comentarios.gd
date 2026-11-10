extends Node


@onready var ControlComentarios = $"../../Utils/ControlComentarios"
@onready var timer = $TimerComments

@export var ciclotTiempoComments:float = 5
##Si el valor aleatorio elegido del 1 al 10 es menor o igual a este valor, se considera true
@export_range(1,10) var probabilidadComment:float = 4


func _ready() -> void:
	iniciarTimer()


func iniciarTimer():
	timer.start(ciclotTiempoComments)
	print("(logicA comments) CCORRE TIMER")

func _on_timer_comments_timeout() -> void:
	saleComment()
	iniciarTimer()

func saleComment():
	if !randf_range(1,10) <= probabilidadComment:
		print("(Logica_jugable_comentarios) NO HUBO SUERTE, COMENTARio no INgreSADO")
		return
	var c = ControlComentarios._ingresar_comentario_random()
	if !c:
		return
	ControlComentarios.ingresar_comentario(c)
	print("(Logica_jugable_comentarios) COMENTARio INgreSADO")
