extends Resource
class_name HittableObjectAttributes

@export var drop_item_key := ItemConfig.Keys.Log
@export var max_health := 60
# TODO add equippableitemconfigs to filter out weapons for hittable items (tree):
# OR MAYBE we could use collision layers, one for bullet 
#@export var weapon_filter : Array[ItemConfig.Keys] = [ItemConfig.Keys.Axe]
