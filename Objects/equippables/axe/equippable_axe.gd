extends equippable_weapon

@export var player_stats: PlayerStats

@onready var hit_check_marker: Marker3D = $HitCheckMarker
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var axe_resource: AxeItemResource

func _ready() -> void:
	hit_check_marker.position.z = -player_stats.axe_range
	EventSystem.AXE_update_hit_marker_position.connect(update_hit_marker_position)

func update_hit_marker_position():
	hit_check_marker.position.z = -player_stats.axe_range

# This function calculates the damage output of the player.
func player_damage_calculation() -> Damage:
	# Calculate crit damage
	var crit_damage = 0;
	var crit = false
	var base_damage = axe_resource.damage + player_stats.axe_damage_bonus						# calculate axe base + bonus damage
	if (randf_range(0.0, 100.0) <= player_stats.axe_crit_chance):								# check crit damage chance
		crit = true
		#crit_damage = axe_resource.damage * (player_stats.axe_crit_damage/100.0)				# calculate crit damage 
		crit_damage = base_damage * (player_stats.axe_crit_damage / 100.0)
	var final_damage = (base_damage * player_stats.axe_damage_mult_bonus) + crit_damage
	print("Final Damage: ", final_damage)
	return Damage.new(final_damage, crit)		# return damage object.
	# return base_damage * player_stats.axe_damage_mult_bonus + crit_damage	# return fully calculated damage

func check_hit() -> void:
	var space_state := get_world_3d().direct_space_state
	var ray_query_params := PhysicsRayQueryParameters3D.new()
	ray_query_params.collide_with_areas = true
	ray_query_params.collide_with_bodies = false
	ray_query_params.collision_mask = (1 << 4) # hitbox physics layer (bit shifting syntax)
	#ray_query_params.collision_mask = 16 # hitbox physics layer (normal syntax)
	ray_query_params.from = global_position
	ray_query_params.to = hit_check_marker.global_position
	
	var result := space_state.intersect_ray(ray_query_params)
	if not result.is_empty():
		if not result.collider.has_method("take_hit"):
			return
		
		# Calculate player damage.
		var damage_calculated : Damage
		damage_calculated = player_damage_calculation()
		result.collider.take_hit(damage_calculated.dmg)

		EventSystem.SPA_spawn_vfx.emit(
			VFXConfig.get_vfx(result.collider.hit_particles_key),
			Transform3D(Basis(), result.position)
		)
		
		var scene_to_spawn := VFXConfig.get_vfx(VFXConfig.Keys.HitNumbers)
		EventSystem.SPA_spawn_vfx.emit(scene_to_spawn, Transform3D(Basis(), result.position), damage_calculated)

func try_to_use() -> void:
	if animation_player.is_playing():
		return
	
	animation_player.speed_scale = 1 + player_stats.axe_speed_bonus
	animation_player.play("use_item")
