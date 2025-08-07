class_name TreeObject extends NatureObject

const TREE_UID: String = "uid://beih0jnnpi4kh"

@export var respawn_time_s: int = 10

func create_scene() -> NatureObject:
	return preload(TREE_UID).instantiate()
	
