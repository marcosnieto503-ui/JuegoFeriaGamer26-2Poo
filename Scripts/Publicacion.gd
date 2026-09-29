extends Node

class_name Publicacion

var _textoNoti: String
var _id: int
var _tipo: String
var _rutaRecurso: String
var _textoPubli: String
var _comentarios: Array

func _init(textoNoti:String, id:int, tipo:String, textoPubli:String):
	self._textoNoti = textoNoti
	self._id = id
	self._tipo = tipo
	self._rutaRecurso = Utils.RUTAS_RECURSOS[id]
	self._textoPubli = textoPubli
	self._comentarios = []
	
func get_textoNoti():
	return self._textoNoti
	
func addComentario(comentario:Comentario):
	_comentarios.append(comentario)
	
func getComentarioRandom():
	return _comentarios.pick_random()
