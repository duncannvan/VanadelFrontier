class_name StatsComponents extends Node

signal slowed_ended
signal health_changed()
signal died()

@export var _stats: StatsSheet = null

var _slowed_timer: Timer = null
var _slowed_factor: float = SlowEffect.MAX_SLOWED_FACTOR


func _ready() -> void:
	_slowed_timer = Timer.new()
	add_child(_slowed_timer)
	_slowed_timer.timeout.connect(_on_slowed_timer_timeout)
	

func apply_slow(slowed_factor: float, slow_duration: float) -> void:
	if not _slowed_timer || slow_duration <= 0:
		return
	
	_slowed_timer.start(slow_duration)
	
	if(_slowed_factor != slowed_factor):
		_slowed_factor = clampf(slowed_factor, SlowEffect.MIN_SLOWED_FACTOR, SlowEffect.MAX_SLOWED_FACTOR)


func _on_slowed_timer_timeout() -> void:
	slowed_ended.emit()
	_slowed_factor = SlowEffect.MAX_SLOWED_FACTOR
	
	
func get_current_speed() -> float:
	return _stats.speed * _slowed_factor


func apply_damage(damage: int) -> void:
	if damage < StatsSheet.MIN_HEALTH_CAP:
		return

	_stats.health -= damage
	emit_signal("health_changed")
	if _stats.health < StatsSheet.MIN_HEALTH_CAP:
		emit_signal("died")


func get_health() -> int: 
	return _stats.health
