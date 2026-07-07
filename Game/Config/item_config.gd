class_name ItemConfig

enum Keys {
	Log,
	Log2,
	Log3,
	Log4,
	Log5,
	Log6
}

const ITEM_RESOURCES := {
	Keys.Log: "res://Resources/items/log_1_item_resource.tres",
	Keys.Log2: "res://Resources/items/log_2_item_resource.tres",
	Keys.Log3: "res://Resources/items/log_3_item_resource.tres",
	Keys.Log4: "res://Resources/items/log_4_item_resource.tres",
	Keys.Log5: "res://Resources/items/log_5_item_resource.tres",
	Keys.Log6: "res://Resources/items/log_6_item_resource.tres",
}

const PICKUPPABLE_ITEM_SCENES := {
	Keys.Log: "res://Objects/interactables/pickuppables/rigid_pickuppable_log.tscn",
	Keys.Log2: "res://Objects/interactables/pickuppables/rigid_pickuppable_log_2.tscn",
	Keys.Log3: "res://Objects/interactables/pickuppables/rigid_pickuppable_log_3.tscn",
	Keys.Log4: "res://Objects/interactables/pickuppables/rigid_pickuppable_log_4.tscn",
	Keys.Log5: "res://Objects/interactables/pickuppables/rigid_pickuppable_log_5.tscn",
	Keys.Log6: "res://Objects/interactables/pickuppables/rigid_pickuppable_log_6.tscn",
}

static var _resource_cache := {}

static func get_item_resource(item_key: Keys) -> ItemResource:
	if _resource_cache.has(item_key):
		return _resource_cache[item_key]
	
	if ITEM_RESOURCES.has(item_key):
		var res = load(ITEM_RESOURCES[item_key])
		_resource_cache[item_key] = res
		return res
		
	return null

static func get_pickuppable_item_scene(item_key: Keys) -> PackedScene:
	return load(PICKUPPABLE_ITEM_SCENES[item_key])
