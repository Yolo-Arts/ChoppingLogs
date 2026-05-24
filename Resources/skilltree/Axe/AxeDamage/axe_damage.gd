extends SkillResource

func apply_upgrade():
	EventSystem.AXE_increase_axe_damage.emit(stat_increase)
