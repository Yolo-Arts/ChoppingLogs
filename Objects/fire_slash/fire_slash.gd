extends Area3D

@export var speed := 10.0

func _physics_process(delta: float) -> void:
	global_position += -global_transform.basis.z * speed * delta


func _on_body_entered(body: Node3D) -> void:
	if body is Player: 
		return
		
	
	queue_free() 
