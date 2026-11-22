extends CanvasLayer

const MIN_DB := -40.0

@onready var click: AudioStreamPlayer = $Click
@onready var barra: TextureProgressBar = $MusicaColumna/IconoMusica/TextureProgressBar

var habilitado := true

func _ready() -> void:
	#si no pongo esto depende del inspector e inicia en 0
	barra.max_value = 4
	barra.value = 4
	_aplicar()

func _input(event: InputEvent) -> void:
	if not habilitado:
		return
	if event.is_action_pressed("volumen_subir"):
		cambiar(1)
	elif event.is_action_pressed("volumen_bajar"):
		cambiar(-1)

func cambiar(delta: int) -> void:
	var anterior := barra.value
	barra.value += delta          # la barra ya respeta min y max
	if barra.value == anterior:
		return
	click.play()
	_aplicar()

func _aplicar() -> void:
	var idx := AudioServer.get_bus_index("Music")
	var v := barra.value / barra.max_value
	AudioServer.set_bus_volume_db(idx, MIN_DB * (1.0 - v))
	AudioServer.set_bus_mute(idx, barra.value == 0)

func mostrar() -> void:
	visible = true
	habilitado = true

func ocultar() -> void:
	visible = false
	habilitado = false
