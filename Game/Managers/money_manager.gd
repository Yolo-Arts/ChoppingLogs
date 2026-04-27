extends Node

@export var player_stats: PlayerStats

func _ready() -> void:
	EventSystem.MON_add_money.connect(add_money)
	EventSystem.MON_decrease_money.connect(check_if_balance_will_not_go_below_zero)

func add_money(money_to_add: float):
	player_stats.money += money_to_add
	EventSystem.MON_money_updated.emit(player_stats.money, Color.YELLOW)

func remove_money(money_to_remove: float) -> void:
	player_stats.money -= money_to_remove
	EventSystem.MON_money_updated.emit(player_stats.money, Color.RED)

func check_if_balance_will_not_go_below_zero(money_to_remove: float):
	if player_stats.money - money_to_remove >= 0:
		remove_money(money_to_remove)
	else:
		EventSystem.MON_cannot_decrease_money.emit()
