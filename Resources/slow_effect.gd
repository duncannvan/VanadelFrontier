class_name SlowEffect extends AttackEffect

@export var slow_amount: int = 20
@export var slow_duration: float = 0.3


func apply(target: CombatUnit) -> void:
	if target.has_method("apply_slow"):
		target.apply_slow(slow_amount, slow_duration)
