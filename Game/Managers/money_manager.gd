extends Node

@export var player_stats: PlayerStats

func _ready() -> void:
	EventSystem.MON_add_money.connect(add_money)
	EventSystem.MON_decrease_money.connect(remove_money)

func add_money(money_to_add: float):
	player_stats.money += money_to_add
	EventSystem.MON_money_updated.emit(player_stats.money)

func remove_money(money_to_remove: float) -> void:
	player_stats.money -= money_to_remove
	EventSystem.MON_money_updated.emit(player_stats.money, true)
