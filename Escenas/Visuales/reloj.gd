extends RichTextLabel

signal pausado
signal reanudado

@export var parpadear_al_terminar: bool = true
@export var intervalo_parpadeo: float = 0.5

var tween: Tween
var tween_parpadeo: Tween

var saltos_de_diez: bool = false
const PASO_MINUTOS := 10

var en_pausa := false
var _reloj_activo := false    #el tween de la hora funcionando
var _parpadeando := false 

func correr_reloj(h_ini: int, m_ini: int, h_fin: int, m_fin: int, duracion: float, saltosDeDiez: bool = false):
	detener_parpadeo()
	en_pausa = false

	saltos_de_diez = saltosDeDiez
	var inicio := h_ini * 60 + m_ini
	var fin := h_fin * 60 + m_fin
	if fin <= inicio:
		fin += 24 * 60    #si cruza medianoche

	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_method(_mostrar_hora, float(inicio), float(fin), duracion)
	tween.finished.connect(_al_terminar_reloj.bind(h_fin, m_fin))
	_reloj_activo = true

func _mostrar_hora(minutos_totales: float):
	var paso := PASO_MINUTOS if saltos_de_diez else 1
	var total := int(minutos_totales / paso) * paso
	var h := (total / 60) % 24
	var m := total % 60
	text = "%02d:%02d" % [h, m]

func _al_terminar_reloj(h: int, m: int):
	_reloj_activo = false
	text = "%02d:%02d" % [h, m]   
	if parpadear_al_terminar:
		iniciar_parpadeo()



func iniciar_parpadeo():
	detener_parpadeo()
	_parpadeando = true
	tween_parpadeo = create_tween().set_loops()
	tween_parpadeo.tween_callback(hide)
	tween_parpadeo.tween_interval(intervalo_parpadeo)
	tween_parpadeo.tween_callback(show)
	tween_parpadeo.tween_interval(intervalo_parpadeo)

func detener_parpadeo():
	_parpadeando = false
	if tween_parpadeo:
		tween_parpadeo.kill()
	show()




func pausar():
	if en_pausa or not (_reloj_activo or _parpadeando):
		return
	en_pausa = true
	if _reloj_activo and tween and tween.is_valid():
		tween.pause()
	if _parpadeando and tween_parpadeo and tween_parpadeo.is_valid():
		tween_parpadeo.pause()
	pausado.emit()

func reanudar():
	if not en_pausa:
		return
	en_pausa = false
	if _reloj_activo and tween and tween.is_valid():
		tween.play()
	if _parpadeando and tween_parpadeo and tween_parpadeo.is_valid():
		tween_parpadeo.play()
	reanudado.emit()

func alternar_pausa():
	if en_pausa:
		reanudar()
	else:
		pausar()
