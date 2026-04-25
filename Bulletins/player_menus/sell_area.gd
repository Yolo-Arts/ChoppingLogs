extends PanelContainer

signal item_scrapped

func _can_drop_data(_at_position: Vector2, slot: Variant) -> bool:
	return slot is InventorySlot

func _drop_data(_at_position: Vector2, old_slot: Variant) -> void:
	if old_slot is InventorySlot:
		var key = old_slot.item_key
		
		var price = ItemConfig.get_item_resource(key).sell_price
		
		EventSystem.MON_add_money.emit(price)
		
		EventSystem.INV_delete_item_by_index.emit(old_slot.get_index())
		item_scrapped.emit()
