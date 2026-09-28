extends Node

class_name Comentario

var _texto :String
var _id :int
var _r1 :String
var _r2 :String
var _r3 :String
var _rDefault :String = "(No responder)"

func _init(texto:String,id:int,r1:String,r2:String,r3:String):
	self._texto = texto
	self._id = id
	self._r1 = r1
	self._r2 = r2
	self._r3 = r3
