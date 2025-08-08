class_name RockObject extends NatureObject

const ROCK_UID: String = "uid://qr4o0q7u40xm"

@export var respawn_time_s: int = 10


func create_scene() -> NatureObject:
	return preload(ROCK_UID).instantiate()
