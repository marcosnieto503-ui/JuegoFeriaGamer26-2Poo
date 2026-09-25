extends Node2D

@onready var BotonToLaptop = $"Celular/ToLaptop"
@onready var BotonToCelular = $"Laptop/ToCelular"
@onready var pantalla = $"Celular/ScrollNotificaciones"

@onready var C_Laptop = $"Laptop"
@onready var C_Celular = $"Celular"

@onready var fondo = $"Visual"
@onready var camara = $"Camara"

enum { #estados de la imagen del gameplay
	noFocus,
	laptopFocus,
	celularFocus,
	celularOnly
}

@onready var cajaNotif = $"Celular/ScrollNotificaciones/CajaNotificaciones"
const NOTIFICACION = preload("res://Escenas/notificacion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fondo.frame = noFocus
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var pos_mundo = get_global_mouse_position()
	#print(pos_mundo.x - 960, " , ", pos_mundo.y - 540) #coords en relacion a la camara(esta desfasada su origen es el centro)
	
	if (Input.is_action_just_pressed("espacio")):
		var notif = NOTIFICACION.instantiate()
		notif.size_flags_horizontal = Control.SIZE_EXPAND_FILL 
		cajaNotif.add_child(notif)
		print("pressed op")
	

func ToLaptop():
	pass
	
func _ToCelular_Pressed() -> void:
	print("I celular: ", C_Celular.get_index()) # debug
	print("I laptop: ", C_Laptop.get_index())  # degub
	print("switch") 			 # debuig
	
	switchFocus()
	
	print("I celular despue: ", C_Celular.get_index()) # debug
	print("I laptop despue: ", C_Laptop.get_index())  # degub

func _ToLaptop_Pressed() -> void:
	print("I celular: ", C_Celular.get_index()) # debug
	print("I laptop: ", C_Laptop.get_index())  # degub
	print("switch") 			 # debuig
	
	switchFocus()
	
	print("I celular despue: ", C_Celular.get_index()) # debug
	print("I laptop despue: ", C_Laptop.get_index())  # degub

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
	if (fondo.frame == noFocus):
		fondo.frame = celularOnly
		pantalla.show()
		zoom_hacia(Vector2(900,200), 2) #coords en relacion a la camara si ests tuviera origfen en su centro
	else:
		fondo.frame = celularFocus
		pantalla.show()
		zoom_hacia(Vector2(900,200), 2) #coords en relacion a la camara si ests tuviera origen en su centro
	
func toLaptop():
	fondo.frame = laptopFocus
	pantalla.hide()
	reiniciar_camara()
	
var tween_actual: Tween

func zoom_hacia(posicion_objetivo: Vector2, nivel_zoom: float, duracion: float = 0.3):
	if tween_actual:
		tween_actual.kill()
	
	var zoom_clampeado = clamp(nivel_zoom, 0.3, 1.7)
	
	tween_actual = create_tween()
	tween_actual.set_parallel(true)
	tween_actual.tween_property(camara, "global_position", posicion_objetivo, duracion).set_trans(Tween.TRANS_LINEAR)
	tween_actual.tween_property(camara, "zoom", Vector2(zoom_clampeado, zoom_clampeado), duracion).set_trans(Tween.TRANS_LINEAR)

func reiniciar_camara(duracion: float = 0.3):
	if tween_actual:
		tween_actual.kill()
	
	tween_actual = create_tween()
	tween_actual.set_parallel(true)
	tween_actual.tween_property(camara, "global_position", Vector2.ZERO, duracion).set_trans(Tween.TRANS_LINEAR)
	tween_actual.tween_property(camara, "zoom", Vector2.ONE, duracion).set_trans(Tween.TRANS_LINEAR)
