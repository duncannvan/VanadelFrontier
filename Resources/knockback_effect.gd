class_name KnockbackEffect extends AttackEffect

@export var _knockback_force: int = 200
@export var _knockback_duration := 0.1


func apply_knockback(target: Node2D, hitbox_position: Vector2 = Vector2.ZERO) -> void:
	var knockback_dir: Vector2 = hitbox_position.direction_to(target.global_position)
	var knockback_vector = knockback_dir * _knockback_force
	
	if target.has_method("apply_knockback"):
		target.apply_knockback(knockback_vector, _knockback_duration)
