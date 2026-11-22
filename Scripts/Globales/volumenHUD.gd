extends CanvasLayer

const MIN_DB := -40.0

@onready var click: AudioStreamPlayer = $Click
@onready var barra: TextureProgressBar = $MusicaColumna/Barras

func _ready() -> void:
	_aplicar(barra.value)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("volumen_subir"):
		barra.value += 1
	elif event.is_action_pressed("volumen_bajar"):
		barra.value -= 1

func _on_barras_value_changed(value: float) -> void:
	click.play()
	_aplicar(value)
	
func _aplicar(value: float) -> void:
	var idx := AudioServer.get_bus_index("Music")
	var v := barra.value / barra.max_value
	#linear_to_db = convierte 1 a 0 a DB
	AudioServer.set_bus_volume_db(idx, linear_to_db(v))
	AudioServer.set_bus_mute(idx, value == 0)


func mostrar() -> void:
	visible = true
	set_process_input(true)

func ocultar() -> void:
	visible = false
	set_process_input(false)
