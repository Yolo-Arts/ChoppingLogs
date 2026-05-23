extends Bulletin

var tracked_node: SkillNode = null

func initialize(_extra_arg = null) -> void:
	if _extra_arg is SkillNode:
		tracked_node = _extra_arg
		
		if not is_node_ready():
			await ready
		
		update_position()
		animate_entrance()

func _process(_delta: float) -> void:
	update_position()

func update_position() -> void:
	if is_instance_valid(tracked_node) and tracked_node.is_visible_in_tree():
		var button_pos: Vector2 = tracked_node.global_position
		var button_size: Vector2 = tracked_node.size
		
		global_position.x = button_pos.x + (button_size.x / 2) - (size.x / 2)
		global_position.y = button_pos.y - size.y - 15

func animate_entrance() -> void:
	pivot_offset = Vector2(size.x / 2, size.y)
	scale = Vector2.ZERO
	
	var juice_tween = create_tween()
	juice_tween.set_parallel(false) 
	
	juice_tween.tween_property(self, "scale", Vector2(0.7, 1.4), 0.12)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	juice_tween.tween_property(self, "scale", Vector2(1.15, 0.85), 0.08)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT)
		
	juice_tween.tween_property(self, "scale", Vector2(0.95, 1.05), 0.06)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT)
		
	juice_tween.tween_property(self, "scale", Vector2.ONE, 0.06)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT)

func animate_exit() -> void:
	set_process(false) 
	
	pivot_offset = Vector2(size.x / 2, size.y)
	
	var exit_tween = create_tween()
	exit_tween.set_parallel(false)
	
	exit_tween.tween_property(self, "scale", Vector2(1.2, 0.6), 0.08)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	exit_tween.tween_property(self, "scale", Vector2.ZERO, 0.1)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
		
	exit_tween.tween_callback(queue_free)
