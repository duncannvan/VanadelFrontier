class_name SpeedComponent extends Node2D

signal slowed_ended

const MAX_SPEED_FACTOR: int = 1
const MIN_SPEED_FACTOR: int = 0

@export var normal_speed: float = 50

var _slowed_timer: Timer = null
var _slowed_factor: float = MAX_SPEED_FACTOR

func _ready() -> void:
	_slowed_timer = Timer.new()
	add_child(_slowed_timer)
	_slowed_timer.timeout.connect(_on_slowed_timer_timeout)


func apply_slow(slowed_factor: float, slow_duration: float) -> void:
	if not _slowed_timer || slow_duration <= 0:
		return
	
	_slowed_timer.start(slow_duration)
	
	if(slowed_factor != _slowed_factor):
		_slowed_factor = clamp(slowed_factor, MIN_SPEED_FACTOR, MAX_SPEED_FACTOR)


func _on_slowed_timer_timeout() -> void:
	slowed_ended.emit()
	_slowed_factor = MAX_SPEED_FACTOR
	
	
func get_current_speed() -> float:
	return normal_speed * _slowed_factor
