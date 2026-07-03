extends Resource
class_name SkillResource

@export var upgrade_name: String = "Upgrade Name"
@export var upgrade_key: SkillTreeConfig.Keys
@export var texture: Texture2D

@export_group("Levels & Scaling")
@export var max_level: int = 1
@export var stat_increase: float = 1.0
@export var upgrade_cost: int = 10
@export var price_increase_mult_per_level: float = 1.5
@export var level_requirement_to_reveal: int = 1

@export_group("Description")
@export_multiline var description: String = "Description of the upgrade."

func apply_upgrade():
	pass
