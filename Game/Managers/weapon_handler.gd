extends Node3D

func _enter_tree() -> void:
	EventSystem.WEP_unlock_weapon.connect(unlock_weapon)

func _ready() -> void:
	var first_weapon = get_first_unlocked_weapon()
	if first_weapon:
		equip(first_weapon)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		cycle_weapon(1)
	if event.is_action_pressed("last_weapon"):
		cycle_weapon(-1)
	
	for i in range(get_child_count()):
		if event.is_action_pressed("weapon_" + str(i + 1)):
			var weapon = get_child(i)
			if weapon.unlocked:
				equip(weapon)

func equip(active_weapon: Node3D) -> void:
	for child in get_children():
		if child == active_weapon:
			child.visible = true
			child.set_process(true)
		else:
			child.visible = false
			child.set_process(false)

func cycle_weapon(direction: int) -> void:
	var unlocked_weapons = get_unlocked_weapons()
	if unlocked_weapons.size() == 0: 
		return
	
	var current_weapon = get_child(get_current_index())
	var current_unlocked_index = unlocked_weapons.find(current_weapon)
	
	var next_idx = wrapi(current_unlocked_index + direction, 0, unlocked_weapons.size())
	equip(unlocked_weapons[next_idx])

func get_unlocked_weapons() -> Array:
	var unlocked_list = []
	for child in get_children():
		if child.unlocked == true:
			unlocked_list.append(child)
	
	return unlocked_list

func get_first_unlocked_weapon() -> Node3D:
	var unlocked = get_unlocked_weapons()
	if unlocked.size() > 0:
		return unlocked[0]
	else:
		return null

func get_current_index() -> int:
	for index in get_child_count():
		if get_child(index).visible:
			return index
	return 0

func unlock_weapon(weapon_name: String) -> void:
	for child in get_children():
		if child.weapon_name == weapon_name:
			child.unlocked = true
			equip(child) 
			break
