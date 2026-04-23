extends Resource
class_name ItemResource

@export var item_key := ItemConfig.Keys.Log
@export var display_name := "item_name"
@export var icon:Texture2D
@export_multiline var description := "item description"
@export var weight: int = 1
@export var sell_price: int = 1
