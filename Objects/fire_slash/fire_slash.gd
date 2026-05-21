extends Area3D

@export var speed := 20.0


func _ready() -> void:
	get_tree().create_timer(3.0, false).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	global_position += -global_transform.basis.z * speed * delta


func _on_area_entered(area: Area3D) -> void:
	if not area.has_method("take_hit"):
		return
	
	area.take_hit(10)
	#print(area.global_position)
	var hit_transform := Transform3D(Basis(), global_position)
	#print(hit_transform)
	EventSystem.SPA_spawn_vfx.emit(
			VFXConfig.get_vfx(area.hit_particles_key),
			hit_transform
		)
		
	var scene_to_spawn := VFXConfig.get_vfx(VFXConfig.Keys.HitNumbers)
	EventSystem.SPA_spawn_vfx.emit(scene_to_spawn, hit_transform, 10)
	
	queue_free() 


func _on_body_entered(_body: Node3D) -> void:
	queue_free()
