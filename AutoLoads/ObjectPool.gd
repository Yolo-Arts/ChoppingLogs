extends Node

var _pools: Dictionary = {}
var _scene_paths: Dictionary = {}  

func get_object(scene: PackedScene) -> Node:
	var path := scene.resource_path
	
	if _pools.has(path) and not _pools[path].is_empty():
		var obj = _pools[path].pop_back()
		obj.visible = true
		obj.process_mode = Node.PROCESS_MODE_INHERIT
		return obj
	
	var obj := scene.instantiate()
	_scene_paths[obj] = path  
	return obj

func return_object(obj: Node) -> void:
	var path: String = _scene_paths.get(obj, "")
	if path.is_empty():
		obj.queue_free()  
		return
	
	obj.visible = false
	obj.process_mode = Node.PROCESS_MODE_DISABLED
	
	if not _pools.has(path):
		_pools[path] = []
	_pools[path].append(obj)

func prewarm(scene: PackedScene, count: int, parent: Node) -> void:
	for i in count:
		var obj := scene.instantiate()
		_scene_paths[obj] = scene.resource_path
		parent.add_child(obj)
		return_object(obj)
