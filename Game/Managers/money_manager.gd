extends Node

@export var player_stats: PlayerStats

func _ready() -> void:
	EventSystem.MON_add_money.connect(add_money)
	EventSystem.MON_decrease_money.connect(check_if_balance_will_not_go_below_zero)
	EventSystem.MON_get_player_money = func() -> float: return player_stats.money
	EventSystem.QUO_reset_quota.connect(_on_quota_reset)

func add_money(money_to_add: float):
	player_stats.money += money_to_add
	EventSystem.MON_money_updated.emit(player_stats.money, Color.YELLOW)
	SaveManager.save_player_data(player_stats.money, player_stats.prestige_points)

func remove_money(money_to_remove: float) -> void:
	player_stats.money -= money_to_remove
	EventSystem.MON_money_updated.emit(player_stats.money, Color.RED)
	SaveManager.save_player_data(player_stats.money, player_stats.prestige_points)

func _on_quota_reset() -> void:
	remove_money(player_stats.money)
	add_money(player_stats.starting_money)
	

func check_if_balance_will_not_go_below_zero(money_to_remove: float):
	if player_stats.money - money_to_remove >= 0:
		remove_money(money_to_remove)
	else:
		EventSystem.MON_cannot_decrease_money.emit()
