extends Node2D

@onready var BotonToLaptop = $"Celular/ToLaptop"
@onready var BotonToCelular = $"Laptop/ToCelular"
@onready var pantalla = $"Celular/ScrollNotificaciones"

@onready var C_Laptop = $"Laptop"
@onready var C_Celular = $"Celular"

@onready var camara = $"Camara"

@export var Gameplay_Visuals:AnimatedSprite2D 
#este nodo se encarga de todo lo relacionado a los sprites del gameplay
@export var logicaJugable:Node
##Duracion de la partida en segundos
@export var DURACION_DE_LA_PARTIDA:float = 120

var SceneID = GameManager.ENUMESCENAS.GAMEPLAY

enum { #estados de la imagen del gameplay
	noFocus,
	laptopFocus,
	celularFocus,
	celularOnly
}

@onready var cajaNotif = $"Celular/ScrollNotificaciones/CajaNotificaciones"
const NOTIFICACION = preload("res://Escenas/NotificacionScene/notificacion.tscn")


signal _movido_hacia_telefono
signal _movido_hacia_laptop
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BotonToLaptop.hide()
	BotonToCelular.hide()

var ESCENA_CORRIENDO:bool = false

func INICIALIZAR_ESCENA():
	#empieza gameplay
	if ESCENA_CORRIENDO:
		return
	await leer_recursos_txt()
	BotonToCelular.show()
	Gameplay_Visuals.iniciar_transicion_atardecer(DURACION_DE_LA_PARTIDA)
	GlobalAudioSignals.play_musica_fondo()
	logicaJugable.iniciarCicloGameplay()
	toLaptop()
	ESCENA_CORRIENDO = true

@export var recursosTxtManager:Node
func leer_recursos_txt():
	recursosTxtManager.leer_recursos_txt()

func SALIR_DE_ESCENA():
	pass
	print("(GAMEPLAY) saliendo de escena/.......")
	Utils.PUBLICACIONES.clear()
	Utils.ARTICULO_ACTIVO = false
	Utils.PUBLIS_EXCLUIDAS.clear()
	for v in Utils.TabIndexes.values():
		v = false
	DataPartida.PUBLIS_DESCARTADAS.clear()
	DataPartida.PUBLIS_PUBLICADAS.clear()
	DataPartida.PUBLIS_PARA_COMENTARIOS.clear()
	ControlArticulos.ARTICULOS.clear()
	
	print("\nGAMEPLAR PUNTIAUCION:m  , PUBLIS CORRECTAS: ",len(ProgresoPuntuacion.PUBLIS_CORRECTAS))
	print("PUBLIS INCORRECTAS: ",len(ProgresoPuntuacion.PUBLIS_INCORRECTAS))
	print("COMENTARIOS RESPIONDIDOD: ", len(ProgresoPuntuacion.COMENTARIOS_CORRECTOS),"\n")


func DEBUGreaccionPlayer(pos:Vector2 = Vector2.ZERO):
	if !pos:
		$EscenaReacciones.displayPlayerReaccion()
		return
	$EscenaReacciones.displayPlayerReaccion(pos)


func DEBUGingresarNotiRandom(): #fuap funcion pa meter notificacion a el telefono
	var notif = NOTIFICACION.instantiate()
	var publi_a_asignar = Utils.PUBLICACIONES[12]
	cajaNotif.add_child(notif)
	notif.asignarPubli(publi_a_asignar)
	GlobalEfectos.efectoNotiRecibida(Vector2(1360,640),2)
	
	
func _ToCelular_Pressed() -> void:
	#print("I celular: ", C_Celular.get_index()) # debug
	#print("I laptop: ", C_Laptop.get_index())  # degub
	#print("switch") 			 # debuig
	
	switchFocus()
	
	#print("I celular despue: ", C_Celular.get_index()) # debug
	#print("I laptop despue: ", C_Laptop.get_index())  # degub

func _ToLaptop_Pressed() -> void:
	#print("I celular: ", C_Celular.get_index()) # debug
	#print("I laptop: ", C_Laptop.get_index())  # degub
	#print("switch") 			 # debuig
	
	switchFocus()
	
	#print("I celular despue: ", C_Celular.get_index()) # debug
	#print("I laptop despue: ", C_Laptop.get_index())  # degub

func switchFocus():
	if (C_Laptop.get_index() > C_Celular.get_index()):
		move_child(C_Laptop, C_Laptop.get_index() - 1)
		BotonToCelular.hide();
		BotonToLaptop.show()
		toCelular()
	else:
		move_child(C_Celular, C_Celular.get_index() - 1)
		BotonToCelular.show();
		BotonToLaptop.hide()
		toLaptop()
		
func toCelular():
	Gameplay_Visuals.select_frame_telefono_arriba()
	pantalla.show()
	await camara.reiniciar_camara()
	camara.zoom_hacia(Vector2(900,200), 2) #coords en relacion a la camara si ests tuviera origen en su centro
	_movido_hacia_telefono.emit()
	#720, 420
func toLaptop():
	Gameplay_Visuals.select_frame_telefono_abajo()
	pantalla.hide()
	await camara.reiniciar_camara()
	camara.zoom_hacia(Vector2(920-(1920/2), 430-(1080/2)), 1.2, 0.3)
	_movido_hacia_laptop.emit()


func _on_pestañas_tab_clicked(tab:int) -> void:
	GlobalAudioSignals.playTabSwitch()
