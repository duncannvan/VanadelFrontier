class_name RockObject extends NatureObject

const ROCK_UID: String = "uid://bq8enjaug7mue"

@export var respawn_time_s: int = 10

var _rock_scene: Resource = preload(ROCK_UID)


func create_scene() -> NatureObject:
	return _rock_scene.instantiate()
