extends NinePatchRect


@onready var loadBackground = self

@export var LoadingAnim:AnimatedSprite2D
@export var simbolImg:TextureRect
@export var optionLabel:Label

@export var processDuracion:float = 0.8
@export var timer:Timer
var tween:Tween

@export var checkTexture:Texture2D
@export var crossTexture:Texture2D

func _ready() -> void:
	loadBackground.hide()
	simbolImg.hide()
	LoadingAnim.hide()
	optionLabel.hide()

func reproducirSecuencia(opcionElegida:String):
	match opcionElegida:
		"PUBlICAR":
			optionLabel.set_text("PUBLICADO")
			simbolImg.set_texture(checkTexture)
		"DESCARTAR":
			optionLabel.set_text("DESCARTADO")
			simbolImg.set_texture(crossTexture)
	
	loadBackground.show()
	LoadingAnim.show()
	LoadingAnim.play()
	await get_tree().create_timer(processDuracion).timeout
	LoadingAnim.stop()
	LoadingAnim.hide()
	simbolImg.show()
	optionLabel.show()
	animarCheck()
	await get_tree().create_timer(0.8).timeout


func animarCheck():
	GlobalAudioSignals.playUiHint3Strong()
	var pos_original = simbolImg.position
	var tween = create_tween()
	
	tween.tween_property(simbolImg, "position:y", pos_original.y - 20, 0.1)\
	.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(simbolImg, "position:y", pos_original.y, 0.15)\
	.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
