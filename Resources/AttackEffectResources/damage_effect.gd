class_name DamageEffect extends AttackEffect

@export var _damage: int = 1

func apply(target: Node2D, hitbox_position: Vector2 = Vector2.ZERO):
	if target.get_node_or_null("StatsComponents"):
		target.apply_damage(_damage, hitbox_position)
	else:
		push_warning("Attempting to damage entity without stats component")
