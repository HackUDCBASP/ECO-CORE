extends Area3D

var current_player: Node3D = null
var can_interact := false
var exclamation_mark: Node3D = null
var stone_collected := false

@onready var exclamation_scene = preload("res://modelos/otros/E.glb")
@export var interact_action := "interact"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not stone_collected:
		current_player = body
		can_interact = true
		show_exclamation()

func _on_body_exited(body: Node3D) -> void:
	if body == current_player:
		hide_exclamation()
		current_player = null
		can_interact = false

func show_exclamation() -> void:
	if exclamation_mark == null and current_player != null:
		exclamation_mark = exclamation_scene.instantiate()
		current_player.add_child(exclamation_mark)
		exclamation_mark.position = Vector3(0, 1.5, 0)

func hide_exclamation() -> void:
	if exclamation_mark != null:
		exclamation_mark.queue_free()
		exclamation_mark = null

func _unhandled_input(event: InputEvent) -> void:
	if can_interact and not stone_collected and event.is_action_pressed(interact_action):
		recolectar_piedra()

func recolectar_piedra() -> void:
	if current_player == null:
		return
	
	stone_collected = true
	hide_exclamation()
	
	# Incrementar contador de piedras
	if not current_player.has_meta("piedras_count"):
		current_player.set_meta("piedras_count", 0)
	var nuevas_piedras = current_player.get_meta("piedras_count") + 1
	current_player.set_meta("piedras_count", nuevas_piedras)
	print("Piedra recolectada. Total: ", nuevas_piedras)
	
	# Buscamos el nodo hijo que representa la piedra en el mundo
	if has_node("pedras"):
		get_node("pedras").queue_free()
	elif has_node("pedras2"):
		get_node("pedras2").queue_free()
	
	can_interact = false
