extends CharacterBody3D
class_name Player

@export var player_stats: PlayerStats
# TODO move stats into player_stats
@export var jump_velocity := 4.0
@export var gravity := 0.2
@export var mouse_sensitivty := 0.005

@onready var head: Node3D = $Head
@onready var interaction_ray_cast: RayCast3D = %InteractionRayCast
@onready var weapon_handler: Node3D = %WeaponHandler
@onready var discard_marker: Marker3D = $DiscardMarker

@onready var fire_slash: PackedScene = preload("res://Objects/fire_slash/fire_slash.tscn")
@onready var can_fire_slash: bool = true

func _ready() -> void:
	print("Player is ready")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventSystem.HUD_show_hud.emit()
	EventSystem.PLA_freeze_player.connect(set_freeze.bind(true))
	EventSystem.PLA_unfreeze_player.connect(set_freeze.bind(false))
	EventSystem.SPA_send_spawn_scene_data.connect(spawn_discarded_item)

func set_freeze(freeze: bool) -> void:
	set_process(!freeze)
	set_physics_process(!freeze)
	set_process_unhandled_key_input(!freeze)
	set_process_input(!freeze)

func _physics_process(delta: float) -> void:
	move()
	
	# TODO Add auto click upgrade -> Holding left click vs spamming left click.
	if Input.is_action_pressed("left_click"):
		weapon_handler.try_to_use_item()
	
		if player_stats.unlocked_fire_slash:
			if can_fire_slash:
				shoot_fire_slash()

func _process(delta: float) -> void:
	interaction_ray_cast.check_interaction()

func move() -> void:
	var is_sprinting: bool
	
	if is_on_floor():
		is_sprinting = Input.is_action_pressed("sprint")
		
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
	else:
		velocity.y -= gravity
		is_sprinting = false
	
	var base_speed := player_stats.normal_speed if not is_sprinting else player_stats.sprint_speed
	var final_speed = base_speed * player_stats.player_speed_with_weight_modifier
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	
	var direction :=  transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	
	velocity.x = direction.x * final_speed
	velocity.z = direction.z * final_speed
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_around(event.relative)

func look_around(relative: Vector2) -> void:
	rotate_y(-relative.x * mouse_sensitivty)
	head.rotate_x(-relative.y * mouse_sensitivty)
	head.rotation_degrees.x = clampf(head.rotation_degrees.x, -90, 90)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		#Globals.open_pause_menu()
		if EventSystem.is_transitioning == false:
			EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.PauseMenu)
	
	if event.is_action_pressed("open_inventory"):
		EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.Inventory)
		EventSystem.WEI_ask_update_weight_visual.emit()

func spawn_discarded_item(scene: PackedScene):
	EventSystem.SPA_spawn_scene.emit(scene, discard_marker.global_transform)

func _exit_tree() -> void:
	EventSystem.HUD_hide_hud.emit()


# For automatic log pickups
# TODO Check if there are logs inside this area when the sell happens.
func _on_log_collection_area_body_entered(body: Node3D) -> void:
	if body.has_method("start_interaction"):
		body.start_interaction()

func shoot_fire_slash():
	var projectile = fire_slash.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = head.global_position
	projectile.global_transform = head.global_transform
	projectile.damage = player_stats.fire_slash_damage
	projectile.pierce_count = player_stats.fire_slash_pierce_count
	for child in projectile.get_children():
		child.rotate_object_local(Vector3.RIGHT, PI)
	can_fire_slash = false
	reset_fire_slash_cooldown()

func reset_fire_slash_cooldown():
	get_tree().create_timer(max(player_stats.fire_slash_cooldown, 0.3), false).timeout.connect(func(): can_fire_slash = true)
