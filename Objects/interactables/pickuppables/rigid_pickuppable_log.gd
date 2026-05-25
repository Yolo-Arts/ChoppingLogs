extends RigidBody3D
class_name PickuppableLog

@export var item_key : ItemConfig.Keys
var player_reference: Node3D = null
var _is_destroying: bool = false 

func _ready() -> void:
	reset_from_pool()

func _on_sleeping_state_changed() -> void:
	if sleeping:
		freeze = true

func start_interaction() -> void:
	if _is_destroying:
		return
		
	if sleeping_state_changed.is_connected(_on_sleeping_state_changed):
		sleeping_state_changed.disconnect(_on_sleeping_state_changed)
		
	player_reference = get_tree().get_first_node_in_group("player")
	EventSystem.INV_try_to_pickup_item.emit(item_key, destroy)

func destroy() -> void:
	if _is_destroying or not is_instance_valid(player_reference):
		ObjectPool.return_object(self)
		return
		
	_is_destroying = true

	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

	tween.tween_method(func(weight: float):
		if is_instance_valid(player_reference):
			var target_pos = player_reference.global_position + Vector3(0, 1.6, 0)
			global_position = global_position.lerp(target_pos, weight)
	, 0.0, 1.0, 0.8)
	
	tween.tween_property(self, "scale", Vector3(0.001, 0.001, 0.001), 0.8)

	tween.chain().tween_callback(func():
		ObjectPool.return_object(self)
	)

func reset_from_pool() -> void:
	_is_destroying = false 
	freeze = false
	sleeping = false
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	
	scale = Vector3.ONE  
	player_reference = null
	
	if not sleeping_state_changed.is_connected(_on_sleeping_state_changed):
		sleeping_state_changed.connect(_on_sleeping_state_changed)
