extends Node


enum OPCIONES_NOTI_RECIBIDA{
	VIBRACION,
	SONIDO1
}
var effects_notis = {
	OPCIONES_NOTI_RECIBIDA.VIBRACION:"noti_recibida2",
	OPCIONES_NOTI_RECIBIDA.SONIDO1:"noti_recibida"
}
@export var Efecto_de_noti_recibida : OPCIONES_NOTI_RECIBIDA 

@onready var listener = $"../AudioListener2D"
const posLaptop = Vector2(730,430)
const posTel = Vector2(1560,510)

var SAMPLES :Dictionary[String,AudioStreamPlayer2D]

func _ready() -> void:
	for child in get_children():
		SAMPLES.set(child.name,child)
	
	Utils._publi_ingresada.connect(_publi_asignada_en_laptop)
	DEBUG_seleccion_sonidoNoti() #DEBUG duiaov
	pass

func _publi_asignada_en_laptop():
	playSampleRPitch("noti_recibida")

func _on_logica_jugable__noti_recibida() -> void:
	playNotiRecibida()

func _player_movido_hacia_telefono():
	listener.set_position(Vector2(posTel))
func _player_movido_hacia_laptop():
	listener.set_position(Vector2(posLaptop))

func playNotiRecibida():
	var sonidoStr = effects_notis.get(Efecto_de_noti_recibida)
	if !SAMPLES.has(sonidoStr):
		push_error("Sample de audio no encontrado: ", sonidoStr)
		return
	var sampl = SAMPLES.get(sonidoStr)
	sampl.set_pitch_scale(1.15 + randf_range(-0.2,0.2))
	print("PITCH PILLAO: ",sampl.get_pitch_scale())
	if Efecto_de_noti_recibida == OPCIONES_NOTI_RECIBIDA.VIBRACION:
		sampl.play()
		await sampl.finished
		sampl.play()
		return
	
	sampl.play()


func playSampleRPitch(sample:String):
	if !SAMPLES.has(sample):
		push_error("Sample de audio no encontrado: ", sample)
		return
	var sampl = SAMPLES.get(sample)
	sampl.set_pitch_scale(1.15 + randf_range(-0.2,0.2))
	print("PITCH PILLAO: ",sampl.get_pitch_scale())
	sampl.play()

#-------------------------------------------------
#---- TODO LO QUE ESTE DEBAJO DE ESTO ES DEBUG
#----------------------------------------------

func DEBUG_seleccion_sonidoNoti():
	match Efecto_de_noti_recibida:
		OPCIONES_NOTI_RECIBIDA.VIBRACION:
			sonidoAReproducir = "noti_recibida2"
		OPCIONES_NOTI_RECIBIDA.SONIDO1:
			sonidoAReproducir = "noti_recibida"

var sonidoAReproducir:String = ""

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("espacio"):
		playNotiRecibida()
