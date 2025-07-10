class_name SpeedComponent extends Node2D

@export var speed: int = 50

var _slowed: bool = false
var slow_timer: Timer

func apply_slow(speed_lost: int, slow_duration: float):
	if _slowed: 
		slow_timer.start()
		return
		
	_slowed = true
	var cur_speed = speed
	speed -= speed_lost
	var slow_timer = await get_tree().create_timer(slow_duration).timeout
	speed = cur_speed
	_slowed = false
