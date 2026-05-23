extends Node

enum Keys {
	AXE_DAMAGE_1,
	AXE_DAMAGE_2,
	AXE_DAMAGE_3,
	AXE_DAMAGE_4,
	AXE_DAMAGE_5,
	AXE_RANGE_1,
	AXE_RANGE_2,
}

var upgrades: Dictionary = {
	Keys.AXE_DAMAGE_1: 0,
	Keys.AXE_DAMAGE_2: 0,
	Keys.AXE_DAMAGE_3: 0,
	Keys.AXE_DAMAGE_4: 0,
	Keys.AXE_DAMAGE_5: 0,
	Keys.AXE_RANGE_1: 0,
	Keys.AXE_RANGE_2: 0,
}

func get_upgrade_level(key:Keys) -> int:
	return upgrades.get(key)
