extends Button

@onready var botoncito = $"../../CanvasLayer/BPequeño"
@onready var canvaP = $"../../CanvasLayer2"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	self.pressed.connect(canvapo)
	botoncito.pressed.connect(botoncito_)

func po():
	if (canvaP.get_layer() == 1):
		canvaP.set_layer(0)
	else:
		canvaP.set_layer(1)
		
func canvapo():
	if (canvaP.visible == true):
		canvaP.hide()
	else:
		canvaP.show()

func botoncito_():
	print("fuab arriba")
