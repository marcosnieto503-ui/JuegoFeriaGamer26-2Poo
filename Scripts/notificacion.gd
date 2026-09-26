extends PanelContainer

@onready var nodoTexto = $Container/TextoNotificacion


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func asignarTextoNoti(notiText:String):
	nodoTexto.set_text(notiText)

func _on_aceptar_button_up() -> void:
	
	#esto es una prubeita
	#
	#Utils.leer_archivo_publi(Utils.rutaPublis)
	#for publi in Utils.publis:
		#print("testo comm: ", publi.textoNoti)
		#print("texto pubnlic: ", publi.dataPubli)
	#
	#aqui termina el codigo ed la pruebota
	
	_eliminar()

func _on_rechazar_button_up() -> void:
	_eliminar()

func _eliminar():
	var tween = create_tween()
	
	tween.tween_property(self, "position:x", self.position.x + 20, 0.3)
	
	tween.set_parallel(true)
	
	tween.tween_property(self, "position:x", self.position.x - 300, 0.4)
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	await tween.finished
	queue_free()
