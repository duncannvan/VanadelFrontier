class_name NatureSpawner extends Node

var position_queue: Array[Vector2] = []

func _ready() -> void:
	for child: NatureObject in get_children():
		child.nature_object_died.connect(_handle_respawn)

func _handle_respawn(obj: NatureObject) -> void:
	position_queue.append(obj.global_position)
	
	var new_obj: NatureObject = obj.create_scene()
	obj.queue_free()
	await get_tree().create_timer(new_obj.respawn_time_s).timeout
	
	new_obj.global_position = position_queue.pop_front()
	add_child(new_obj)
