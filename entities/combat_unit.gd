class_name CombatUnit extends CharacterBody2D

const BLINK_TIME : float = 0.1 
const TIME_BEFORE_DESPAWN : int = 3

@export var _speed: int = 50

var _slowed: bool = false
var slow_timer: Timer

func _check_nodes():
	pass
	#assert(_sprite, "%s missing sprite" % self)


func apply_slow(speed_lost: int, slow_duration: float):
	if _slowed: 
		slow_timer.start()
		return
		
	_slowed = true
	var cur_speed = _speed
	_speed -= speed_lost
	var slow_timer = await get_tree().create_timer(slow_duration).timeout
	_speed = cur_speed
	_slowed = false


# Override in child
func _on_death() -> void: 
	pass


func _die() -> void:
	_on_death()
	queue_free()
