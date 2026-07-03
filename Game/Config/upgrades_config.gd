class_name UpgradeConfig

enum Keys {
	ChopDamage,
	AxeSpeed,
	SprintStamina,
	SprintSpeed,
	BackPack,
}

static var upgrades: Dictionary = {
	Keys.ChopDamage: 0,
	Keys.AxeSpeed: 0,
	Keys.SprintStamina: 0,
	Keys.SprintSpeed: 0,
	Keys.BackPack: 0,
}

static var max_level: Dictionary = {
	Keys.ChopDamage: 5,
	Keys.AxeSpeed: 3,
	Keys.SprintStamina: 5,
	Keys.SprintSpeed: 5,
	Keys.BackPack: 7,
}

static func update_max_levels() -> void:
	max_level[Keys.ChopDamage] = 5 \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_DAMAGE_1] * 5) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_DAMAGE_2] * 15) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_DAMAGE_3] * 25) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_DAMAGE_4] * 50) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_DAMAGE_5] * 150) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_DAMAGE_6] * 250) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_DAMAGE_7] * 500)
	
	print("Max level axe damage from upgrade config is: ", max_level[Keys.ChopDamage])
	print("Prestige level for damage from prestige config is: ", SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_DAMAGE_1])
