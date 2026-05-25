class_name ItemConfig

enum Keys {
	Log,
}

const ITEM_RESOURCES := {
	Keys.Log: "res://Resources/items/log_item_resource.tres",
}

const PICKUPPABLE_ITEM_SCENES := {
	Keys.Log: "res://Objects/interactables/pickuppables/rigid_pickuppable_log.tscn"
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
