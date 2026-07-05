class_name TimerSkillResource extends SkillResource#TODO: Timer skills + Time Trees costs.

@export_group("Timing")
@export var _add_time_immediately: bool = true#easy switch to update time immediately or only on respawn

func apply_upgrade():
	if !_add_time_immediately:
		return
	EventSystem.HUD_change_countdown.emit(stat_increase * 60)
