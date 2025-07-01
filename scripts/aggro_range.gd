class_name AggroRange extends Area2D

func _ready() -> void:
	connect("body_entered", _on_area_entered)
	connect("body_exited", _on_area_exited)
	
func _on_area_entered(player: Player) -> void:
	owner.modulate = Color.RED
	owner.current_target = player
	
func _on_area_exited(player: Player) -> void:
	if not owner: return
	owner.modulate = Color.WHITE
	owner.current_target = owner.base_target

func off() -> void:
	self.get_node("CollisionShape2D").set_deferred("disabled", true)

	
