extends Node

@export var player_stats: PlayerStats
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
	
	EventSystem.UPG_upgrade_updated.connect(_on_upgrade_updated)
	EventSystem.MON_sell_all_items.connect(sell_all_items)

func _ready() -> void:
	inventory.resize(player_stats.inventory_size)

func lock_inventory(weight_maxed: bool):
	can_add_to_inventory = !weight_maxed
	print("Can add to inventory?", can_add_to_inventory)

func check_if_item_too_heavy(is_item_too_heavy: bool):
	item_too_heavy = is_item_too_heavy

func try_to_pickup_item(item_key:ItemConfig.Keys, destroy_pickuppable:Callable) -> void:
	if not get_free_slots():
		EventSystem.WEI_cannot_pickup_due_to_space.emit()
		return
	
	EventSystem.WEI_check_if_weight_maxed.emit()
	if not can_add_to_inventory:
		EventSystem.WEI_cannot_pickup_due_to_weight.emit()
		return
	
	EventSystem.WEI_check_if_weight_will_be_maxed.emit(item_key)
	if item_too_heavy:
		EventSystem.WEI_cannot_pickup_due_to_weight.emit()
		return
	
	add_item(item_key)
	destroy_pickuppable.call()


func get_free_slots() -> int:
	var free_slots := 0
	for slot in inventory:
		if slot == null:
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
	EventSystem.MON_check_if_can_sell.emit()

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

func _on_upgrade_updated(upgrade_key: UpgradeConfig.Keys, _new_level: int) -> void:
	if upgrade_key == UpgradeConfig.Keys.BackPack:
		if player_stats.inventory_size < 500:
			inventory.resize(player_stats.inventory_size)
			EventSystem.INV_inventory_updated.emit(inventory)
			print("Inventory successfully expanded to: ", inventory.size())

func sell_all_items():
	var total_money_earned := 0
	var total_weight_removed := 0.0
	var items_sold := false

	for i in inventory.size():
		if inventory[i] == null:
			continue
			
		var item_key = inventory[i]
		var item_res = ItemConfig.get_item_resource(item_key)
		
		if item_res:
			total_money_earned += item_res.sell_price
			total_weight_removed += item_res.weight
		
		inventory[i] = null 
		items_sold = true

	if not items_sold:
		return
		
	EventSystem.MON_add_money.emit(total_money_earned)
	EventSystem.WEI_weight_changed.emit(-total_weight_removed)
	EventSystem.INV_inventory_updated.emit(inventory)
