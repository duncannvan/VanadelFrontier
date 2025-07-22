class_name HealthComponent extends Node

signal health_changed()
signal died()

const MAX_HEALTH: int = 30
const MIN_HEALTH: int = 1

var _health: int = 0


func _init(full_health: int) -> void:
	_health = clampi(full_health, MIN_HEALTH, MAX_HEALTH)


func apply_damage(damage: int) -> void:
	if damage < MIN_HEALTH:
		return
		
	_health -= damage
	emit_signal("health_changed")
	
	if _health < MIN_HEALTH:
		emit_signal("died")


func get_health() -> int: 
	return _health
