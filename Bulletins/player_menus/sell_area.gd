extends PanelContainer

signal item_scrapped

func _can_drop_data(_at_position: Vector2, slot: Variant) -> bool:
	return slot is InventorySlot

func _drop_data(_at_position: Vector2, old_slot: Variant) -> void:
	if old_slot is InventorySlot:
		#EventSystem.
		item_scrapped.emit()
