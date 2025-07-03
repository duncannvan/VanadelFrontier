class_name Tower extends StaticBody2D

@export var _shoot_timer: Timer
@export var _aggro_range: Area2D
@export var projectile_scene: PackedScene

var _current_target: CombatUnit = null


func _ready() -> void:
	_aggro_range.connect("body_entered", _on_body_entered)


func _on_body_entered(mob: CombatUnit) -> void:
	if not _current_target:
		_current_target = mob
		_shoot_timer.start()

	
func _on_shoot_timer_timeout() -> void:
	if not _current_target: 
		var _mobs_in_range: Array[Node2D] = _aggro_range.get_overlapping_bodies()
		if _mobs_in_range:
			_current_target = _mobs_in_range[0]
		
	if _current_target:
		_spawn_projectile()
	else:
		_shoot_timer.stop()
	
	
func _spawn_projectile() -> void:
	var p = projectile_scene.instantiate()
	p.global_position = global_position
	p.look_at(_current_target.position)
	p.target = _current_target
	get_parent().add_child(p)
	
