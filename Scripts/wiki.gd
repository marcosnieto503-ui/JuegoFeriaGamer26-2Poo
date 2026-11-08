extends PanelContainer

@onready var cajaTitulo = $Control/Titulo
@onready var cajaCuerpo = $Control/Cuerpo

var ARTICULO_ASIGNADO :Articulo

func _ready() -> void:
	pass

func inicializar(articulo : Articulo):
	ARTICULO_ASIGNADO = articulo
	
	cajaTitulo.set_text(ARTICULO_ASIGNADO.get_titular())
	cajaCuerpo.set_text(ARTICULO_ASIGNADO.get_texto())


func _on_boton_cerrar_button_up() -> void:
	queue_free()
	Utils.ARTICULO_ACTIVO = false
	print("-----ARTICULO CERRADO")
