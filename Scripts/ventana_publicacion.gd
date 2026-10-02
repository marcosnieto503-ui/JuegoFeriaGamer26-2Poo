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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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
