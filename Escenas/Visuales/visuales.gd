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


@onready var nodeFiltroAtardecer:ColorRect = $FiltroCieloAtardecer
var shaderAtardecer:ShaderMaterial

@onready var nubesGrandes = $NubesGrandes
@onready var nubesSmall = $NubesDelgadas
var scrollG:Vector2
var scrollS:Vector2

var tweenFiltroAtardecer:Tween
var tweenEscritorioAtardecer:Tween
var tweenSol:Tween

const frame_telefono_abajo:int = 0
const frame_telefono_arriba:int = 1


signal _transicion_terminada

var en_pausa:bool = true

func _ready() -> void:
	anim_Escritorio_Soleado = self
	shaderAtardecer = nodeFiltroAtardecer.material
	anim_Escritorio_Atardecer.modulate.a = 0
	
	if DEBUG_atardecer_automatico:
		iniciar_transicion_atardecer()
	
	scrollG = nubesGrandes.autoscroll
	scrollS = nubesSmall.autoscroll
	nubesGrandes.autoscroll = Vector2.ZERO
	nubesGrandes.autoscroll = Vector2.ZERO


func iniciar_transicion_atardecer(duracion:float = duracionHastaAtardecer):
	duracionHastaAtardecer = duracion
	nubesGrandes.autoscroll = scrollG
	nubesGrandes.autoscroll = scrollS
	iniciarTweenFiltroAtardecer()
	iniciarTweenEscritorioAtardecer()
	iniciarRecorridoSol()
	correr_reloj(hora_inicio,minuto_inicio,hora_fin,minuto_fin,duracionHastaAtardecer,saltos_de_diez)
	en_pausa = false

func pausarTransicion():
	if en_pausa:
		return
	en_pausa = true
	
	labelRELOJ.pausar()
	if tweenEscritorioAtardecer and tweenEscritorioAtardecer.is_valid():
		tweenEscritorioAtardecer.pause()
	if tweenFiltroAtardecer and tweenFiltroAtardecer.is_valid():
		tweenFiltroAtardecer.pause()
	if tweenSol and tweenSol.is_valid():
		tweenSol.pause()
	pausaNubeScroll()

func reanudarTransicion():
	if !en_pausa:
		return
	en_pausa = false
	
	labelRELOJ.reanudar()
	if tweenEscritorioAtardecer and tweenEscritorioAtardecer.is_valid():
		tweenEscritorioAtardecer.play()
	if tweenFiltroAtardecer and tweenFiltroAtardecer.is_valid():
		tweenFiltroAtardecer.play()
	if tweenSol and tweenSol.is_valid():
		tweenSol.play()
	reanudaNubeScroll()


func pausaNubeScroll():
	nubesGrandes.autoscroll = Vector2.ZERO
	nubesGrandes.autoscroll = Vector2.ZERO
func reanudaNubeScroll():
	scrollG = nubesGrandes.autoscroll
	scrollS = nubesSmall.autoscroll

func detenerReloj():
	labelRELOJ.detener_reloj()

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


func transicion_terminada(): #termina la transicion -------------------
	print("(visuales) EL SOL SE HA PUESTO")
	_transicion_terminada.emit()


func iniciarRecorridoSol():
	if tweenSol:
		tweenSol.kill()
	tweenSol = create_tween()
	tweenSol.finished.connect(transicion_terminada)
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
