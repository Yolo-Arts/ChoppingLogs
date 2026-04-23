extends TextureRect
class_name InventorySlot

@onready var icon_texture_rect: TextureRect = $MarginContainer/IconTextureRect

var item_key

func set_item_key(_item_key) -> void:
	item_key = _item_key
	update_icon()

func update_icon() -> void:
	if item_key == null:
		icon_texture_rect.texture = null
		return
	
	icon_texture_rect.texture = ItemConfig.get_item_resource(item_key).icon

func _get_drag_data(at_position: Vector2) -> Variant:
	if item_key != null:
		# drag code
		var drag_preview := Control.new()
		var texture_rect := TextureRect.new()
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.texture = icon_texture_rect.texture
		texture_rect.custom_minimum_size = Vector2(80, 80)
		texture_rect.modulate = Color(1, 1, 1, 0.7)
		texture_rect.position = -texture_rect.custom_minimum_size / 2
		drag_preview.add_child(texture_rect)
		set_drag_preview(drag_preview)
		
		return self
	
	return null

func _can_drop_data(_at_position: Vector2, slot: Variant) -> bool:
	return slot is InventorySlot

func _drop_data(at_position: Vector2, old_slot: Variant) -> void:
	EventSystem.INV_switch_two_inventory_item_indexes.emit(old_slot.get_index(), get_index())
	#EventSystem.INV_switch_two_inventory_item_indexes.emit(
			#old_slot.get_index(),
			#old_slot is HotbarSlot,
			#get_index(),
			#self is HotbarSlot
			#)
