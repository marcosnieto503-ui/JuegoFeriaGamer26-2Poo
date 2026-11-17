extends RichTextLabel

@export var parpadear_al_terminar:bool = true
@export var intervalo_parpadeo: float = 0.5  
var tween: Tween

var saltos_de_diez: bool = false 
const PASO_MINUTOS := 10

func _ready():
	pass

func correr_reloj(h_ini: int, m_ini: int, h_fin: int, m_fin: int, duracion: float,saltosDeDiez:bool = false):
	detener_parpadeo()
	
	saltos_de_diez = saltosDeDiez
	var inicio := h_ini * 60 + m_ini
	var fin := h_fin * 60 + m_fin
	if fin <= inicio:
		fin += 24 * 60        # si cruza medianoche (22:00 → 02:00)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_method(_mostrar_hora, float(inicio), float(fin), duracion)
	tween.finished.connect(_al_terminar_reloj.bind(h_fin, m_fin))

func _mostrar_hora(minutos_totales: float):
	var paso := PASO_MINUTOS if saltos_de_diez else 1
	var total := int(minutos_totales / paso) * paso
	var h := (total / 60) % 24
	var m := total % 60
	text = "%02d:%02d" % [h, m]


func _al_terminar_reloj(h: int, m: int):
	text = "%02d:%02d" % [h, m]   # muestra la hora final exacta
	if parpadear_al_terminar:
		iniciar_parpadeo()

var tween_parpadeo: Tween

func iniciar_parpadeo():
	detener_parpadeo()
	tween_parpadeo = create_tween().set_loops()   # bucle infinito
	tween_parpadeo.tween_callback(hide)
	tween_parpadeo.tween_interval(intervalo_parpadeo)
	tween_parpadeo.tween_callback(show)
	tween_parpadeo.tween_interval(intervalo_parpadeo)

func detener_parpadeo():
	if tween_parpadeo:
		tween_parpadeo.kill()
	show()   # lo deja visible
