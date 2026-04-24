extends Node

var inventory_size := 5
var inventory := []

func _enter_tree() -> void:
	EventSystem.INV_ask_update_inventory.connect(send_inventory)
	EventSystem.INV_switch_two_inventory_item_indexes.connect(switch_two_item_indexes)
	EventSystem.INV_delete_item_by_index.connect(delete_item_by_index)
	EventSystem.INV_try_to_pickup_item.connect(try_to_pickup_item)



func _ready() -> void:
	inventory.resize(inventory_size)
	inventory[0] = ItemConfig.Keys.Log

func try_to_pickup_item(item_key:ItemConfig.Keys, destroy_pickuppable:Callable) -> void:
	if not get_free_slots():
		return
	
	add_item(item_key)
	destroy_pickuppable.call()

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
	
	EventSystem.INV_inventory_updated.emit(inventory)

func send_inventory() -> void:
	EventSystem.INV_inventory_updated.emit(inventory)

func switch_two_item_indexes(slot1:int, slot2:int, ) -> void:
	var temp = inventory[slot1]
	inventory[slot1] = inventory[slot2]
	inventory[slot2] = temp
	
	EventSystem.INV_inventory_updated.emit(inventory)

func delete_item_by_index(index:int) -> void:
	inventory[index] = null
	EventSystem.INV_inventory_updated.emit(inventory)
