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
