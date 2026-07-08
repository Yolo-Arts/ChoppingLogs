extends Node

@export var player_stats: PlayerStats

func _ready() -> void:
	EventSystem.PRE_change_prestige_points_value.connect(modify_prestige_points)
	EventSystem.PRE_get_prestige_points = func() -> float: return player_stats.prestige_points
	
	_update_ui_display.call_deferred()

func modify_prestige_points(change_amount: float) -> void:
	player_stats.prestige_points += change_amount
	
	if player_stats.prestige_points < 0:
		player_stats.prestige_points = 0
		
	SaveManager.save_player_data(player_stats.money, player_stats.prestige_points)
	EventSystem.HUD_update_prestige_points.emit(player_stats.prestige_points)

func _update_ui_display() -> void:
	if player_stats:
		EventSystem.HUD_update_prestige_points.emit(player_stats.prestige_points)
