class_name SpeedComponent extends Node

signal slowed_ended

const MAX_SPEED_FACTOR: int = 1
const MIN_SPEED_FACTOR: int = 0
const MAX_SPEED: int = 100
const MIN_SPEED: int = 1

var _slowed_timer: Timer = null
var _slowed_factor: float = MAX_SPEED_FACTOR
var _base_speed = 0


func _ready() -> void:
	_slowed_timer = Timer.new()
	add_child(_slowed_timer)
	_slowed_timer.timeout.connect(_on_slowed_timer_timeout)


func _init(speed: int) -> void: 
	_base_speed = clampi(speed, MIN_SPEED, MAX_SPEED)


func apply_slow(slowed_factor: float, slow_duration: float) -> void:
	if not _slowed_timer || slow_duration <= 0:
		return
	
	_slowed_timer.start(slow_duration)
	
	if(_slowed_factor != slowed_factor):
		_slowed_factor = clamp(slowed_factor, MIN_SPEED_FACTOR, MAX_SPEED_FACTOR)


func _on_slowed_timer_timeout() -> void:
	slowed_ended.emit()
	_slowed_factor = MAX_SPEED_FACTOR
	
	
func get_current_speed() -> float:
	return _base_speed * _slowed_factor
