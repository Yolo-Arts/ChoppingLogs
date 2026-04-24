extends Node

@export var weight := 0
@export var max_weight := 5

#var is_max_weight: bool = false

func _ready() -> void:
	EventSystem.WEI_weight_changed.connect(update_weight)
	EventSystem.WEI_ask_update_weight_visual.connect(ask_update_weight_visual)
	EventSystem.WEI_check_if_weight_will_be_maxed.connect(check_if_weight_will_be_maxed)

func update_weight(weight_changed: int) -> void:
	weight += weight_changed
	check_if_weight_max()
	EventSystem.WEI_update_weight_visual.emit(weight, max_weight)

func ask_update_weight_visual():
	EventSystem.WEI_update_weight_visual.emit(weight, max_weight)

func check_if_weight_max() -> void:
	print("Weight is :", weight)
	if weight >= max_weight:
		print("Emitted")
		EventSystem.WEI_weight_maxed.emit()
		#is_max_weight = true
	else:
		EventSystem.WEI_weight_not_maxed.emit()
		#is_max_weight = false

func check_if_weight_will_be_maxed(item_key: ItemConfig.Keys):
	if ItemConfig.get_item_resource(item_key).weight + weight > max_weight:
		EventSystem.WEI_item_weight_too_much.emit()
	else:
		EventSystem.WEI_item_weight_not_too_much.emit()
