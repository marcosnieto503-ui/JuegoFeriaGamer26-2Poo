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
	toLaptop()
	BotonToLaptop.hide()
	#fondo.frame = noFocus
	#pantalla.hide()
	Utils.leer_archivo_publi()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var pos_mundo = get_global_mouse_position()
	#print(pos_mundo.x - 960, " , ", pos_mundo.y - 540) #coords en relacion a la camara(esta desfasada su origen es el centro)
	if (Input.is_action_just_pressed("espacio")): #-------------------debug
		ingresarNotiRandom()
		print("pressed op")
		
		print("-----------####")
		for publi in Utils.PUBLICACIONES:
			
			print(publi.get_accion())
		print("-----------####")
		
	
func ingresarNotiRandom(): #fuap funcion pa meter notificacion a el telefono
	var notif = NOTIFICACION.instantiate()
	var publi_a_asignar = Utils.PUBLICACIONES.pick_random()
	#var publi_a_asignar = Utils.PUBLICACIONES[0]
	cajaNotif.add_child(notif)
	print(notif.size)
	notif.asignarPubli(publi_a_asignar)
	
	
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
	if (fondo.frame == noFocus):
		fondo.frame = celularOnly
		pantalla.show()
		await camara.reiniciar_camara()
		camara.zoom_hacia(Vector2(900,200), 2) #coords en relacion a la camara si ests tuviera origfen en su centro
	else: 
		fondo.frame = celularFocus
		pantalla.show()
		await camara.reiniciar_camara()
		camara.zoom_hacia(Vector2(900,200), 2) #coords en relacion a la camara si ests tuviera origen en su centro
	#720, 420
func toLaptop():
	fondo.frame = laptopFocus
	pantalla.hide()
	await camara.reiniciar_camara()
	camara.zoom_hacia(Vector2(920-(1920/2), 430-(1080/2)), 1.2, 0.3)
	
