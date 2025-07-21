class_name HealthComponent extends Node

signal health_changed()
signal died()

var _health: int = 0


func _init(full_health: int) -> void:
	_health = clampi(full_health, StatsSheet.MIN_HEALTH, StatsSheet.MAX_HEALTH)


func apply_damage(damage: int) -> void:
	if damage < StatsSheet.MIN_HEALTH:
		return
		
	_health -= damage
	emit_signal("health_changed")
	
	if _health < StatsSheet.MIN_HEALTH:
		emit_signal("died")


func get_health() -> int: 
	return _health
