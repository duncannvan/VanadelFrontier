class_name Tower extends StaticBody2D

@export var _tower_resource: TowerResource = null
@export var _enabled: bool = true # Debug build only
var _current_target: Mob = null
var _mobs_in_range: Array[Mob] = []

@onready var _fire_rate_timer: Timer = $FireRateTimer
@onready var _atk_range: Area2D = $Range


func _ready() -> void:
	_atk_range.body_entered.connect(_on_body_entered)
	_atk_range.body_exited.connect(_on_body_exited)
	_fire_rate_timer.timeout.connect(_on_shoot_timer_timeout)


func _on_body_exited(mob: Mob) -> void:
	_mobs_in_range.erase(mob)
	_current_target = null


func _on_body_entered(mob: Mob) -> void:
	if not _enabled: return
	_mobs_in_range.append(mob)
	if not _current_target:
		_current_target = mob
		_fire_rate_timer.start()

	
func _on_shoot_timer_timeout() -> void:
	if _mobs_in_range:
		_current_target = _mobs_in_range[0]
		
	if _current_target:
		_spawn_projectile()
	else:
		_fire_rate_timer.stop()
	
	
func _spawn_projectile() -> void:
	var projectile: TowerProjectile = _tower_resource.projectile.instantiate()
	projectile.global_position = global_position
	projectile.look_at(_current_target.position)
	projectile.set_attack_effects(_tower_resource.atk_effects)
	projectile.set_target(_current_target)
	get_parent().add_child(projectile)
	
