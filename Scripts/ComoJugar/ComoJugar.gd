extends Control

var paginas = [
	{ "imagen": "res://Assets/ComoJugar/agarrarcelular.jpeg", "texto": "con este boton puedes cambiar\n de la laptop a el celular", "pos": Vector2(750, 800), "foco": Vector2(1700, 850), "radio": 0.12, },
	{ "imagen": "res://Assets/ComoJugar/agarrarlaptop.jpeg", "texto": "y con este regresas a la laptop", "pos": Vector2(250, 500), "foco": Vector2(700, 750), "radio": 0.15, },
	{ "imagen": "res://Assets/ComoJugar/publicarOdescartar.jpeg", "texto": "si crees que una publicacion es apropiada y cumple su formato,\n puedes publicarla", "pos": Vector2(650, 400), "foco": Vector2(1200, 670), "radio": 0.06, },
	{ "imagen": "res://Assets/ComoJugar/tiposdedescartes.jpeg", "texto": "si una publicacion no cumple algun requisito,\n puedes descartarla diciendo el motivo del descarte", "pos": Vector2(350,300), "foco": Vector2(770, 700), "radio": 0.17, },
	{ "imagen": "res://Assets/ComoJugar/respondercomentarios.jpeg", "texto": "por ultimo, puedes decidir contestar o no\n a ciertos comentarios\n en las publicaciones que hayas aprobado","pos": Vector2(50, 250), "foco": Vector2(1150, 550), "radio": 0.2, },
]

var indice = 0

@export_file("*.tscn") var escena_anterior: String = "res://Escenas/Menu/Menu.tscn"

@onready var imagen = $Fondo
@onready var texto = $texto
@onready var oscuro = $oscuro

func _ready():
	$Alante.pressed.connect(siguiente)
	$Atras.pressed.connect(anterior)
	mostrar()

func mostrar():
	var p = paginas[indice]
	imagen.texture = load(paginas[indice]["imagen"])
	texto.text = p["texto"]
	texto.size = p.get("tam", Vector2(900, 250))
	texto.position = p["pos"]
	
	var mat = oscuro.material as ShaderMaterial
	if p.has("foco"):
		oscuro.visible = true
		mat.set_shader_parameter("centro", p["foco"] / Vector2(1920, 1080))
		mat.set_shader_parameter("radio", p.get("radio", 0.15))
	else:
		oscuro.visible = false

func siguiente():
	indice = (indice + 1) % paginas.size()
	mostrar()

func anterior():
	indice = (indice - 1 + paginas.size()) % paginas.size()
	mostrar()

func _on_salir_pressed() -> void:
	Transicion.cambiarEscena(escena_anterior)
