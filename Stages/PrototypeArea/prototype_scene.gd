extends Node

@onready var scatter_trees: ProtonScatter = $NavigationRegion3D/ScatterTrees
@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D

var _is_baking: bool = false

func _ready() -> void:
	EventSystem.MUS_play_music.emit(MusicConfig.Keys.IslandAmbience)
	
	await get_tree().process_frame
	
	randomize_forest()
	scatter_trees.build_completed.connect(_on_scatter_finished)

func randomize_forest() -> void:
	if scatter_trees:
		EventSystem.HUD_reset_hud_elements.emit()
		scatter_trees.global_seed = randi()
		print("Forest randomized with seed: ", scatter_trees.global_seed)

func _on_scatter_finished() -> void:
	if _is_baking:
		return
		
	_is_baking = true
	await get_tree().process_frame
	
	navigation_region_3d.bake_navigation_mesh()
	navigation_region_3d.bake_finished.connect(_on_bake_finished)

func _on_bake_finished() -> void:
	_is_baking = false
	print("Bake Complete!")


# TODO update navigation mesh so that it changes when a tree is destroyed.

# TODO Use threads to load a scene.
