extends SkillResource

func apply_upgrade():
	EventSystem.AXE_update_hit_marker_position.emit()
