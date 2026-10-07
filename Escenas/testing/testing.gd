extends Node2D

enum test {
	LECTURA_DE_ARCHIVO_PUBLIS,
	TESTEO_CAJA_NOTIFICACION,
	TESTEO_IMAGEN_TAB,
	TESTEO_ESCENA2
}

@onready var textBox = $PanelContainer/VBoxContainer/RichTextLabel

@export var TEST = test.LECTURA_DE_ARCHIVO_PUBLIS

@onready var sprite2d = $TabContainer/PanelContainer/Control/Sprite2D
@onready var label = $TabContainer/PanelContainer/Control/RichTextLabel
var image = Image.load_from_file("res://NO BORRAR.jpg")
var textura = ImageTexture.create_from_image(image)
# Called when the node enters the scene tree for the first time.
var inst
func _ready() -> void:
	var pop = po.instantiate()   #poiopodod ----------------------------
	inst = pop.get_node(".")
	$".".add_child(pop)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var po = preload("res://Escenas/testing/test_2.tscn")
var d = false

func _on_button_button_down() -> void:
	match TEST:
		
		test.TESTEO_ESCENA2:
			print("po sieve")
			inst.position.x += 100
			
			
		
		test.TESTEO_CAJA_NOTIFICACION:
			if textBox.text != "fujap[ cambio de tama;o]":
				textBox.set_text("fujap[ cambio de tama;o]")
			else:
				textBox.set_text("fuiab segundo cambio de tama;o, sisisisiisisisim awdkmdpanmwdpo ap;wdmw")
			
		test.TESTEO_IMAGEN_TAB:
			pass
		
		test.LECTURA_DE_ARCHIVO_PUBLIS:
			 #---------------testeando la lectura correcta del archivo
			Utils.leer_archivo_publi()
			
			for publi in Utils.PUBLICACIONES:
				print("Text notificacion: ",publi.get_textoNoti())
				print("ID: ",publi._id)
				print("tipo: ",publi._tipo)
				print("TExto Publi: ",publi._textoPubli)
				print("#----------------------------------")
	
