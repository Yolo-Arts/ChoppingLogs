extends Node3D

@onready var object_holder: Node3D = $ObjectHolder

func _enter_tree() -> void:
	EventSystem.SPA_spawn_vfx.connect(spawn_vfx)
	EventSystem.SPA_spawn_scene.connect(spawn_scene)

func spawn_scene(scene:PackedScene, tform:Transform3D, is_constructable := false) -> void:
	var object := scene.instantiate()
	var random_tform = tform
	random_tform = random_tform.rotated_local(Vector3.UP, deg_to_rad(randf_range(0, 360)))
	random_tform = random_tform.rotated_local(Vector3.RIGHT, deg_to_rad(randf_range(0, 360)))
	random_tform = random_tform.rotated_local(Vector3.FORWARD, deg_to_rad(randf_range(0, 360)))
	
	object_holder.add_child(object)
	object.global_transform = tform

func spawn_vfx(scene:PackedScene, tform:Transform3D, damage_text = null) -> void:
	var vfx := scene.instantiate()
	add_child(vfx)
	
	vfx.global_transform = tform
	
	if damage_text:
		vfx.label.text = str(damage_text)
		vfx.display_damage() 
	
	
	if vfx is GPUParticles3D:
		vfx.emitting = true
	
	get_tree().create_timer(2.0, false).timeout.connect(vfx.queue_free)
