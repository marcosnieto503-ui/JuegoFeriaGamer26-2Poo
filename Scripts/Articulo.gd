extends Node

class_name Articulo

var _nombre : String
var _tipo : String #NOTICIA o WIKIPEDIA
var _id : int
var _categoria : String
var _titular : String #el titular de la noticia es el titulo del articulo de wiki
var _texto : String #cuerpo del articulo
var _img : Texture2D #si es de wiki esto es null y no se usa

func _init(nombre,tipo,id,cat,titular,texto):
	self._nombre = nombre
	self._tipo = tipo
	self._id = id
	self._categoria = cat
	self._titular = titular
	self._texto = texto
	if Utils.RECURSOS_ARTICULOS.has(self._id):
		self._img = Utils.RECURSOS_ARTICULOS[self._id]
		print("----- colocado articulo img")
	else:
		self._img = Utils.RECURSOS_ARTICULOS.get(0)

func get_tipo():
	return self._tipo
func get_nombre():
	return self._nombre
func get_id():
	return self._id
func get_categoria():
	return self._categoria
func get_titular():
	return self._titular
func get_texto():
	return self._texto
func get_img():
	return self._img
