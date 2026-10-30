extends Node


@export var AUDIO :Node

func _ready() -> void:
	GlobalAudioSignals.AUDIO = AUDIO
	await get_tree().process_frame
	AUDIO.playMusicaFondo()


func playHoverNoti():
	AUDIO.playSampleRPitch("hover_hint1")
func playNotiClickeada():
	AUDIO.playSampleRPitch("noti_click1")
func playNoEntranPublis():
	AUDIO.playSampleRPitch("noti_cannot_click1")

func playCorrectAnswer():
	AUDIO.playSampleRPitch("correcto1")
func playWrongAnswer():
	AUDIO.playSampleRPitch("incorrecto2")

func playLinkOpened():
	AUDIO.playSampleRPitch("ui_pop2")
func playNoticieroClosed():
	AUDIO.playSampleRPitch("ui_pop1")

func playTabSwitch():
	AUDIO.playSampleRPitch("tab_switch1")
