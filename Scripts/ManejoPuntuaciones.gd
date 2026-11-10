extends Node

var valorComentarioCorrecto = 10
var valorComentarioIncorrecto = 10
var valorPublicacionCorrecta = 10
var valorPublicacionIncorrecta = 10

var puntuacionComentarios = 0
var puntuacionPublicaciones = 0

func calcularPuntuacionComentarios():
	var comentariosCorrectos = ProgresoPuntuacion.Obtener_Comentarios_Correctos()
	var comentariosIncorrectos = ProgresoPuntuacion.Obtener_Comentarios_Incorrectos()
	
	puntuacionComentarios += comentariosCorrectos * valorComentarioCorrecto
	puntuacionComentarios -= comentariosIncorrectos * valorComentarioIncorrecto

func calcularPuntuacionPublicaciones():
	var publicacionesCorrectas = ProgresoPuntuacion.Obtener_Publicaciones_Correctos()
	var publicacionesIncorrectas = ProgresoPuntuacion.Obtener_Publicaciones_Incorrectas()
	
	puntuacionPublicaciones += publicacionesCorrectas * valorPublicacionCorrecta
	puntuacionPublicaciones -= publicacionesIncorrectas * valorPublicacionIncorrecta

func ObtenerPuntuacionComentarios():
	calcularPuntuacionComentarios()
	return puntuacionComentarios
func ObtenerPuntuacionPublicaciones():
	calcularPuntuacionPublicaciones()
	return puntuacionPublicaciones
