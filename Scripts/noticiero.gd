extends PanelContainer


@onready var cajaCategoria = $Control/TipoNoticia
@onready var cajaTitular = $Control/Titular
@onready var cajaCuerpo = $Control/Cuerpo
@onready var cajaTextura = $Control/Imagen

var ARTICULO_ASIGNADO : Articulo

func _ready() -> void:
	pass

func inicializar(articulo : Articulo):
	ARTICULO_ASIGNADO = articulo
	
	cajaCategoria.text = ARTICULO_ASIGNADO.get_categoria()
	cajaTitular.set_text(ARTICULO_ASIGNADO.get_titular())
	cajaCuerpo.set_text(ARTICULO_ASIGNADO.get_texto())
	cajaTextura.texture = ARTICULO_ASIGNADO.get_img()


func _on_boton_cerrar_button_up() -> void:
	queue_free()
	Utils.ARTICULO_ACTIVO = false
	print("-----NOTICIA CERRADA")
