extends Node

var weight := 0
var max_weight := 2

#var is_max_weight: bool = false

func _ready() -> void:
	EventSystem.WEI_weight_changed.connect(update_weight)
	EventSystem.WEI_ask_update_weight_visual.connect(ask_update_weight_visual)

func update_weight(weight_changed: int) -> void:
	weight += weight_changed
	check_if_weight_max()
	EventSystem.WEI_update_weight_visual.emit(weight, max_weight)

func ask_update_weight_visual():
	EventSystem.WEI_update_weight_visual.emit(weight, max_weight)

func check_if_weight_max() -> void:
	print("Weight is :", weight)
	if weight == max_weight:
		print("Emitted")
		EventSystem.WEI_weight_maxed.emit()
		#is_max_weight = true
	else:
		EventSystem.WEI_weight_not_maxed.emit()
		#is_max_weight = false
