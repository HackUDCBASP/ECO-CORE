extends Area3D

var current_player: Node3D = null
var can_interact := false
var exclamation_mark: Node3D = null
var dialog_active := false

@onready var exclamation_scene = preload("res://modelos/otros/E.glb")
@export var interact_action := "interact"
@export var dialogo_normal: String = "scanf"
@export var dialogo_hoguera: String = "hoguera"

signal dialog_started
signal dialog_ended

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		current_player = body
		can_interact = true
		show_exclamation()

func _on_body_exited(body: Node3D) -> void:
	if body == current_player:
		hide_exclamation()
		if dialog_active:
			end_dialog()
		current_player = null
		can_interact = false

func show_exclamation() -> void:
	if exclamation_mark == null and current_player != null:
		exclamation_mark = exclamation_scene.instantiate()
		current_player.add_child(exclamation_mark)
		exclamation_mark.position = Vector3(0, 2.0, 0)

func hide_exclamation() -> void:
	if exclamation_mark != null:
		exclamation_mark.queue_free()
		exclamation_mark = null

func _unhandled_input(event: InputEvent) -> void:
	if can_interact and not dialog_active and event.is_action_pressed(interact_action):
		start_dialog()

func start_dialog() -> void:
	if dialog_active or current_player == null:
		return
	
	dialog_active = true
	hide_exclamation()
	block_player_movement(true)
	
	# Elegir diálogo según si el jugador tiene las cerillas
	var dialogo_a_usar = dialogo_normal
	if tiene_cerillas():
		dialogo_a_usar = dialogo_hoguera
		consumir_cerillas()   # Quitar las cerillas después de usarlas
	
	dialog_started.emit()
	
	Dialogic.start(dialogo_a_usar)
	if not Dialogic.timeline_ended.is_connected(_on_dialog_ended):
		Dialogic.timeline_ended.connect(_on_dialog_ended)

func end_dialog() -> void:
	if not dialog_active:
		return
	
	dialog_active = false
	block_player_movement(false)
	
	if current_player != null and can_interact:
		show_exclamation()
	
	dialog_ended.emit()
	print("Dialog ended, movement restored.")
	
	if Dialogic.timeline_ended.is_connected(_on_dialog_ended):
		Dialogic.timeline_ended.disconnect(_on_dialog_ended)

func block_player_movement(block: bool) -> void:
	if current_player != null and current_player.has_method("set_movement_enabled"):
		current_player.set_movement_enabled(not block)
	elif current_player != null and current_player.has_node("MovementScript"):
		var movement_script = current_player.get_node("MovementScript")
		if movement_script != null:
			movement_script.set_process(not block)
			movement_script.set_physics_process(not block)
	else:
		if current_player != null:
			current_player.set_process(not block)
			current_player.set_physics_process(not block)

func _on_dialog_ended() -> void:
	end_dialog()

# ----- Funciones específicas para cerillas -----
func tiene_cerillas() -> bool:
	"""Devuelve true si el jugador tiene el nodo cerillas como hijo"""
	if current_player == null:
		return false
	# Buscamos el nodo por su nombre (asumimos que se llama "cerillas")
	return current_player.has_node("cerillas")

func consumir_cerillas() -> void:
	"""Elimina el nodo cerillas del jugador (se consumen al usarlas)"""
	if current_player == null:
		return
	var cerillas = current_player.get_node_or_null("cerillas")
	if cerillas:
		cerillas.queue_free()
