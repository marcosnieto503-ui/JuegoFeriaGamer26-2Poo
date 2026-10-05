extends Control

@onready var anim: AnimationPlayer = $AnimationObjetos
@onready var anim_fade: AnimationPlayer = $AnimationColorR
func _ready() -> void:
	anim_fade.play("fade-out")
	await anim_fade.animation_finished

#Animaciones como de rebote al pasar el cursor entrada
func _on_laptop_mouse_entered() -> void:
	anim.play("animh_laptop")

func _on_telefono_mouse_entered() -> void:
	anim.play("animh_celular")

func _on_mouse_mouse_entered() -> void:
	anim.play("animh_mouse")

func _on_hojas_mouse_entered() -> void:
	anim.play("animh_hojas")
	
func _on_llaves_mouse_entered() -> void:
	anim.play("animh_llaves")

#Animaciones de salida al pasar el cursor, ya no esta en el boton xd
func _on_laptop_mouse_exited() -> void:
	anim.play_backwards("animh_laptop")

func _on_telefono_mouse_exited() -> void:
	anim.play_backwards("animh_celular")

func _on_mouse_mouse_exited() -> void:
	anim.play_backwards("animh_mouse")

func _on_hojas_mouse_exited() -> void:
	anim.play_backwards("animh_hojas")

func _on_llaves_mouse_exited() -> void:
	anim.play_backwards("animh_llaves")
	
func _on_laptop_pressed() -> void:
	print("presiono laptop")

func _on_telefono_pressed() -> void:
	print("presiono celular")

#Salir del juego pue
func _on_llaves_pressed() -> void:
	get_tree().quit()
