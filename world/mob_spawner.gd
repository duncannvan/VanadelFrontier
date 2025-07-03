extends Node2D

const SPAWN_TIMER = 2
const MAX_SLIMES = 3

@export var _base_target: Node2D

var _count: int = 0 
var _slime_scene: PackedScene= preload("res://entities/enemies/slime/slime.tscn")
var _enabled: bool

@onready var mob_spawn_timer = $MobSpawnTimer

func _ready() -> void:
	mob_spawn_timer.connect("timeout", _on_spawn_mobs_timer_timeout)
	

func _on_spawn_mobs_timer_timeout() -> void:
	if _count >= MAX_SLIMES:
		return
	
	var slime: Mob = _slime_scene.instantiate()
	slime.base_target = _base_target
	slime.current_target = _base_target
	slime.global_position = global_position
	
	owner.add_child(slime)
	_count += 1
	
	slime.tree_exited.connect(_on_slime_removed)


func _on_slime_removed():
	_count -= 1


func disable() -> void:
	mob_spawn_timer.stop()
	
