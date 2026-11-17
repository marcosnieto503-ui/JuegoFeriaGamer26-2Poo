extends AnimatedSprite2D


var anim_Escritorio_Soleado:AnimatedSprite2D
@export var anim_Escritorio_Atardecer:AnimatedSprite2D
@export var SOL:Sprite2D

@export var pixelesRecorridosPorElSol:int = 200
@export var duracionHastaAtardecer:float
@export var maximaIntensidadFiltroAtardecer:float = 0.66
@export var DEBUG_atardecer_automatico:bool = false



@export_category("Reloj")
@export var labelRELOJ:RichTextLabel
#@export_range(0.1, 600.0, 0.1, "or_greater", "suffix:s") var duracionReloj: float = 20.0
@export var saltos_de_diez: bool = true
@export_group("Hora inicial")
@export_range(0, 23) var hora_inicio: int = 6
@export_range(0, 59) var minuto_inicio: int = 30

@export_group("Hora final")
@export_range(0, 23) var hora_fin: int = 18
@export_range(0, 59) var minuto_fin: int = 45

@onready var duracionReloj: float = duracionHastaAtardecer

@onready var nodeFiltroAtardecer:ColorRect = $FiltroCieloAtardecer
var shaderAtardecer:ShaderMaterial

var tweenFiltroAtardecer:Tween
var tweenEscritorioAtardecer:Tween
var tweenSol:Tween

const frame_telefono_abajo:int = 0
const frame_telefono_arriba:int = 1

func _ready() -> void:
	anim_Escritorio_Soleado = self
	shaderAtardecer = nodeFiltroAtardecer.material
	anim_Escritorio_Atardecer.modulate.a = 0
	if DEBUG_atardecer_automatico:
		iniciar_transicion_atardecer()

func correr_reloj(h_ini: int, m_ini: int, h_fin: int, m_fin: int, duracion: float, saltosDeDiez:bool = false):
	labelRELOJ.correr_reloj(h_ini,m_ini,h_fin,m_fin,duracion,saltosDeDiez)

func select_frame_telefono_abajo():
	anim_Escritorio_Soleado.frame = frame_telefono_abajo
	anim_Escritorio_Atardecer.frame = frame_telefono_abajo
	$pantallaCel.hide()
func select_frame_telefono_arriba():
	anim_Escritorio_Soleado.frame = frame_telefono_arriba
	anim_Escritorio_Atardecer.frame = frame_telefono_arriba
	$pantallaCel.show()

func iniciar_transicion_atardecer():
	iniciarTweenFiltroAtardecer()
	iniciarTweenEscritorioAtardecer()
	iniciarRecorridoSol()
	correr_reloj(hora_inicio,minuto_inicio,hora_fin,minuto_fin,duracionReloj,saltos_de_diez)

func iniciarRecorridoSol():
	if tweenSol:
		tweenSol.kill()
	tweenSol = create_tween()
	tweenSol.tween_property(SOL,"position:y",pixelesRecorridosPorElSol,duracionHastaAtardecer)

func iniciarTweenEscritorioAtardecer():
	if tweenEscritorioAtardecer:
		tweenEscritorioAtardecer.kill()
	tweenEscritorioAtardecer = create_tween()
	tweenEscritorioAtardecer.tween_property(anim_Escritorio_Atardecer,"modulate:a",1,duracionHastaAtardecer)

func iniciarTweenFiltroAtardecer():
	if tweenFiltroAtardecer:
		tweenFiltroAtardecer.kill()
	tweenFiltroAtardecer = create_tween()
	tweenFiltroAtardecer.tween_property(shaderAtardecer,"shader_parameter/intensity",maximaIntensidadFiltroAtardecer,duracionHastaAtardecer)
