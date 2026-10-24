extends Node


@export var AUDIO :Node

func _ready() -> void:
	GlobalAudioSignals.AUDIO = AUDIO

func playNotiClickeada():
	AUDIO.playSampleRPitch("noti_click1")
	
