class_name HitBox extends Area2D

@export var damage: int = 10
@export var knockback_force: int = 200
@export var knockback_duration: float = 0.2

func on() -> void:	
	$CollisionShape2D.set_deferred("disabled", false)


func off() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
