
@tool
extends Node

@export_tool_button("METER COMENTARIO", "Add") var po = _meter_comentario
@export_tool_button("VACIAR COMENTARIOS", "AnimationFilter") var pos = _vaciar_comentarios

@onready var CommentScene = preload("res://Escenas/comentario.tscn")
@onready var cajaComentarios = $"../../Laptop/Pestañas/PRINCIPAL/PanelContainer/ScrollContainer/CajaComentarios"

func _meter_comentario():
	return
	var com = CommentScene.instantiate()
	com.asignarComentario($"../ControlComentarios"._get_comentario_random())
	cajaComentarios.add_child(com)
	print("COMENTARIO PEGAO")

func _vaciar_comentarios():
	for child in cajaComentarios.get_children():
		child.queue_free()
