class_name TreeObject extends NatureObject

const TREE_UID: String = "uid://b8wgn38g22fvs"

@export var respawn_time_s: int = 10

func create_scene() -> NatureObject:
	return preload(TREE_UID).instantiate()
	
