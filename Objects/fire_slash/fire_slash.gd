extends Area3D

@export var speed := 20.0
@export var damage := 50
@export var pierce_count := 1

var hit_areas := {} 

func _ready() -> void:
	get_tree().create_timer(3.0, false).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	global_position += -global_transform.basis.z * speed * delta


func _on_area_entered(area: Area3D) -> void:
	if not area.has_method("take_hit"):
		return
	
	if area in hit_areas:
		return
	
	hit_areas[area] = true
	
	area.take_hit(damage)
	
	var hit_transform := Transform3D(Basis(), global_position)
	EventSystem.SPA_spawn_vfx.emit(
			VFXConfig.get_vfx(area.hit_particles_key),
			hit_transform
		)
		
	var scene_to_spawn := VFXConfig.get_vfx(VFXConfig.Keys.HitNumbers)
	EventSystem.SPA_spawn_vfx.emit(scene_to_spawn, hit_transform, damage)
	pierce_count -= 1
	if pierce_count <= 0:
		queue_free() 


func _on_body_entered(_body: Node3D) -> void:
	queue_free()
