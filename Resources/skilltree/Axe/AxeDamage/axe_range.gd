extends SkillResource

func apply_upgrade():
	EventSystem.UPG_increase_axe_range.emit(stat_increase)
