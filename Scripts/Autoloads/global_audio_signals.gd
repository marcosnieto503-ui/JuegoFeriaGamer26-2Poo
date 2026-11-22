extends Node


var AUDIO:Node

func _ready() -> void:
	pass
	

func play_musica_fondo():
	# global_audio_signals.gd, al inicio de play_musica_fondo()
	print("play_musica_fondo, AUDIO = ", AUDIO, " | instancia: ", get_path())
	AUDIO.playMusicaFondo()


func playNotiRecibida():
	AUDIO.playNotiRecibida()

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

func playMouseClick1():
	AUDIO.playSampleRPitch("mouse_click1")
func playUiHint3Strong():
	AUDIO.playSampleRPitch("ui_hint3_strong")
func playUiRetroEffect1():
	AUDIO.playSampleRPitch("ui_retro_effect1")
func playUiHint1():
	AUDIO.playSampleRPitch("ui_hint1")
func playUiHint2():
	AUDIO.playSampleRPitch("ui_hint2")
