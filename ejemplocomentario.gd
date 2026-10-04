# esto no debe quedar en la version final del juego, solo es un ejemplo para que se vea como se tiene que llamar la fncion de reaccioanr
#
extends Node

@export var tipo : String = "reaccion1"
@onready var sprite = $AnimatedSprite2D

func mostrarReaccion() -> void:
	sprite.reaccionar(tipo)
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mostrarReaccion()
