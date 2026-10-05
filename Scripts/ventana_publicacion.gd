extends PanelContainer

@onready var cajaTextoPubli = $Control/TextoPublicacion
@onready var recursoMultimedia = $Control/RecursoMultimedia
@onready var labelTipoPubli = $Control/LabelTipoPubli


var PUBLICACION_ASIGNADA : Publicacion = null
var recurso : Texture2D = null

const pos_CON_IMAGEN =Vector2(275,35)
const pos_SIN_IMAGEN =Vector2(60,35)

const size_CON_IMAGEN = Vector2(445,180)
const size_SIN_IMAGEN = Vector2(660,180)


@onready var botonInapropiado = $ControlOpsDescartar/OpcionesDescartar/HBoxContainer/VBoxContainer2/Inapropiado
@onready var botonFormatoInvalido = $ControlOpsDescartar/OpcionesDescartar/HBoxContainer/VBoxContainer2/FormatoInvalido
@onready var botonPubliNoRelacionada = $ControlOpsDescartar/OpcionesDescartar/HBoxContainer/VBoxContainer3/PubliNoRelacionada
@onready var botonLenguajeNoProfesional = $ControlOpsDescartar/OpcionesDescartar/HBoxContainer/VBoxContainer3/LenguajeNoProfesional
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#botones del menu que aparece al descartar
	$ControlOpsDescartar.set_visible(false)
	botonInapropiado.pressed.connect(algunBotonDescartar_Pressed.bind("inapropiado"))
	botonFormatoInvalido.button_up.connect(algunBotonDescartar_Pressed.bind("formato"))
	botonPubliNoRelacionada.button_up.connect(algunBotonDescartar_Pressed.bind("no relacionada"))
	botonLenguajeNoProfesional.button_up.connect(algunBotonDescartar_Pressed.bind("lenguaje"))


func inicializar(publi : Publicacion):
	PUBLICACION_ASIGNADA = publi
	
	#recurso = load(Utils.RUTAS_RECURSOS[PUBLICACION_ASIGNADA.get_id()])
	print(Utils.RUTAS_RECURSOS[PUBLICACION_ASIGNADA.get_id()])
	
	cajaTextoPubli.set_text(PUBLICACION_ASIGNADA.get_textoPubli())
	labelTipoPubli.set_text("Tipo de Publicacion: " + PUBLICACION_ASIGNADA.get_tipo())
	asignar_imagen()
	
func asignar_imagen():
	if (PUBLICACION_ASIGNADA.get_tipo() == "TEXTO"):
		recursoMultimedia.hide()
		cajaTextoPubli.position = pos_SIN_IMAGEN
		cajaTextoPubli.size = size_SIN_IMAGEN
	else:
		#recursoMultimedia.texture = recurso
		pass
		

func _on_b_publicar_button_up() -> void:
	publicar()
func _on_b_descartar_button_up() -> void:
	$ControlOpsDescartar.grab_focus()

func _on_controlOpsDescartar_focus_entered() -> void:
	$ControlOpsDescartar.set_visible(true)
func _on_controlOpsDescartar_focus_exited() -> void:
	$ControlOpsDescartar.set_visible(false)
	
 #------funcion al presionar alguna opcion de descarte
func algunBotonDescartar_Pressed(motivo: String):
	print(motivo)
	#hacer algo
	descartar()
	
	
func publicar():
	Utils.PUBLIS_PUBLICADAS.append(PUBLICACION_ASIGNADA)
	
	Utils.bloquear_cambio_tabs()
	await animacionRetirarTab("PUBLICAR")
	Utils.bloquear_cambio_tabs()
	
	self.queue_free()
	Utils.contador -= 1
	print("PUBLICADAS: "+ str(len(Utils.PUBLIS_PUBLICADAS)))
	
func descartar():
	Utils.PUBLIS_DESCARTADAS.append(PUBLICACION_ASIGNADA)
	
	Utils.bloquear_cambio_tabs()
	await animacionRetirarTab("DESCARTAR")
	Utils.bloquear_cambio_tabs()
	
	self.queue_free()
	Utils.contador -= 1
	print("DESCARTADAS: "+ str(len(Utils.PUBLIS_DESCARTADAS)))



func animacionRetirarTab(direccion:String):
	var dir
	if direccion == "PUBLICAR":
		dir = -1
	elif direccion == "DESCARTAR":
		dir = 1.006410256 # 780px a la derecha no sacan completamente a la ventana de la vista por alguna razon, asiq eu toca poner esto
	else:
		print("ARGUMENTO INVALIDO MOSTro")
	
	var tween_actual = create_tween()
	
	tween_actual.tween_property(self,"position:x",780*dir, 0.8).set_trans(Tween.TRANS_QUAD)
	tween_actual.tween_interval(0.6)
	await tween_actual.finished
	
	


func _on_hacer_algo_button_down() -> void:
	print($ControlOpsDescartar.has_focus())
	$ControlOpsDescartar.grab_focus()
	print("po")
	print($ControlOpsDescartar.has_focus())
	

	
	
	
	
	
	
	
	
	
	
