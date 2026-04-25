extends Node

var inventory_size := 5
var inventory := []

var can_add_to_inventory: bool = true
var item_too_heavy :bool = false

func _enter_tree() -> void:
	EventSystem.INV_ask_update_inventory.connect(send_inventory)
	EventSystem.INV_switch_two_inventory_item_indexes.connect(switch_two_item_indexes)
	EventSystem.INV_delete_item_by_index.connect(delete_item_by_index)
	EventSystem.INV_try_to_pickup_item.connect(try_to_pickup_item)
	EventSystem.WEI_weight_maxed.connect(lock_inventory.bind(true))
	EventSystem.WEI_weight_not_maxed.connect(lock_inventory.bind(false))
	EventSystem.WEI_item_weight_too_much.connect(check_if_item_too_heavy.bind(true))
	EventSystem.WEI_item_weight_not_too_much.connect(check_if_item_too_heavy.bind(false))
	
	EventSystem.UPG_increase_inventory_size.connect(increase_inventory_size)

func _ready() -> void:
	inventory.resize(inventory_size)
	#inventory[0] = ItemConfig.Keys.Log

func lock_inventory(weight_maxed: bool):
	can_add_to_inventory = !weight_maxed
	print("Can add to inventory?", can_add_to_inventory)

func check_if_item_too_heavy(is_item_too_heavy: bool):
	item_too_heavy = is_item_too_heavy

func try_to_pickup_item(item_key:ItemConfig.Keys, destroy_pickuppable:Callable) -> void:
	if not get_free_slots():
		return
	
	if can_add_to_inventory:
		EventSystem.WEI_check_if_weight_will_be_maxed.emit(item_key)
		if item_too_heavy == false:
			add_item(item_key)
			destroy_pickuppable.call()
		else:
			EventSystem.WEI_cannot_pickup_due_to_weight.emit()
	else:
		EventSystem.WEI_cannot_pickup_due_to_weight.emit()

func get_free_slots() -> int:
	var free_slots := 0
	for slot in inventory:
		if not slot:
			free_slots += 1
	
	return free_slots

func add_item(item_key:ItemConfig.Keys) -> void:
	for i in inventory.size():
		if inventory[i] == null:
			inventory[i] = item_key
			break
	
	var weight = ItemConfig.get_item_resource(item_key).weight
	EventSystem.WEI_weight_changed.emit(weight)
	EventSystem.INV_inventory_updated.emit(inventory)

func send_inventory() -> void:
	EventSystem.INV_inventory_updated.emit(inventory)

func switch_two_item_indexes(slot1:int, slot2:int, ) -> void:
	var temp = inventory[slot1]
	inventory[slot1] = inventory[slot2]
	inventory[slot2] = temp
	
	EventSystem.INV_inventory_updated.emit(inventory)

func delete_item_by_index(index:int) -> void:
	var weight = ItemConfig.get_item_resource(inventory[index]).weight
	inventory[index] = null
	EventSystem.WEI_weight_changed.emit(-weight)
	EventSystem.INV_inventory_updated.emit(inventory)

func increase_inventory_size():
	if inventory_size < 30:
		inventory_size += 1
		inventory.resize(inventory_size)
