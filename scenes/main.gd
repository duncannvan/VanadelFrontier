extends Node2D

func _on_timer_timeout() -> void:
	if _count >= MAX_SLIMES:
		return
	
	var slime: Slime = _slime_scene.instantiate()
	slime.base_target = _base
	slime.current_target = _base
	
	add_child(slime)
	_count += 1
	
	# Connect to slime's death/removal signal to decrement counter
	slime.tree_exited.connect(_on_slime_removed)

func _on_slime_removed():
	_count -= 1
	
# Private members
@export var _player: Player
@export var _base: Node2D


var _count: int = 0 
var _slime_scene: PackedScene= preload("res://entities/enemies/slime/slime.tscn")

# Constants
const SPAWN_TIMER = 2
const MAX_SLIMES = 3
