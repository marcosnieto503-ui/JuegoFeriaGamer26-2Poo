extends Node

@export var nodoNotiRecibida:Node2D

func _ready() -> void:
	GlobalEfectos.nodoNotiRecibida = nodoNotiRecibida

func efectoNotiRecibida(pos:Vector2,times:int):
	nodoNotiRecibida.reproducirEfecto(pos,times)
