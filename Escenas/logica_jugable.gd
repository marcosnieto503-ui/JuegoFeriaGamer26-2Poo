extends Node

@onready var timer = $Timer

@export var ciclosDeTiempo :float
@export var probabilidad :float

func _ready() -> void:
	iniciarTimer()
	pass

func iniciarTimer():
	timer.start(ciclosDeTiempo)

func _on_timer_timeout() -> void:
	print("CICLO HECHO")
	saleNoti()
	iniciarTimer()

func saleNoti():
	if randf_range(0,10) <= probabilidad:
		print("SALE NOTI")
		ingresarNotiRandom()
	else:
		print("NO SALE NOTI")

func ingresarNotiRandom():
	pass
