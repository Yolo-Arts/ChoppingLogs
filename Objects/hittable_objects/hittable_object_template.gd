extends Node3D

@export var attributes : HittableObjectAttributes

@onready var current_health := attributes.max_health
@onready var item_spawn_points: Node3D = $ItemSpawnPoints

func _on_hitbox_register_hit(weapon_item_resource) -> void:
	current_health -= weapon_item_resource.damage
	print(current_health)
	
	if current_health <= 0:
		die()

# TODO ADD spawn for logs to drop.
func die() -> void:
	var scene_to_spawn := ItemConfig.get_pickuppable_item_scene(attributes.drop_item_key)
	
	for marker in item_spawn_points.get_children():
		EventSystem.SPA_spawn_scene.emit(scene_to_spawn, marker.global_transform)
	
	queue_free()

# TODO add a residue static body for tree stump
