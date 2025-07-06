class_name Tower extends StaticBody2D

@export var projectile_scene: PackedScene
@export var _enabled: bool = true

var _current_target: Mob = null
var _mobs_in_range: Array[Mob]

@onready var _shoot_timer: Timer = $ShootCooldown
@onready var _aggro_range: Area2D = $AggroRange


func _ready() -> void:
	_aggro_range.connect("body_entered", _on_body_entered)
	_aggro_range.connect("body_exited", _on_body_exited)
	_shoot_timer.connect("timeout", _on_shoot_timer_timeout)


func _on_body_exited(mob: Mob) -> void:
	_mobs_in_range.erase(mob)
	_current_target = null


func _on_body_entered(mob: Mob) -> void:
	if not _enabled: return
	_mobs_in_range.append(mob)
	if not _current_target:
		_current_target = mob
		_shoot_timer.start()

	
func _on_shoot_timer_timeout() -> void:
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
	
