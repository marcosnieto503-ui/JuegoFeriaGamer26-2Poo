extends Control


@onready var publiTextoLabel = $PanelContainer/HBoxContainer/LadoPubli/Control/PubliText
@onready var commentTextoLabel = $PanelContainer/HBoxContainer/LadoResponder/Control/ComentarioText
@onready var respuesta1Label = $PanelContainer/HBoxContainer/LadoResponder/Control/OPCION1/Respuesta1
@onready var respuesta2Label = $PanelContainer/HBoxContainer/LadoResponder/Control/OPCION2/Respuesta2
@onready var respuesta3Label = $PanelContainer/HBoxContainer/LadoResponder/Control/OPCION3/Respuesta3
@onready var noResponderLabel = $"PanelContainer/HBoxContainer/LadoResponder/Control/NoResponder/No responder"

var commentAsignado:Comentario
var publi:Publicacion

var timerRetrasoReaccion:Timer
@export_category("Retraso Reaccion")
@export var duracionRetrasoReaccion:float = 0.5
@export var escenaReaccion:Node

func _inicializar(c:Comentario,p:Publicacion):
	commentAsignado = c
	publi = p
	if commentAsignado and publi:
		procesarComentario()
	else:
		print("(COmment_Overlay) no hay publi o comentario valido asignado")
		return
	entrada()

func entrada():
	Utils.bloquear_cambio_tabs()
	show()
func salida():
	Utils.bloquear_cambio_tabs()
	ProgresoPuntuacion.COMENTARIOS_CORRECTOS.append(commentAsignado)
	commentAsignado = null
	loadBackground.hide()
	LoadingAnim.hide()
	checkImg.hide()
	hide()


func _ready() -> void:
	timerRetrasoReaccion = Timer.new()
	timerRetrasoReaccion.timeout.connect(terminaTimerRetrasoReaccion)
	timerRetrasoReaccion.set_one_shot(true)
	self.add_child(timerRetrasoReaccion)
	hide()
	$PanelContainer/HBoxContainer/LadoResponder/Control/OPCION1.pressed.connect(_opcionElegida)
	$PanelContainer/HBoxContainer/LadoResponder/Control/OPCION2.pressed.connect(_opcionElegida)
	$PanelContainer/HBoxContainer/LadoResponder/Control/OPCION3.pressed.connect(_opcionElegida)
	$PanelContainer/HBoxContainer/LadoResponder/Control/NoResponder.pressed.connect(_opcionElegida)
	if commentAsignado:
		procesarComentario()
	loadBackground.hide()
	LoadingAnim.hide()
	checkImg.hide()
	timer.timeout.connect(terminaTimer) #se;al conectada
	timer.one_shot = true

func terminaTimerRetrasoReaccion():
	var react = commentAsignado.get_reaccion()
	push_error("VALOR COMENTARIO NREACCIONE :",react)
	if react == "null":
		push_error("El comentario %s no tiene reaccion valida asignada" % commentAsignado)
		return
	var reactEnum:PersistenciaPersonaje.REACCIONESDISPONIBLES
	
	react = str(react).strip_edges().to_upper()
	push_error(react)
	
	
	if !reactEnum:
		escenaReaccion.displayPlayerReaccion()
		return
	escenaReaccion.displayPlayerReaccion(reactEnum)

func procesarComentario():
	timerRetrasoReaccion.start(duracionRetrasoReaccion)
	
	publiTextoLabel.text = publi.get_textoPubli()
	commentTextoLabel.text = commentAsignado.get_texto()
	respuesta1Label.text = commentAsignado.get_r1()
	respuesta2Label.text = commentAsignado.get_r2()
	respuesta3Label.text = commentAsignado.get_r3()

func _opcionElegida():
	buttonsClick()
	UtilsComentarios.procesarComentarioEnPuntuacion(commentAsignado)
	print("(coment_overlay)--Comentario %s procesado" % publi.get_id())
	reproducirAnimProcesar()


func mouseEnterButtons():
	GlobalAudioSignals.playUiHint1()
func mouseExitButtons():
	pass
func buttonsClick():
	GlobalAudioSignals.playMouseClick1()


@export_category("Comentario Process")
@export var loadBackground:Control
@export var LoadingAnim:AnimatedSprite2D
@export var checkImg:TextureRect
@export var processDuracion:float = 0.8
@export var timer:Timer
var tween:Tween

func reproducirAnimProcesar():
	loadBackground.show()
	LoadingAnim.show()
	#checkImg.show()
	LoadingAnim.play()
	
	timer.start(processDuracion)

func animarCheck():
	GlobalAudioSignals.playCorrectAnswer()
	var pos_original = checkImg.position
	var tween = create_tween()
	
	tween.tween_property(checkImg, "position:y", pos_original.y - 20, 0.1)\
	.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(checkImg, "position:y", pos_original.y, 0.15)\
	.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func terminaTimer():
	LoadingAnim.stop()
	LoadingAnim.hide()
	checkImg.show()
	animarCheck()
	await get_tree().create_timer(0.8).timeout
	salida()
