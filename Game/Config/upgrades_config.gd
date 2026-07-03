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
	Keys.BackPack: 3,
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
	
	max_level[Keys.AxeSpeed] = 3 \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_SPEED_1] * 2) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_SPEED_2] * 5) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_SPEED_3] * 5) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_SPEED_4] * 5) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_SPEED_5] * 5) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_SPEED_6] * 5) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_SPEED_7] * 5) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_AXE_SPEED_8] * 5) 
	
	
	max_level[Keys.SprintStamina] = 5
	
	
	max_level[Keys.SprintSpeed] = 5 + SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_SPRINT_SPEED]
	
	max_level[Keys.BackPack] = 3 \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_INVENTORY_SIZE_1] * 7) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_INVENTORY_SIZE_2] * 15) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_INVENTORY_SIZE_3] * 25) \
	+ (SkillTreeConfig.upgrades[SkillTreeConfig.Keys.MAX_LEVEL_INVENTORY_SIZE_4] * 50)
