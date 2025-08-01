class_name TreeObject extends NatureObject

const TREE_UID: String = "uid://b8wgn38g22fvs"

@export var respawn_time_s: int = 10

var _tree_scene: Resource = preload(TREE_UID)


func create_scene() -> NatureObject:
	return _tree_scene.instantiate()
	
