extends equippable_weapon

@onready var hit_check_marker: Marker3D = $HitCheckMarker
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var axe_resource: AxeItemResource

func _ready() -> void:
	hit_check_marker.position.z = -axe_resource.range

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
		result.collider.take_hit(axe_resource)
		
		EventSystem.SPA_spawn_vfx.emit(
			VFXConfig.get_vfx(result.collider.hit_particles_key),
			Transform3D(Basis(), result.position)
		)

func try_to_use() -> void:
	if animation_player.is_playing():
		return
	
	animation_player.play("use_item")
