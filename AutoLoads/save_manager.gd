extends Node

const UPGRADES_FILE_PATH: String = "user://skill_tree_upgrades.json"

const ENCRYPTION_PASSWORD: String = "jaIAOSDjn1327SaKL_jds0YuPKjL4dz*wdja"

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

# Upgrades related save system functions:

func save_upgrades() -> void:
	save_encrypted_file(UPGRADES_FILE_PATH, SkillTreeConfig.upgrades)
	print("Upgrades saved successfully.")

func load_upgrades() -> void:
	var loaded_data: Dictionary = load_encrypted_file(UPGRADES_FILE_PATH)
	
	if loaded_data.is_empty():
		return
	
	# Turns the json strings back to integers due "0" != 0 when accessing enum keys.
	for string_key in loaded_data.keys():
		var enum_key: int = int(string_key) 
		var level_value: int = int(loaded_data[string_key])
		
		if enum_key in SkillTreeConfig.upgrades:
			SkillTreeConfig.upgrades[enum_key] = level_value
			
	print("Upgrades loaded successfully.")


func reset_upgrades() -> void:
	for key in SkillTreeConfig.upgrades.keys():
		SkillTreeConfig.upgrades[key] = 0
	save_upgrades()
