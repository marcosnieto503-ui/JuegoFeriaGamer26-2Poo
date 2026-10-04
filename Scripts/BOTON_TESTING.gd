extends Button


@onready var tabs = $"../Laptop/Pestañas"
@onready var testEscena = preload("res://Escenas/ventana_publicacion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_button_down() -> void:
	Utils.ingresarPublicacion(Utils.PUBLICACIONES.pick_random())
	
