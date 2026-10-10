extends Node

class_name Publicacion

var _textoNoti: String
var _id: int
var _tipo: String
var _recurso: Texture2D
var _textoPubli: String
var _comentarios: Array
var _accion: String

func _init(textoNoti:String, id:int, tipo:String, accion:String,textoPubli:String):
	self._textoNoti = textoNoti
	self._id = id
	self._tipo = tipo
	if Utils.RECURSOS.has(self._id):
		self._recurso = Utils.RECURSOS[self._id]
		print("colocado")
	else:
		self._recurso = Utils.RECURSOS.get(0)
	self._textoPubli = textoPubli
	self._comentarios = []
	self._accion = accion
	
func get_textoNoti():
	return self._textoNoti
func get_textoPubli():
	return self._textoPubli
func get_tipo():
	return self._tipo
func get_id():
	return self._id
func get_accion():
	return self._accion
func get_recurso():
	return self._recurso
	
func addComentario(comentario:Comentario):
	_comentarios.append(comentario)
	
func getComentarioRandom():
	return _comentarios.pick_random()
