extends Node


var PUBLIS_CORRECTAS:Array[Publicacion]
var PUBLIS_INCORRECTAS:Array[Publicacion]
var COMENTARIOS_CORRECTOS:Array[Comentario]
var COMENTARIOS_INCORRECTOS:Array[Comentario]

var PUBLIS_DESCARTADAS:Array[Publicacion]
var PUBLIS_PUBLICADAS:Array[Publicacion]

func _ready() -> void:
	PUBLIS_CORRECTAS = []
	PUBLIS_INCORRECTAS = []
	COMENTARIOS_CORRECTOS = []
	COMENTARIOS_INCORRECTOS = []
	PUBLIS_DESCARTADAS = []
	PUBLIS_PUBLICADAS = []


func ingresar_Publi_Descartada(p:Publicacion):
	PUBLIS_DESCARTADAS.append(p)
func ingresar_Publi_Publicada(p:Publicacion):
	PUBLIS_PUBLICADAS.append(p)

func Ingresar_Publi_Correcta(p:Publicacion):
	PUBLIS_CORRECTAS.append(p)
func Ingresar_Publi_Incoorrecta(p:Publicacion):
	PUBLIS_INCORRECTAS.append(p)

func Ingresar_Comentario_Correcto(c:Comentario):
	COMENTARIOS_CORRECTOS.append(c)
func Ingresar_Comentario_Incorrecto(c:Comentario):
	COMENTARIOS_INCORRECTOS.append(c)
