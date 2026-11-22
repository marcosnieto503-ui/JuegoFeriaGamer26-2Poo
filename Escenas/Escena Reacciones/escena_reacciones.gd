extends Node2D

@onready var animFeedback = $"Señales"

@export_category("Reacciones Player")
@export var reaccionesNode:Node2D
@export var sizePlayerImg:Vector2 = Vector2(200,200)
@export var reaccionTextureRect:TextureRect
@export var marcoReaccionesAnim:AnimatedSprite2D
@export var posicionDefaultReacciones:Vector2 = Vector2(1640,245)
@export var duraccionReaccion:float = 2
@export var timerReaccion:Timer

var corriendoReaccion =false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reaccionesNode.hide()
	marcoReaccionesAnim.stop()
	timerReaccion.one_shot = true
	timerReaccion.timeout.connect(acabaTimerReaccion)
	animFeedback.set_visible(false)
	pass # Replace with function body.

func displayAnimFeedback(anim:String,posicion:Vector2, duracion:float):
	animFeedback.position = posicion
	animFeedback.set_visible(true)
	animFeedback.set_animation(anim)
	animFeedback.play()
	await get_tree().create_timer(duracion).timeout 
	animFeedback.visible = false
	animFeedback.stop()


var posiblesReacciones:Array[String] = [
	"feliz",
	"enojado",
	"sorprendido"
]

func displayPlayerReaccion(pos:Vector2 = posicionDefaultReacciones,reaccion:String = "feliz"):
	if corriendoReaccion:
		return
	print("REACCIONES PLAICADA")
	if !pos:
		push_error("(Escenma reacciones) nmo se ingreso una posicion para la reaccion")
		return
	if !posiblesReacciones.has(reaccion):
		push_error("(Escena reacicones) no existe la reaccion %s" % reaccion)
		return
	#var texturaReaccion = PersistenciaJugador.get_reaccion(reaccion).get_texture()
	#if !texturaReaccion:
	#	push_error("(Escena reacciones) no existe textura para la reaccion: ",reaccion)
	#	return
	#reaccionTextureRect.set_texture(texturaReaccion)
	reaccionesNode.show()
	reaccionesNode.position = pos
	marcoReaccionesAnim.play()
	corriendoReaccion = true
	timerReaccion.start(duraccionReaccion)

func acabaTimerReaccion():
	ocultarReaccionSprites()
	corriendoReaccion = false

func ocultarReaccionSprites():
	reaccionesNode.position = Vector2(-100,-100)
	marcoReaccionesAnim.stop()
	reaccionesNode.hide()
