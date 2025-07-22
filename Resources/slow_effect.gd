class_name SlowEffect extends AttackEffect

const MAX_SLOWED_FACTOR: float = 1
const MIN_SLOWED_FACTOR: float = 0

@export_range(MIN_SLOWED_FACTOR, MAX_SLOWED_FACTOR) var slowed_factor: float = 0.5
@export var slowed_duration: float = 1.0


func apply(target: CombatUnit, hitbox_position: Vector2 = Vector2.ZERO) -> void:
	if target.has_method("apply_slow"):
		target.apply_slow(slowed_factor, slowed_duration)
