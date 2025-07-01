class_name HitBox extends Area2D

const DAMAGE_INTERVAL: float = 0.5

@export var damage = 10
@export var body_hitbox: bool = false


func on() -> void:	
	self.get_node("CollisionShape2D").set_deferred("disabled", false)
	
	
func off() -> void:
	self.get_node("CollisionShape2D").set_deferred("disabled", true)
