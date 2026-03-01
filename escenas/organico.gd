extends Area3D

@onready var exclamation_scene = preload("res://modelos/otros/E.glb")
@export var interact_action := "interact"

var player: Node3D = null
var exclamation: Node3D = null

func _ready():
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)

func _on_enter(body):
	if body.is_in_group("player"):
		player = body

func _on_exit(body):
	if body == player:
		player = null
		if exclamation:
			exclamation.queue_free()
			exclamation = null

func _process(delta):
	if player:
		var has_item = _player_has_item()
		if has_item and not exclamation:
			exclamation = exclamation_scene.instantiate()
			player.add_child(exclamation)
			exclamation.position = Vector3(0, 1.3, 0)
		elif not has_item and exclamation:
			exclamation.queue_free()
			exclamation = null

func _player_has_item() -> bool:
	for child in player.get_children():
		if child.is_in_group("manzana"):
			return true
	return false

func _unhandled_input(event):
	if player and event.is_action_pressed(interact_action):
		if _player_has_item():
			for child in player.get_children():
				if child.is_in_group("manzana"):
					child.queue_free()
					break
			print("Manzana depositada")
