class_name Publicacion
extends RefCounted

var titulo
var descripcion

func _init_(titulo : String, descripcion : String):
	self.titulo = titulo
	self.descripcion = descripcion
