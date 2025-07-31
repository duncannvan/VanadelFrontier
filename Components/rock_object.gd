class_name RockObject extends NatureObject

var _rock_scene: Resource = preload("res://Nature/Rock.tscn")
@export var respawn_time_s: int = 10


func create_scene() -> NatureObject:
	return _rock_scene.instantiate()
