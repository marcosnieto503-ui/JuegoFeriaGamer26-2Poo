extends Button


@onready var tabs = $"../Laptop/Pestañas"
@onready var testEscena = preload("res://Escenas/ventana_publicacion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var contador = 1 # a reeemplazar despue sioiioo------------------------

func _on_button_down() -> void:
	if contador > 3: #a reemplaazr despues -----------------------
		return
		
	var instancia = testEscena.instantiate()
	instancia.name = "Publicacion "+ str(contador)
	contador += 1
	
	tabs.add_child(instancia)
	
	instancia.inicializar(Utils.PUBLICACIONES.pick_random())
	
