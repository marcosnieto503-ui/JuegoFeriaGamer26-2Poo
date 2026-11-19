extends Control


@onready var publiTextoLabel = $PanelContainer/HBoxContainer/LadoPubli/Control/PubliText
@onready var commentTextoLabel = $PanelContainer/HBoxContainer/LadoResponder/Control/ComentarioText
@onready var respuesta1Label = $PanelContainer/HBoxContainer/LadoResponder/Control/OPCION1/Respuesta1
@onready var respuesta2Label = $PanelContainer/HBoxContainer/LadoResponder/Control/OPCION2/Respuesta2
@onready var respuesta3Label = $PanelContainer/HBoxContainer/LadoResponder/Control/OPCION3/Respuesta3
@onready var noResponderLabel = $"PanelContainer/HBoxContainer/LadoResponder/Control/NoResponder/No responder"

var commentAsignado:Comentario
var publi:Publicacion

func _inicializar(c:Comentario,p:Publicacion):
	commentAsignado = c
	publi = p
	show()
	print("LS D   SCOIN   CON FOCUS")

func _ready() -> void:
	hide()
	$PanelContainer/HBoxContainer/LadoResponder/Control/OPCION1.pressed.connect(_opcionElegida)
	$PanelContainer/HBoxContainer/LadoResponder/Control/OPCION2.pressed.connect(_opcionElegida)
	$PanelContainer/HBoxContainer/LadoResponder/Control/OPCION3.pressed.connect(_opcionElegida)
	$PanelContainer/HBoxContainer/LadoResponder/Control/NoResponder.pressed.connect(_opcionElegida)
	if commentAsignado:
		procesarComentario()
	

func procesarComentario():
	publiTextoLabel.text = publi.get_textoPubli()
	commentTextoLabel.text = commentAsignado.get_texto()
	respuesta1Label.text = commentAsignado.get_r1()
	respuesta2Label.text = commentAsignado.get_r2()
	respuesta3Label.text = commentAsignado.get_r3()

func _opcionElegida():
	ProgresoPuntuacion.Ingresar_Comentario_Correcto(commentAsignado)
	print("CLICEKADO _A_D_S_DAKSDOPAOWD")
	hide()
	print("   a wsdlkasndlna   SIN FOCUS")
