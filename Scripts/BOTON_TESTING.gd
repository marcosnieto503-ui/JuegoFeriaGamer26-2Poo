extends Button


@onready var tabs = $"../Laptop/Pestañas"
@onready var testEscena = preload("res://Escenas/ventana_publicacion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_button_down() -> void:
	if Utils.PUBLICACIONES.has(11):
		Utils.ingresarPublicacion(Utils.PUBLICACIONES.get(11))
	
	return
	print("cantidfad articulos: ",len(Utils.ARTICULOS))
	var ar = Utils.ARTICULOS.get(0)
	print(ar.get_nombre())
	print(ar.get_tipo())
	print(ar.get_id())
	print(ar.get_categoria())
	print("TITULAR: ",ar.get_titular())
	print("")
	print("TEXTO: ",ar.get_texto())
	print(ar._img)
