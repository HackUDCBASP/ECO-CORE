extends Node3D

var menu_escena = preload("res://escenas/menupausa.tscn")
var menu_instancia = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if menu_instancia == null:
			# Abrir menú de pausa
			menu_instancia = menu_escena.instantiate()
			add_child(menu_instancia)
			get_tree().paused = true
		else:
			# Cerrar menú de pausa
			menu_instancia.queue_free()
			menu_instancia = null
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
