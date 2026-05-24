extends Bulletin

@onready var upgrade_name: Label = %UpgradeName
@onready var upgrade_description: Label = %UpgradeDescription
@onready var upgrade_level: Label = %UpgradeLevel
@onready var upgrade_currency: TextureRect = %UpgradeCurrency
@onready var upgrade_cost: Label = %UpgradeCost

var tracked_node: SkillNode = null
var _flipped: bool = false 

func initialize(_extra_arg = null) -> void:
	if _extra_arg is SkillNode:
		tracked_node = _extra_arg
		
		if not is_node_ready():
			await ready
		
		setup_tooltip_content()
		
		update_position()
		animate_entrance()

func _process(_delta: float) -> void:
	update_position()
	update_dynamic_content()

func setup_tooltip_content() -> void:
	if is_instance_valid(tracked_node):
		upgrade_name.text = tracked_node.upgrade_name
		upgrade_description.text = tracked_node.description
		
		update_dynamic_content()

func update_dynamic_content() -> void:
	if is_instance_valid(tracked_node):
		upgrade_level.text = "Level: %d / %d" % [tracked_node.level, tracked_node.max_level]
		
		if tracked_node.level >= tracked_node.max_level:
			upgrade_cost.text = "MAX"
		else:
			var calculated_cost = tracked_node.upgrade_cost * pow(tracked_node.price_increase_mult_per_level, tracked_node.level)
			upgrade_cost.text = str(int(calculated_cost))

func update_position() -> void:
	if is_instance_valid(tracked_node) and tracked_node.is_visible_in_tree():
		var button_pos: Vector2 = tracked_node.global_position
		var button_size: Vector2 = tracked_node.size
		
		var ideal_x = button_pos.x + (button_size.x / 2) - (size.x / 2)
		var ideal_y = button_pos.y - size.y - 15
		var viewport_size: Vector2 = get_viewport_rect().size
		var margin: float = 8.0
		var final_y: float

		if ideal_y < margin:
			final_y = button_pos.y + button_size.y + 15
			_flipped = true
		else:
			final_y = ideal_y
			_flipped = false

		var final_x: float = clamp(ideal_x, margin, viewport_size.x - size.x - margin)
		global_position = Vector2(final_x, final_y)

func animate_entrance() -> void:
	pivot_offset = Vector2(size.x / 2, size.y if not _flipped else 0.0)
	scale = Vector2.ZERO
	
	var juice_tween = create_tween()
	juice_tween.set_parallel(false)
	
	var stretch_y = 1.4 
	
	juice_tween.tween_property(self, "scale", Vector2(0.7, stretch_y), 0.12)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		
	juice_tween.tween_property(self, "scale", Vector2(1.15, 0.85), 0.08)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		
	juice_tween.tween_property(self, "scale", Vector2(0.95, 1.05), 0.06)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		
	juice_tween.tween_property(self, "scale", Vector2.ONE, 0.06)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

func animate_exit() -> void:
	set_process(false)
	
	pivot_offset = Vector2(size.x / 2, size.y if not _flipped else 0.0)
	
	var exit_tween = create_tween()
	exit_tween.set_parallel(false)
	
	exit_tween.tween_property(self, "scale", Vector2(1.2, 0.6), 0.08)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	exit_tween.tween_property(self, "scale", Vector2.ZERO, 0.1)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
		
	exit_tween.tween_callback(queue_free)
