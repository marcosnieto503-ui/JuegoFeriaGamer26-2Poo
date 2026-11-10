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
func Ingresar_Publi_Incoorrecta(p:Publicacion):
	PUBLIS_INCORRECTAS.append(p)

func Ingresar_Comentario_Correcto(c:Comentario):
	COMENTARIOS_CORRECTOS.append(c)
func Ingresar_Comentario_Incorrecto(c:Comentario):
	COMENTARIOS_INCORRECTOS.append(c)
