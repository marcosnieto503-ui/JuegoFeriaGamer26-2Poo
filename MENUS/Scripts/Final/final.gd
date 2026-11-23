extends Node2D

@onready var avatar: TextureRect = $Hojas/ContenidoHoja/Divisiones/Perfil/Retrato/Personaje

func _ready() -> void:
	avatar.texture = PersistenciaPersonaje.obtener_reaccion(PersistenciaPersonaje.REACCIONESDISPONIBLES.NEUTRAL)

func INICIALIZAR_ESCENA():
	asignarResultados()
	$FONDO.play()
	await get_tree().create_timer(2).timeout



func asignarResultados():
	var acertadas = len(ProgresoPuntuacion.PUBLIS_CORRECTAS)
	if !acertadas or acertadas <0:
		acertadas = 0
	var erroneas = len(ProgresoPuntuacion.PUBLIS_INCORRECTAS)
	if !erroneas or erroneas < 0:
		erroneas = 0
	var numComentarios = len(ProgresoPuntuacion.COMENTARIOS_CORRECTOS)
	var puntos = acertadas*2000 - erroneas*2000 + numComentarios*600
	
	$Hojas/ContenidoHoja/Divisiones/Publicadas/Contenido/Texto2.text = str(acertadas)
	$Hojas/ContenidoHoja/Divisiones/Descartadas/Contenido/Texto2.text = str(erroneas)
	$Hojas/ContenidoHoja/Divisiones/ComentarioResp/Content/Texto2.text =str(numComentarios)
	$Hojas/ContenidoHoja/Divisiones/PuntuacionFinal/Content/Texto2.text =str(puntos)
	
	ProgresoPuntuacion.PUBLIS_CORRECTAS = []
	ProgresoPuntuacion.PUBLIS_INCORRECTAS = []
	ProgresoPuntuacion.COMENTARIOS_CORRECTOS = []
	ProgresoPuntuacion.COMENTARIOS_INCORRECTOS = []
	ProgresoPuntuacion.PUBLIS_DESCARTADAS = []
	ProgresoPuntuacion.PUBLIS_PUBLICADAS = []


func SALIR_DE_ESCENA():
	$FONDO.stop()
	await get_tree().create_timer(2).timeout

func _on_botonregresar_pressed() -> void:
	GameManager.CAMBIAR_DE_ESCENA(GameManager.ENUMESCENAS.MAINMENU,3)
