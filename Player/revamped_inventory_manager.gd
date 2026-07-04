extends Node

@export var player_stats: PlayerStats
var inventory: Dictionary = {}

var can_add_to_inventory: bool = true 
var item_too_heavy: bool = false 

func _enter_tree() -> void:
	EventSystem.INV_ask_update_inventory.connect(send_inventory)
	EventSystem.INV_try_to_pickup_item.connect(try_to_pickup_item)
	EventSystem.WEI_weight_maxed.connect(lock_inventory.bind(true))
	EventSystem.WEI_weight_not_maxed.connect(lock_inventory.bind(false))
	EventSystem.WEI_item_weight_too_much.connect(check_if_item_too_heavy.bind(true))
	EventSystem.WEI_item_weight_not_too_much.connect(check_if_item_too_heavy.bind(false))
	
	EventSystem.UPG_upgrade_updated.connect(_on_upgrade_updated)
	EventSystem.MON_sell_all_items.connect(sell_all_items)

func lock_inventory(weight_maxed: bool) -> void:
	can_add_to_inventory = !weight_maxed
	print("Can add to inventory?", can_add_to_inventory)

func check_if_item_too_heavy(is_item_too_heavy: bool) -> void:
	item_too_heavy = is_item_too_heavy

func try_to_pickup_item(item_key: ItemConfig.Keys, destroy_pickuppable: Callable) -> void:
	if get_total_items() >= player_stats.inventory_size:
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

func get_total_items() -> int:
	var total := 0
	for amount in inventory.values():
		total += amount
	return total

func add_item(item_key: ItemConfig.Keys) -> void:
	if not inventory.has(item_key):
		inventory[item_key] = 0
	inventory[item_key] += 1
	
	var item_weight = ItemConfig.get_item_resource(item_key).weight
	EventSystem.WEI_weight_changed.emit(item_weight)
	EventSystem.INV_inventory_updated.emit(inventory)
	EventSystem.MON_check_if_can_sell.emit()

func send_inventory() -> void:
	EventSystem.INV_inventory_updated.emit(inventory)

func _on_upgrade_updated(upgrade_key: UpgradeConfig.Keys, _new_level: int) -> void:
	if upgrade_key == UpgradeConfig.Keys.BackPack:
		EventSystem.INV_inventory_updated.emit(inventory)

func sell_all_items() -> void:
	if inventory.is_empty():
		return
		
	var total_money_earned := 0
	var total_weight_removed := 0.0
	
	for item_key in inventory:
		var amount = inventory[item_key]
		var item_res = ItemConfig.get_item_resource(item_key)
		
		if item_res:
			total_money_earned += item_res.sell_price * amount
			total_weight_removed += item_res.weight * amount

	inventory.clear() 
	
	EventSystem.MON_add_money.emit(total_money_earned)
	EventSystem.WEI_weight_changed.emit(-total_weight_removed)
	EventSystem.INV_inventory_updated.emit(inventory)
