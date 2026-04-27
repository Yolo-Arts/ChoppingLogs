class_name ItemConfig

enum Keys {
	Log,
}

const ITEM_RESOURCES := {
	Keys.Log: "res://Resources/items/log_item_resource.tres",
}

static func get_item_resource(item_key:Keys) -> ItemResource:
	return load(ITEM_RESOURCES[item_key])

static func get_pickuppable_item_scene(item_key:Keys) -> PackedScene:
	return load(PICKUPPABLE_ITEM_SCENES[item_key])

const PICKUPPABLE_ITEM_SCENES := {
	Keys.Log: "res://Objects/interactables/pickuppables/rigid_pickuppable_log.tscn"
}
