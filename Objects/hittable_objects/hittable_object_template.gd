extends Node3D

@export var attributes : HittableObjectAttributes

@onready var current_health := attributes.max_health
@onready var item_spawn_points: Node3D = $ItemSpawnPoints

func _on_hitbox_register_hit(weapon_item_resource) -> void:
	
	current_health -= weapon_item_resource.damage
	
	if current_health <= 0:
		die()

# TODO ADD spawn for logs to drop.
func die() -> void:
	for child in get_children():
		queue_free()

# TODO add a residue static body for tree stump
