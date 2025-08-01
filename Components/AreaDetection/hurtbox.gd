class_name Hurtbox extends Area2D

signal hurtbox_entered(hitbox: Hitbox)

@export var _is_invincible: bool = false:
	set = set_invincible
	

func get_invincible() -> bool:
	return _is_invincible


func set_invincible(state: bool) -> void:
	if _is_invincible == state:
		return
		
	_is_invincible = state
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.set_deferred("disabled", _is_invincible)
