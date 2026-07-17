extends Resource
class_name ItemResource

@export var item_key := ItemConfig.Keys.Log
@export var display_name := "item_name"
@export var icon:Texture2D
@export_multiline var description := "item description"
@export var weight: int = 0
var base_sell_price: int #slightly wonky pattern to minimize breaking things
@export var sell_price: int = 1 :
	get:
		return get_price()
	set(value):
		base_sell_price = value

func get_price() -> int:
	return base_sell_price
