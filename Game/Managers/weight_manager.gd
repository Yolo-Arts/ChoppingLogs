extends Node

@export var player_stats: PlayerStats

#var is_max_weight: bool = false

func _ready() -> void:
	EventSystem.WEI_weight_changed.connect(update_weight)
	EventSystem.WEI_ask_update_weight_visual.connect(ask_update_weight_visual)
	EventSystem.WEI_check_if_weight_will_be_maxed.connect(check_if_weight_will_be_maxed)
	EventSystem.WEI_check_if_weight_maxed.connect(check_if_weight_max)
	EventSystem.UPG_increase_max_weight.connect(increase_max_weight)

func update_weight(weight_changed: int) -> void:
	player_stats.weight += weight_changed
	player_stats.weight = max(0.0, player_stats.weight)
	
	check_if_weight_max()
	calculate_weight_modifier()
	EventSystem.WEI_update_weight_visual.emit(player_stats.weight, player_stats.max_weight)

func calculate_weight_modifier() -> void:
	var weight_ratio = player_stats.weight / player_stats.max_weight
	player_stats.player_speed_with_weight_modifier = clampf(1.0 - weight_ratio, 0.3, 1.0)

func ask_update_weight_visual():
	EventSystem.WEI_update_weight_visual.emit(player_stats.weight, player_stats.max_weight)

# Checks if weight is maxed.
func check_if_weight_max() -> void:
	print("Weight is :", player_stats.weight)
	if player_stats.weight >= player_stats.max_weight:
		print("Emitted")
		EventSystem.WEI_weight_maxed.emit()
		#is_max_weight = true
	else:
		EventSystem.WEI_weight_not_maxed.emit()
		#is_max_weight = false

# Checks if item being picked up will exceed max weight.
func check_if_weight_will_be_maxed(item_key: ItemConfig.Keys):
	if ItemConfig.get_item_resource(item_key).weight + player_stats.weight > player_stats.max_weight:
		EventSystem.WEI_item_weight_too_much.emit()
	else:
		EventSystem.WEI_item_weight_not_too_much.emit()

func increase_max_weight(increase_amount: int):
	player_stats.max_weight += increase_amount
	calculate_weight_modifier()
