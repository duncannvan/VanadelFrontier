extends Node2D

const SPAWN_TIMER = 2
@export var max_mobs: int = 2

@export var _base: Node2D
@export var _player: Player
@export var _mob_scenes: Array[PackedScene] 

var _count: int = 0 
var _enabled: bool

@onready var mob_spawn_timer = $MobSpawnTimer


func _ready() -> void:
	mob_spawn_timer.connect("timeout", _on_spawn_mobs_timer_timeout)
	

func _on_spawn_mobs_timer_timeout() -> void:
	if _count >= max_mobs:
		return
	
	for mob_scene in _mob_scenes:
		var mob: Mob = mob_scene.instantiate()
		if mob.get_targeting_type() == mob.TargetingType.BASE:
			if _base:
				mob.set_target(_base) 
		elif mob.get_targeting_type() == mob.TargetingType.PLAYER:
			if _player:
				mob.set_target(_player)
				
		mob.global_position = global_position
		
		owner.add_child(mob)
		_count += 1
	
		mob.tree_exited.connect(_on_slime_removed)


func _on_slime_removed():
	_count -= 1


func disable() -> void:
	mob_spawn_timer.stop()
	
