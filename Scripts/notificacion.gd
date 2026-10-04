extends PanelContainer

@onready var nodoTexto = $VBoxContainer/Texto
@onready var boton = $"VBoxContainer/Boton Aceptar Noti"
var PubliAsignada : Publicacion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_boton_aceptar_noti_button_down() -> void:
	if Utils.contador > 3:
		return
	_procesarNoti()
	
func desactivarBoton():
	boton.set_disabled(true)
func activarBoton():
	boton.set_disabled(false)

func asignarPubli(publi : Publicacion):
	PubliAsignada = publi
	nodoTexto.set_text(publi.get_textoNoti())
	
	
func _procesarNoti():
	print("NOTIFICACION ACEPTADA")
	Utils.desactivar_press_notis() ##------------
	var tween = create_tween()
	
	tween.tween_property(self, "position:x", self.position.x - 300, 0.5)\
		.set_trans(Tween.TRANS_BACK)
		
	await tween.finished
	queue_free()
	Utils.ingresarPublicacion(PubliAsignada)
	Utils.activar_press_notis()  ##---------------
	
