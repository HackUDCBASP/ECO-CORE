extends Area3D

@export var interact_action := "interact"
@export var head_offset := Vector3(0, 2.0, 0)

@onready var exclamation_scene = preload("res://modelos/otros/E.glb")

var current_player: Node3D = null
var can_interact := false
var exclamation_mark: Node3D = null
var tiene_suficientes_piedras := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if current_player != null:
		actualizar_estado_interaccion()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		current_player = body
		actualizar_estado_interaccion()

func _on_body_exited(body: Node3D) -> void:
	if body == current_player:
		limpiar_interaccion()

func actualizar_estado_interaccion() -> void:
	if current_player == null:
		return

	if not current_player.has_meta("piedras_count"):
		current_player.set_meta("piedras_count", 0)

	var piedras_actuales = current_player.get_meta("piedras_count")
	tiene_suficientes_piedras = piedras_actuales >= 2

	if tiene_suficientes_piedras:
		can_interact = true
		mostrar_exclamacion()
	else:
		can_interact = false
		ocultar_exclamacion()

func mostrar_exclamacion() -> void:
	if exclamation_mark == null and current_player != null:
		exclamation_mark = exclamation_scene.instantiate()
		current_player.add_child(exclamation_mark)
		exclamation_mark.position = head_offset
		exclamation_mark.scale = Vector3(0.5, 0.5, 0.5)

func ocultar_exclamacion() -> void:
	if exclamation_mark != null:
		exclamation_mark.queue_free()
		exclamation_mark = null

func limpiar_interaccion() -> void:
	ocultar_exclamacion()
	current_player = null
	can_interact = false
	tiene_suficientes_piedras = false

func _unhandled_input(event: InputEvent) -> void:
	if can_interact and event.is_action_pressed(interact_action):
		interactuar()

func interactuar() -> void:
	if current_player == null:
		return

	var piedras_actuales = current_player.get_meta("piedras_count")

	if piedras_actuales >= 2:
		current_player.set_meta("piedras_count", piedras_actuales - 2)
		print("Hoguera completada. Piedras restantes:", piedras_actuales - 2)

		if has_node("hoguerasinpedras"):
			$hoguerasinpedras.visible = false
		if has_node("hogueracompleta"):
			$hogueracompleta.visible = true

		can_interact = false
		tiene_suficientes_piedras = false
		ocultar_exclamacion()
