extends HittableObjectTemplate

func _ready() -> void:
	add_to_group("Trees")
	base_scale = scale
	print(base_scale)
	EventSystem.TRE_tree_spawned.emit()

func die() -> void:
	EventSystem.TRE_tree_cut.emit()
	
	super()
