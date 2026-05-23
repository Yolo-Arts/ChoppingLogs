extends CharacterBody3D

# --- Movement Settings ---
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# --- Camera Settings ---
const MOUSE_SENSITIVITY = 0.002
const TILT_LOWER_LIMIT = deg_to_rad(-80.0)
const TILT_UPPER_LIMIT = deg_to_rad(80.0)

# We need a reference to the camera to rotate it up/down
@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	# Capture the mouse so it doesn't leave the game window
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	# Handle mouse movement for looking around
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# 1. Rotate the whole player body left/right (Y axis)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		
		# 2. Rotate the camera up/down (X axis)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		
		# 3. Clamp the camera tilt so the player can't look upside down
		camera.rotation.x = clamp(camera.rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)

	# Optional: Release the mouse if the player presses Escape
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input direction
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# CHANGED: We use the camera's basis instead of the player's transform basis.
	# This ensures "moving forward" actually aligns with where the player is looking.
	var direction := (camera.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
