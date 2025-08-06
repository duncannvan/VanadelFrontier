class_name RockObject extends NatureObject

const ROCK_UID: String = "uid://bq8enjaug7mue"

@export var respawn_time_s: int = 10


func create_scene() -> NatureObject:
	return preload(ROCK_UID).instantiate()
