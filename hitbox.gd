class_name HitBox extends Area2D

func on() -> void:
	self.monitoring = true
	self.get_node("HitEffects").visible = true
	
func off() -> void:
	self.monitoring = false	
	self.get_node("HitEffects").visible = false
