extends Node3D
class_name HittableObjectTemplate

@export var attributes : HittableObjectAttributes

@onready var current_health := attributes.max_health
@onready var item_spawn_points: Node3D = $ItemSpawnPoints

var tween: Tween
var base_scale: Vector3 = Vector3.ONE

#TODO:Add healing feedback?
func _on_hitbox_register_hit(damage) -> void:
	current_health -= damage
	
	if tween: tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(self, "scale", base_scale + Vector3(0.5, 0.5, 0.5), 0.1)
	tween.tween_property(self, "scale", base_scale, 0.1)
	
	
	if current_health <= 0:
		die()

func die() -> void:
	var scene_to_spawn := ItemConfig.get_pickuppable_item_scene(attributes.drop_item_key)
	
	for marker in item_spawn_points.get_children():
		EventSystem.SPA_spawn_scene.emit(scene_to_spawn, marker.global_transform)
	
	#queue_free()
	reset()
	ObjectPool.return_object(self)

func reset() -> void:
	current_health = attributes.max_health
	scale = base_scale
	if tween:
		tween.kill()
		tween = null

# TODO add a residue static body for tree stump
