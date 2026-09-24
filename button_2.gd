extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(po)

func po():
	print("fuap debajo")
