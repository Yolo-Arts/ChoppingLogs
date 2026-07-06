extends SkillResource

#Use inidividual keys to track what is bought, use this to set max upgrade level
func apply_upgrade():
	@warning_ignore("narrowing_conversion")
	SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_SPRINT_SPEED] += stat_increase
