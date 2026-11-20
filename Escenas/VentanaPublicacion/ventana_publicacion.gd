extends PanelContainer

@onready var cajaTextoPubli = $Control/TextoPublicacion
@onready var recursoMultimedia = $Control/RecursoMultimedia
@onready var labelTipoPubli = $Control/LabelTipoPubli


var PUBLICACION_ASIGNADA : Publicacion = null
var recurso : Texture2D = null
var textoPubli : String

const pos_CON_IMAGEN =Vector2(275,35)
const pos_SIN_IMAGEN =Vector2(70,35)

const size_CON_IMAGEN = Vector2(495,180)
const size_SIN_IMAGEN = Vector2(690,180)

@onready var botonInapropiado = $ControlOpsDescartar/OpcionesDescartar/HBoxContainer/VBoxContainer2/Inapropiado
@onready var botonFormatoInvalido = $ControlOpsDescartar/OpcionesDescartar/HBoxContainer/VBoxContainer2/FormatoInvalido
@onready var botonPubliNoRelacionada = $ControlOpsDescartar/OpcionesDescartar/HBoxContainer/VBoxContainer3/PubliNoRelacionada
@onready var botonInfoErronea = $ControlOpsDescartar/OpcionesDescartar/HBoxContainer/VBoxContainer3/InfoErronea
# Called when the node enters the scene tree for the first time.

var _tabIndex:int

func _ready() -> void:
	#botones del menu que aparece al descartar
	$ControlOpsDescartar.set_visible(false)
	botonInapropiado.pressed.connect(procesarAccionDescarte.bind("INAPROPIADO"))
	botonFormatoInvalido.button_up.connect(procesarAccionDescarte.bind("FORMATO"))
	botonPubliNoRelacionada.button_up.connect(procesarAccionDescarte.bind("NO_RELACIONADA"))
	botonInfoErronea.button_up.connect(procesarAccionDescarte.bind("INFORMACION_ERRONEA"))

const colorLinkNoPressed := Color("2a96ffff")
const colorLinkPressed:= Color("7ad2ffff")

func inicializar(publi : Publicacion,i:int):
	PUBLICACION_ASIGNADA = publi
	recurso = PUBLICACION_ASIGNADA.get_recurso()
	textoPubli = PUBLICACION_ASIGNADA.get_textoPubli()
	
	cambiarColorLink(false) #true para hover, false para color normal
	#cajaTextoPubli.set_text(textoPubli)
	labelTipoPubli.set_text("Tipo de Publicacion: " + PUBLICACION_ASIGNADA.get_tipo())
	asignar_imagen()
	
	_tabIndex = i



func _link_clickeado(meta :Variant): #funcion de click en el link
	if Utils.ARTICULO_ACTIVO:
		print("HAY UN ARTICULO YA ACTIVO, EJECUTANDO -> [No hacer nada]")
		return
	print("fuap cliekado po "+ meta)
	Utils._link_Clickeado.emit(PUBLICACION_ASIGNADA.get_id()) # se;al emitidaaaa
	GlobalAudioSignals.playLinkOpened()



func _mouse_sobre_link(meta: Variant) -> void:
	#comprobacion para evitar multiples ejecuciones de esta funcion cya que se llama varias veces al alterar el texto dellabel
	Input.set_default_cursor_shape(2)
	if (meta.begins_with("h,")):
		return
	#print("entro")
	cambiarColorLink(true)
func _mouse_fuera_del_link(meta: Variant):
	Input.set_default_cursor_shape(0)
	if (meta.begins_with("n,")):
		return
	#print("salgo")
	cambiarColorLink(false)

func cambiarColorLink(hover:bool) -> void: #true para color cuando el mouse esta encima, false para color normal
	if (hover):
		textoPubli = textoPubli.replace("[url=n,", "[url=h,")
		cajaTextoPubli.text = (textoPubli.format({"clr": "#" + colorLinkPressed.to_html(false)}))
	else:
		textoPubli = textoPubli.replace("[url=h,", "[url=n,")
		cajaTextoPubli.text = (textoPubli.format({"clr": "#" + colorLinkNoPressed.to_html(false)}))
	

func asignar_imagen():
	if (PUBLICACION_ASIGNADA.get_tipo() == "TEXTO"):
		recursoMultimedia.hide()
		cajaTextoPubli.position = pos_SIN_IMAGEN
		cajaTextoPubli.size = size_SIN_IMAGEN
	else:
		recursoMultimedia.texture = recurso

func _on_b_publicar_button_up() -> void: #Publicar
	desabilitarInteraccion()
	DataPartida.procesarPubli(PUBLICACION_ASIGNADA, "PUBLICAR")
	publicar()
func _on_b_descartar_button_up() -> void: #PASA EL FOCUS A EL PANEL DE OPCIONES DESCARTAR PARA QUE SE MUESTRE
	$ControlOpsDescartar.grab_focus()


func _on_controlOpsDescartar_focus_entered() -> void:
	$ControlOpsDescartar.set_visible(true)
func _on_controlOpsDescartar_focus_exited() -> void:
	$ControlOpsDescartar.set_visible(false)


func procesarAccionDescarte(accion: String): #------funcion al presionar alguna opcion de descarte---- EEEEEEEEEEEEEEE
	desabilitarInteraccion()
	DataPartida.procesarPubli(PUBLICACION_ASIGNADA, accion)
	descartar()
	
func desabilitarInteraccion():
	$Control/B_Publicar.set_disabled(true)
	$ControlOpsDescartar.release_focus()
	$Control/B_Descartar.set_disabled(true)
	
func publicar():
	Utils.bloquear_cambio_tabs()
	await animacionRetirarTab("PUBLICAR")
	Utils.bloquear_cambio_tabs()
	
	self.queue_free()
	Utils.liberarTabIndex(_tabIndex)
	print("publicado--")
	print("PUBLICADAS: "+ str(len(DataPartida.PUBLIS_PUBLICADAS)))
	
func descartar():
	Utils.bloquear_cambio_tabs()
	await animacionRetirarTab("DESCARTAR")
	Utils.bloquear_cambio_tabs()
	
	self.queue_free()
	Utils.liberarTabIndex(_tabIndex)
	print("descartado---")
	print("DESCARTADAS: "+ str(len(DataPartida.PUBLIS_DESCARTADAS)))


@export var processAnimator:Control
func animacionRetirarTab(opcionElegida:String):
	await processAnimator.reproducirSecuencia(opcionElegida)
	
