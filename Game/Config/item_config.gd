class_name ItemConfig

enum Keys {
	Log,
}

const ITEM_RESOURCES := {
	Keys.Log: "res://Resources/items/log_item_resource.tres",
}

static func get_item_resource(item_key:Keys) -> ItemResource:
	return load(ITEM_RESOURCES[item_key])
