extends Node

@onready var scatter_trees: ProtonScatter = $NavigationRegion3D/ScatterTrees
@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D

## Debug option to disable/enable skill tree resetting
@export var reset_upgrades: bool = true

var _is_baking: bool = false
var trees_cut = 0

func _ready() -> void:
	EventSystem.MUS_play_music.emit(MusicConfig.Keys.IslandAmbience)
	EventSystem.TRE_get_tree_cut_amount = func(): return trees_cut
	EventSystem.TRE_tree_cut.connect(func(): trees_cut += 1)
	await get_tree().process_frame
	var log_scene = preload("res://Objects/interactables/pickuppables/rigid_pickuppable_log.tscn")
	#var tree_scene = preload("res://Objects/hittable_objects/hittable_tree_common_tree_1.tscn")
	ObjectPool.prewarm(log_scene, 2000, $Spawner/ObjectHolder)
	#ObjectPool.prewarm(tree_scene, 500, $Spawner/ObjectHolder)
	randomize_forest()
	scatter_trees.build_completed.connect(_on_scatter_finished)
	navigation_region_3d.bake_finished.connect(_on_bake_finished)
	if reset_upgrades:
		SaveManager.reset_upgrades()
	EventSystem.HUD_show_hud.emit()

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

func _on_bake_finished() -> void:
	_is_baking = false
	print("Bake Complete!")
	#EventSystem.HUD_show_hud.emit()


# TODO update navigation mesh so that it changes when a tree is destroyed.

# TODO Use threads to load a scene.
