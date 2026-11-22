extends Control


@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var timer_tecleo: Timer = $TimerTecleo
@onready var boton: Button = $MarginContainer/VBoxContainer/BotonContinuar

func _ready() -> void:
	pass

func _on_boton_continuar_pressed() -> void:
	#Transicion.cambiarEscena(siguiente_escena)
	GameManager.CAMBIAR_DE_ESCENA(GameManager.ENUMESCENAS.SELECCIONPERSONAJE)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	timer_tecleo.stop()
	boton.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if anim.is_playing() and event.is_pressed():
		anim.seek(anim.current_animation_length, true)
		_on_animation_player_animation_finished("escribir")
