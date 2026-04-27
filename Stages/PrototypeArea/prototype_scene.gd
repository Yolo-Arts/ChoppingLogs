extends Node

@onready var scatter_trees: ProtonScatter = $NavigationRegion3D/ScatterTrees
@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D

func _ready() -> void:
	EventSystem.MUS_play_music.emit(MusicConfig.Keys.IslandAmbience)
	
	await get_tree().process_frame
	
	randomize_forest()
	scatter_trees.build_completed.connect(_on_scatter_finished)

func randomize_forest() -> void:
	if scatter_trees:
		scatter_trees.global_seed = randi_range(0, 60)
		print("Forest randomized with seed: ", scatter_trees.global_seed)

func _on_scatter_finished() -> void:
	navigation_region_3d.bake_navigation_mesh()
