extends CharacterBody3D
class_name Player

@export var player_stats: PlayerStats
# TODO move stats into player_stats
@export var jump_velocity := 10.0
# max jump velocity will be 25
@export var gravity := 0.5
@export var mouse_sensitivty := 0.005

@onready var interaction_ray_cast: RayCast3D = %InteractionRayCast
@onready var weapon_handler: Node3D = %WeaponHandler
@onready var discard_marker: Marker3D = $DiscardMarker

@onready var fire_slash: PackedScene = preload("res://Objects/fire_slash/fire_slash.tscn")
@onready var can_fire_slash: bool = true

@export var acceleration := 10.0
@export var air_acceleration := 40.0
@export var friction := 10.0
@onready var head: CameraController = %Head

@export var log_collection_detection: CollisionShape3D = null
var log_collection_shape: CylinderShape3D = null
var log_collection_radius_eventsystem: float = 0;

func _ready() -> void:
	print("Player is ready")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventSystem.HUD_show_hud.emit()
	EventSystem.PLA_freeze_player.connect(set_freeze.bind(true))
	EventSystem.PLA_unfreeze_player.connect(set_freeze.bind(false))
	EventSystem.SPA_send_spawn_scene_data.connect(spawn_discarded_item)
	EventSystem.UPG_upgrade_updated.connect(
		func(upgrade_key: UpgradeConfig.Keys, _new_level: int): 
			if upgrade_key == UpgradeConfig.Keys.SprintStamina:
				_update_stamina()
			)
	_update_stamina()

	# Get the shape of the log collecting area3d.
	if log_collection_detection:
		log_collection_shape = log_collection_detection.shape as CylinderShape3D

	# EventSystem version of increasing log collection radius
	EventSystem.UPG_increase_pickup_radius.connect(increase_pickup_radius)

func set_freeze(freeze: bool) -> void:
	set_process(!freeze)
	set_physics_process(!freeze)
	set_process_unhandled_key_input(!freeze)
	set_process_input(!freeze)

func _physics_process(delta: float) -> void:
	move(delta)
	
	# TODO Add auto click upgrade -> Holding left click vs spamming left click.
	if Input.is_action_pressed("left_click"):
		weapon_handler.try_to_use_item()
	
		if player_stats.unlocked_fire_slash:
			if can_fire_slash:
				shoot_fire_slash()

func _process(_delta: float) -> void:
	interaction_ray_cast.check_interaction()
	# set pickup radius
	if log_collection_shape: #NOTE: This is less than ideal since it checks every tick, but it should work.
		log_collection_shape.radius = player_stats.pickup_radius + log_collection_radius_eventsystem

var was_on_floor: bool = true

func move(delta: float) -> void:
	var is_on_ground := is_on_floor()
	
	if was_on_floor and not is_on_ground:
		head.play_tilt(head.tilt_up, 0.1, 0.5)
	elif not was_on_floor and is_on_ground:
		head.play_tilt(head.tilt_down, 0.1, 0.2)
		
	was_on_floor = is_on_ground
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	if not is_on_floor():
		velocity.y -= gravity

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var is_sprinting := Input.is_action_pressed("sprint")
	var base_speed := _handle_sprinting(delta) if is_sprinting else player_stats.normal_speed
	var target_speed := base_speed * player_stats.player_speed_with_weight_modifier

	if is_on_floor():
		if direction.length() > 0:
			velocity.x = lerp(velocity.x, direction.x * target_speed, acceleration * delta)
			velocity.z = lerp(velocity.z, direction.z * target_speed, acceleration * delta)
		else:
			velocity.x = lerp(velocity.x, 0.0, friction * delta)
			velocity.z = lerp(velocity.z, 0.0, friction * delta)
	else:
		var current_horizontal_speed := Vector2(velocity.x, velocity.z).length()
		var air_speed_cap = max(current_horizontal_speed, target_speed)
		if direction.length() > 0:
			velocity.x += direction.x * air_acceleration * delta
			velocity.z += direction.z * air_acceleration * delta
			var horizontal := Vector2(velocity.x, velocity.z).limit_length(air_speed_cap)
			velocity.x = horizontal.x
			velocity.z = horizontal.y
	move_and_slide()
	stamina_regen(delta)

#region Sprinting
func _update_stamina() -> void:
	cur_stamina = player_stats.max_sprint_stamina
	EventSystem.HUD_update_stamina.emit(player_stats.max_sprint_stamina, true)
	EventSystem.HUD_update_stamina.emit(cur_stamina)


var cur_stamina: float = -1
var stamina_drained: bool = false
func _handle_sprinting(delta: float) -> float:
	if stamina_drained:
		return player_stats.normal_speed
		
	cur_stamina -= delta
	if cur_stamina <= 0:
		cur_stamina = 0
		stamina_drained = true
	EventSystem.HUD_update_stamina.emit(cur_stamina)
	return player_stats.sprint_speed
		
const STAMINA_RECHARGE_TIME: float = 5.0
func stamina_regen(delta: float) -> void:
	if !stamina_drained:
		return
	var stamina_regen_speed: float = player_stats.max_sprint_stamina / STAMINA_RECHARGE_TIME
	cur_stamina = clampf(cur_stamina + (stamina_regen_speed * delta), 0, player_stats.max_sprint_stamina)
	EventSystem.HUD_update_stamina.emit(cur_stamina)
	if cur_stamina == player_stats.max_sprint_stamina:
		stamina_drained = false
#endregion Sprinting

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivty)
		head.look_around(event.relative)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		#Globals.open_pause_menu()
		if EventSystem.is_transitioning == false:
			EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.PauseMenu)
	
	#if event.is_action_pressed("open_inventory"):
		#EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.Inventory)
		#EventSystem.WEI_ask_update_weight_visual.emit()

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
	var damage_calculated : Damage = fire_slash_damage_calculation()
	
	#projectile.damage = player_stats.fire_slash_damage
	projectile.damage = damage_calculated
	projectile.pierce_count = player_stats.fire_slash_pierce_count
	for child in projectile.get_children():
		child.rotate_object_local(Vector3.RIGHT, PI)
	can_fire_slash = false
	reset_fire_slash_cooldown()

func reset_fire_slash_cooldown():
	get_tree().create_timer(max(player_stats.fire_slash_cooldown, 0.3), false).timeout.connect(func(): can_fire_slash = true)

func fire_slash_damage_calculation() -> Damage:
	# Calculate crit damage
	var crit_damage = 0;
	var crit = false
	if (randf_range(0.0, 100.0) <= player_stats.axe_crit_chance):								# check crit damage chance
		crit = true
		crit_damage = player_stats.fire_slash_damage * (player_stats.axe_crit_damage/100.0)		# calculate crit damage 
	var base_damage = player_stats.fire_slash_damage											# calculate axe base 
	return Damage.new(base_damage * player_stats.axe_damage_mult_bonus + crit_damage, crit)		# return damage object.

func increase_pickup_radius(increase_amount: float):
	if log_collection_shape:
		print("Increased pickup radius by 0.5")
		log_collection_radius_eventsystem += increase_amount