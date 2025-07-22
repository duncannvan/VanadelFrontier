class_name HealthComponent extends Node

signal health_changed()
signal died()

const MAX_HEALTH: int = 10
const MIN_HEALTH: int = 1

@export_range(MIN_HEALTH, MAX_HEALTH) var _full_health: int = MIN_HEALTH

var _health: int = _full_health 


func _ready() -> void:
	_health = clampi(_full_health, MIN_HEALTH, MAX_HEALTH)


func apply_damage(damage: int) -> void:
	if damage < MIN_HEALTH:
		return
		
	_health -= damage
	emit_signal("health_changed")
	
	if _health < MIN_HEALTH:
		emit_signal("died")


func get_full_health() -> int: 
	return _full_health


func get_health() -> int: 
	return _health
