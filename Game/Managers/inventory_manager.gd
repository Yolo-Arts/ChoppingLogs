extends Node

var inventory_size := 5
var inventory := []

func _enter_tree() -> void:
	EventSystem.INV_ask_update_inventory.connect(send_inventory)
	EventSystem.INV_switch_two_inventory_item_indexes.connect(switch_two_item_indexes)
	EventSystem.INV_delete_item_by_index.connect(delete_item_by_index)



func _ready() -> void:
	inventory.resize(inventory_size)
	inventory[0] = ItemConfig.Keys.Log


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
