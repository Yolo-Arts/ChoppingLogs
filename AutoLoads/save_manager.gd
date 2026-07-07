extends Node

const PRESTIGE_UPGRADES_FILE_PATH: String = "user://skill_tree_upgrades_test_3.json"
const UPGRADES_FILE_PATH: String = "user://upgrades_test_1.json"

const ENCRYPTION_PASSWORD: String = "jaIAOSDjn1327SaKL_jds0YuPKjL4dz*wdja"

func _ready() -> void:
	EventSystem.UPG_upgrade_updated.connect(_on_upgrade_updated)

# Generic save and load functions:
func save_encrypted_file(file_path: String, data: Dictionary) -> void:
	var save_file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, ENCRYPTION_PASSWORD)
	if save_file == null:
		push_error("Failed to open file: " + file_path)
		return
		
	var json_string: String = JSON.stringify(data)
	save_file.store_line(json_string)
	save_file.close()

func load_encrypted_file(file_path: String) -> Dictionary:
	if not FileAccess.file_exists(file_path):
		return {} 
		
	var save_file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, ENCRYPTION_PASSWORD)
	if save_file == null:
		push_error("Failed to open file: " + file_path)
		return {}
		
	var json = JSON.new()
	var json_string = save_file.get_line()
	save_file.close()
	
	if json.parse(json_string) == OK:
		return json.get_data()
	else:
		push_error("Corrupted encrypted data in: " + file_path + " -> " + json.get_error_message())
		return {}

func save_skill_tree_upgrades() -> void:
	save_encrypted_file(PRESTIGE_UPGRADES_FILE_PATH, SkillTreeConfig.upgrades)
	print("Prestige Upgrades saved successfully.")

func save_upgrade_config() -> void:
	save_encrypted_file(UPGRADES_FILE_PATH, UpgradeConfig.upgrades)
	print("Shop Upgrades saved successfully.")

func load_upgrades() -> void:
	var prestige_data: Dictionary = load_encrypted_file(PRESTIGE_UPGRADES_FILE_PATH)
	if not prestige_data.is_empty():
		# Turns the json strings back to integers due "0" != 0 when accessing enum keys.
		for string_key in prestige_data.keys():
			var enum_key: int = int(string_key) 
			var level_value: int = int(prestige_data[string_key])
			
			if enum_key in SkillTreeConfig.upgrades:
				SkillTreeConfig.upgrades[enum_key] = level_value
				
	
	var shop_data: Dictionary = load_encrypted_file(UPGRADES_FILE_PATH)
	if not shop_data.is_empty():
		for string_key in shop_data.keys():
			var enum_key: int = int(string_key)
			var level_value: int = int(shop_data[string_key])
			
			if enum_key in UpgradeConfig.upgrades:
				UpgradeConfig.upgrades[enum_key] = level_value
				
	
	UpgradeConfig.update_max_levels()
	print("All shop and prestige upgrades loaded successfully.")


func _on_upgrade_updated(_upgrade_key: UpgradeConfig.Keys, _new_level: int) -> void:
	save_upgrade_config()


func reset_all_upgrades_completely() -> void:
	for key in SkillTreeConfig.upgrades.keys():
		SkillTreeConfig.upgrades[key] = 0
	save_skill_tree_upgrades()
	
	for key in UpgradeConfig.upgrades.keys():
		UpgradeConfig.upgrades[key] = 0
	save_upgrade_config()
	
	UpgradeConfig.update_max_levels()

func reset_prestige_upgrades() -> void:
	for key in SkillTreeConfig.upgrades.keys():
		SkillTreeConfig.upgrades[key] = 0
	save_skill_tree_upgrades()
	UpgradeConfig.update_max_levels()

func reset_run_upgrades() -> void:
	for key in UpgradeConfig.upgrades.keys():
		UpgradeConfig.upgrades[key] = 0
	save_upgrade_config()
	UpgradeConfig.update_max_levels()
	
