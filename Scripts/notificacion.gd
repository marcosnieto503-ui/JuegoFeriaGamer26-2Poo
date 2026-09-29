extends PanelContainer

@onready var nodoTexto = $VBoxContainer/Texto
@onready var boton = $"VBoxContainer/Boton Aceptar Noti"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func asignarTextoNoti(notiText:String):
	nodoTexto.set_text(notiText)

func _on_boton_aceptar_noti_button_down() -> void:
	print(Utils.aceptaNotiEnProceso)
	print(Utils.noti_es_presionable())
	if not Utils.noti_es_presionable():
		print("este no se va a eliminar")
		return
	else:
		_procesarNoti()
		
func desactivarBoton():
	boton.set_disabled(true)
func activarBoton():
	boton.set_disabled(false)

#tesxtear esta mrd q hay un bug bien raro//////////////fdthnsedrgsefgawsefasdgvsdgvsedfgsegf
func _procesarNoti():
	Utils.desactivar_press_notis()
	var tween = create_tween()
	
	tween.tween_property(self, "position:x", self.position.x - 300, 0.5)\
		.set_trans(Tween.TRANS_BACK)
		
	await tween.finished
	queue_free()
	Utils.activar_press_notis() 
