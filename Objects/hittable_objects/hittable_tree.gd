class_name HittableTree extends HittableObjectTemplate
@onready var hitbox: Area3D = $Hitbox

@export var tougher_trees_key: SkillTreeConfig.Keys

func _ready() -> void:
	current_health *= 1 + SkillTreeConfig.get_upgrade_level(tougher_trees_key)
	add_to_group("Trees")
	base_scale = scale
	EventSystem.TRE_tree_spawned.emit()

func die() -> void:
	EventSystem.TRE_tree_cut.emit()
	
	super()

#this is the only thing I can forsee possibly not working correctly, if on re-init from pool hp isn't correct
#from limited testing this seems to be working as intended
func reset() -> void:
	super.reset() 
	current_health *= 1 + SkillTreeConfig.get_upgrade_level(tougher_trees_key)
