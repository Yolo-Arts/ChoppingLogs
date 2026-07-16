class_name LogItem extends ItemResource
@export var stronger_trees_key: SkillTreeConfig.Keys

func get_price() -> int:
	print_debug(base_sell_price * (1 + SkillTreeConfig.get_upgrade_level(stronger_trees_key)))
	return base_sell_price * (1 + SkillTreeConfig.get_upgrade_level(stronger_trees_key))
