class_name SpeedComponent extends Node2D

@export var speed: int = 50

var _slowed: bool = false
var _slow_timer: Timer
var temp_speed: int # Holds current speed value before applying slow 

func _ready():
	_slow_timer = Timer.new()
	add_child(_slow_timer)
	
	_slow_timer.timeout.connect(_on_slow_timer_timeout)


func apply_slow(slow_percentage: float, slow_duration: float):
	if _slowed: 
		_slow_timer.start()
		return
		
	temp_speed = speed
	_slowed = true
	owner.modulate = Color.PURPLE
	speed *= slow_percentage
	_slow_timer.start()


func _on_slow_timer_timeout() -> void:
	speed = temp_speed
	_slowed = false
	owner.modulate = Color.WHITE
