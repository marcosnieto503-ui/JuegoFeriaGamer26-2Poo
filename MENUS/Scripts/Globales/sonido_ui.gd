extends Node

@onready var hover: AudioStreamPlayer = get_node_or_null("Hover")
@onready var click: AudioStreamPlayer = get_node_or_null("Click")

func _ready() -> void:
	get_tree().node_added.connect(_on_node_added)
	print("HOVER: ",hover)

func _on_node_added(nodo: Node) -> void:
	if !nodo:
		push_error("Nodo null")
		return
	if nodo is BaseButton:
		nodo.ready.connect(func():
			if nodo.is_in_group("sonido_menu"):
				nodo.mouse_entered.connect(func(): hover.play())
				nodo.pressed.connect(func(): click.play())
		, CONNECT_ONE_SHOT)
