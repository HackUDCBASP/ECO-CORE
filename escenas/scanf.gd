extends Area3D

var current_player: Node3D = null
var can_interact := false
var exclamation_mark: Node3D = null

# Hay que cambiarlo a una exclamación hecha por depu
@onready var exclamation_scene = preload("res://modelos/placeholderexclamation.tscn")

@export var interact_action := "interact"

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
	if can_interact and event.is_action_pressed(interact_action):
		start_dialog()

func start_dialog() -> void:
	OS.alert("HOLA")
	print("Dialogo que hay que cambiar con Dialogic")
