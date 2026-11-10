extends Node


var PUBLIS_CORRECTAS:Array[Publicacion]
var PUBLIS_INCORRECTAS:Array[Publicacion]
var COMENTARIOS_CORRECTOS:Array[Comentario]
var COMENTARIOS_INCORRECTOS:Array[Comentario]

func _ready() -> void:
	PUBLIS_CORRECTAS = []
	PUBLIS_INCORRECTAS = []
	COMENTARIOS_CORRECTOS = []
	COMENTARIOS_INCORRECTOS = []


func Ingresar_Publi_Correcta(p:Publicacion):
	PUBLIS_CORRECTAS.append(p)
func Ingresar_Publi_Incorrecta(p:Publicacion):
	PUBLIS_INCORRECTAS.append(p)

func Ingresar_Comentario_Correcto(c:Comentario):
	COMENTARIOS_CORRECTOS.append(c)
func Ingresar_Comentario_Incorrecto(c:Comentario):
	COMENTARIOS_INCORRECTOS.append(c)
	
func Obtener_Comentarios_Correctos():
	return COMENTARIOS_CORRECTOS.size()
func Obtener_Comentarios_Incorrectos():
	return COMENTARIOS_INCORRECTOS.size()
func Obtener_Publicaciones_Correctos():
	return PUBLIS_CORRECTAS.size()
func Obtener_Publicaciones_Incorrectas():
	return PUBLIS_INCORRECTAS.size()
