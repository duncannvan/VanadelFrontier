class_name TreeObject extends NatureObject

@export var respawn_time_s: int = 10

var _tree_scene: Resource = preload("res://Nature/Tree.tscn")


func create_scene() -> NatureObject:
	return _tree_scene.instantiate()
	
