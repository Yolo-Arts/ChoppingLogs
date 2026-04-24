extends Bulletin

@onready var inventory_slot_container: GridContainer = %InventorySlotContainer
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription
@onready var item_sell: Label = %ItemSell
@onready var item_weight: Label = %ItemWeight
@onready var discard_area: PanelContainer = %DiscardArea

func _enter_tree() -> void:
	EventSystem.INV_inventory_updated.connect(update_inventory)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	EventSystem.PLA_freeze_player.emit()
	EventSystem.INV_ask_update_inventory.emit()
	discard_area.item_scrapped.connect(hide_item_info)
	
	for inventory_slot in inventory_slot_container.get_children():
		inventory_slot.mouse_entered.connect(show_item_info.bind(inventory_slot))
		inventory_slot.mouse_exited.connect(hide_item_info)
	item_name.text = ""
	item_description.text = ""
	item_sell.text = ""
	item_weight.text = ""

func show_item_info(inventory_slot:InventorySlot) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	
	var item_key = inventory_slot.item_key
	
	if item_key == null:
		return
	
	var item_resource:ItemResource = ItemConfig.get_item_resource(item_key)
	item_name.text = item_resource.display_name
	item_description.text = item_resource.description
	item_sell.text = "Sell Price: " + str(item_resource.sell_price)
	item_weight.text = "Weight: " + str(item_resource.weight)


func hide_item_info() -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	item_name.text = ""
	item_description.text = ""
	item_sell.text = ""
	item_weight.text = ""

func update_inventory(inventory:Array) -> void:
	for i in inventory.size():
		inventory_slot_container.get_child(i).set_item_key(inventory[i])

func _on_close_button_pressed() -> void:
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.Inventory)
	EventSystem.PLA_unfreeze_player.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory"):
		_on_close_button_pressed()
