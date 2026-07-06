extends Node

func _enter_tree() -> void:
	EventSystem.UPG_upgrade_requested.connect(increase_upgrade_level)
	#EventSystem.AXE_increase_axe_damage.connect(increase_upgrade_level.bind(UpgradeConfig.Keys.ChopDamage)) these seem deprecated?
	#EventSystem.AXE_increase_axe_speed.connect(increase_upgrade_level.bind(UpgradeConfig.Keys.AxeSpeed))
	#EventSystem.UPG_increase_sprint_speed.connect(increase_upgrade_level.bind(UpgradeConfig.Keys.SprintSpeed))
	#EventSystem.UPG_increase_inventory_size.connect(increase_upgrade_level.bind(UpgradeConfig.Keys.BackPack))

func increase_upgrade_level(upgrade_key: UpgradeConfig.Keys) -> void:
	if not UpgradeConfig.upgrades.has(upgrade_key):
		push_error("Key missing from UpgradeConfig dictionary")
		return
		
	var current_level: int = UpgradeConfig.upgrades[upgrade_key]
	var max_level: int = UpgradeConfig.max_level[upgrade_key]
	
	if current_level < max_level:
		UpgradeConfig.upgrades[upgrade_key] += 1
		var new_level = UpgradeConfig.upgrades[upgrade_key]
		
		print("Upgraded %s to level %d" % [UpgradeConfig.Keys.keys()[upgrade_key], new_level])
		
		EventSystem.UPG_upgrade_updated.emit(upgrade_key, new_level)
	else:
		print("%s is already at max level (%d)!" % [UpgradeConfig.Keys.keys()[upgrade_key], max_level])
