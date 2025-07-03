class_name HealthComponent extends Node

signal health_changed(old_health, new_health)
signal died()

@export var _max_health: int = 100

var _health: int
var _is_invincible: bool


func _ready() -> void:
	_health = _max_health


func take_damage(damage: int) -> void:
	if _is_invincible: return
	
	var old_health = _health
	_health -= damage
	emit_signal("health_changed", old_health, _health)
	
	if _health <= 0:
		emit_signal("died")
		
		
func give_invincibility() -> void:
	_is_invincible = true

	
func disable_invincibility() -> void:
	_is_invincible = false
	

func get_max_health() -> int: 
	return _max_health


func get_health() -> int: 
	return _health
