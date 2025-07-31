class_name TreeObject extends NatureObject

var _tree_scene: Resource = preload("res://Nature/Tree.tscn")
@export var respawn_time_s: int = 10


func create_scene() -> NatureObject:
	return _tree_scene.instantiate()
	
