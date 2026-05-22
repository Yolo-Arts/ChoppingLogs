extends RigidBody3D
class_name PickuppableLog
@export var item_key : ItemConfig.Keys

func _ready() -> void:
	sleeping_state_changed.connect(_on_sleeping_state_changed)

func _on_sleeping_state_changed() -> void:
	if sleeping:
		freeze = true

var player_reference: Node3D = null

func start_interaction() -> void:
	player_reference = get_tree().get_first_node_in_group("player")
	EventSystem.INV_try_to_pickup_item.emit(item_key, destroy)

func destroy() -> void:
	if not player_reference:
		ObjectPool.return_object(self)
		return

	var tween = create_tween().set_parallel(true)
	
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

	var target_position = player_reference.global_position + Vector3(0, 1.6, 0)

	tween.tween_property(self, "global_position", target_position, 0.8)
	tween.tween_property(self, "scale", Vector3(0.001, 0.001, 0.001), 0.8)

	tween.chain().tween_callback(func():
		ObjectPool.return_object(self)
	)
