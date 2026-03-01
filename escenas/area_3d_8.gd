extends Area3D

@onready var exclamation_scene = preload("res://modelos/otros/E.glb")
@onready var item_scene = preload("res://modelos/trash/papeles.glb")
@export var interact_action := "interact"

var player: Node3D
var can_interact := false
var collected := false
var exclamation: Node3D
var item_instance: Node3D

func _ready():
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)

func _on_enter(body):
	if body.is_in_group("player") and not collected:
		player = body
		can_interact = true
		if not exclamation:
			exclamation = exclamation_scene.instantiate()
			player.add_child(exclamation)
			exclamation.position = Vector3(0, 1.3, 0)

func _on_exit(body):
	if body == player:
		if exclamation:
			exclamation.queue_free()
			exclamation = null
		player = null
		can_interact = false

func _unhandled_input(event):
	if can_interact and not collected and event.is_action_pressed(interact_action):
		collected = true
		if exclamation:
			exclamation.queue_free()
			exclamation = null
		if player:
			item_instance = item_scene.instantiate()
			player.add_child(item_instance)
			item_instance.add_to_group("papeles")
			item_instance.position = Vector3(0, 1.5, 0)
		queue_free()
		print("Has recogido unos papeles")
