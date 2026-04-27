extends Node3D

func _enter_tree() -> void:
	EventSystem.SPA_spawn_vfx.connect(spawn_vfx)

func spawn_vfx(scene:PackedScene, tform:Transform3D) -> void:
	var vfx := scene.instantiate()
	vfx.global_transform = tform
	add_child(vfx)
	
	if vfx is GPUParticles3D:
		vfx.emitting = true
	
	get_tree().create_timer(2.0, false).timeout.connect(vfx.queue_free)
