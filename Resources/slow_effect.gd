class_name SlowEffect extends AttackEffect

@export var speed_lost: int
@export var slow_duration: float


func apply(target: CombatUnit) -> void:
	if target.has_method("apply_slow"):
		target.apply_slow(speed_lost, slow_duration)
