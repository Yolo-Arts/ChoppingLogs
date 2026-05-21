extends HittableObjectTemplate
@onready var hitbox: Area3D = $Hitbox

func _ready() -> void:
	add_to_group("Trees")
	base_scale = scale
	EventSystem.TRE_tree_spawned.emit()

func die() -> void:
	EventSystem.TRE_tree_cut.emit()
	
	super()
