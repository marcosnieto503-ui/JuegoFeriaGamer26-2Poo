extends Control



@export var CelCamara:Camera2D
@export var colorRectBlockeador:ColorRect
@export var canvaLayer:CanvasLayer
@export var fondoColor:ColorRect


@export var celPos = Vector2(1450,400)
@export var zoomIn = Vector2(2.9,2.9)
@export var duracionZoom:float = 0.3

var enMenu:bool = false

enum menusPosibles {
	FUERA,
	OPCIONES,
	DALTONISMO,
	SONIDO
}
var menuActual:menusPosibles = menusPosibles.FUERA

var defaultCamPos:Vector2
func _ready() -> void:
	fondoColor.color = Color()
	defaultCamPos = CelCamara.position
	colorRectBlockeador.hide()
	canvaLayer.hide()
	
	$OpcionesFiltroSeccion/OpcionesDaltonismo.select(GameSettings.filtroActual)
	ocultarOpciones()
	ocultarSeccionFiltro()
	ocultarSeccionSonido()

func _on_telefono_pressed() -> void:
	menuActual = menusPosibles.OPCIONES
	$"..".set_process(false)
	enMenu = true
	colorRectBlockeador.show()
	await acercarCamara()
	mostrarOpciones()
	fondoColor.color = Color(0.0, 0.157, 0.29, 1.0)
	canvaLayer.show()
	

func ocultarOpciones():
	$botonSonido.hide()
	$botonFiltros.hide()
func mostrarOpciones():
	$botonSonido.show()
	$botonFiltros.show()

var tween:Tween
func acercarCamara():
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(CelCamara,"position",celPos,duracionZoom).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(CelCamara,"zoom:x",zoomIn.x,duracionZoom).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(CelCamara,"zoom:y",zoomIn.y,duracionZoom).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

func alejarCamara():
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(CelCamara,"position",defaultCamPos,duracionZoom).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(CelCamara,"zoom:",Vector2(1,1),duracionZoom*2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(CelCamara,"zoom:y",1,duracionZoom).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished


func _on_boton_sonido_pressed() -> void:
	ocultarOpciones()
	menuActual = menusPosibles.SONIDO
	mostrarSeccionSonido()

func mostrarSeccionSonido():
	$OpcionesSonido.show()
func ocultarSeccionSonido():
	$OpcionesSonido.hide()

func _on_h_scroll_bar_value_changed(value: float) -> void:
	GameSettings.AsignarVolumen(value )


func _on_boton_filtros_pressed() -> void:
	ocultarOpciones()
	menuActual = menusPosibles.DALTONISMO
	mostrarSeccionFiltro()

func mostrarSeccionFiltro():
	$OpcionesFiltroSeccion.show()
func ocultarSeccionFiltro():
	$OpcionesFiltroSeccion.hide()


func _on_opciones_daltonismo_item_selected(index: int) -> void:
	GameSettings.AsignarFiltroDaltonismo(index as GameSettings.ENUM_FILTROS_DALTONISMO)


func _on_atras_pressed() -> void:
	match menuActual:
		menusPosibles.OPCIONES:
			pass
			salirTelefono()
		menusPosibles.DALTONISMO:
			menuActual = menusPosibles.OPCIONES
			ocultarSeccionFiltro()
			mostrarOpciones()
		menusPosibles.SONIDO:
			menuActual = menusPosibles.OPCIONES
			mostrarOpciones()
			ocultarSeccionSonido()

func salirTelefono():
	menuActual = menusPosibles.FUERA
	$"..".set_process(true)
	enMenu = false
	colorRectBlockeador.hide()
	ocultarOpciones()
	fondoColor.color = Color(0.0, 0.157, 0.29, 1.0)
	canvaLayer.hide()
	await alejarCamara()
