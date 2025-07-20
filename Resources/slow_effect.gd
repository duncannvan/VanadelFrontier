class_name SlowEffect extends AttackEffect

@export_range(0, 1) var slowed_factor: float = 0.5
@export var slowed_duration: float = 1.0


func apply(target: CombatUnit, hitbox_position: Vector2 = Vector2.ZERO) -> void:
	if target.has_method("apply_slow"):
		target.apply_slow(slowed_factor, slowed_duration)
