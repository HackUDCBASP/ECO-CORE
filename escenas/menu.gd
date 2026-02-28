extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_close_menu_pressed():
	# Al cerrar el menú, volvemos a capturar el ratón para el juego
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free() # O esconder el menú

func _on_jugar_pressed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free() # Elimina el menú completamente


func _on_salir_pressed() -> void:
	get_tree().quit()
