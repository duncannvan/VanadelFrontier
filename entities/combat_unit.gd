class_name CombatUnit extends CharacterBody2D

func _check_nodes():
	pass
	#assert(_sprite, "%s missing sprite" % self)


# Override in child
func _on_death() -> void: 
	pass


func _die() -> void:
	_on_death()
	queue_free()
