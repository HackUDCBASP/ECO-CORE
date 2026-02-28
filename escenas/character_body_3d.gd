extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var camera = $SpringArm3D/Camera3D

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Input
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# dirección relativa a la cámara
	var cam_basis = camera.global_transform.basis
	var forward = -cam_basis.z  # Hacia donde mira la cámara
	var right = cam_basis.x

	#aplanamos los vectores para que el personaje no vuele/se hunda
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	var direction = (right * input_dir.x + forward * -input_dir.y)

	if direction.length() > 0.1:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
