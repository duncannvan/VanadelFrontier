extends Node2D


func _on_timer_timeout() -> void:
	if _count >= MAX_SLIMES:
		return
	if not _player:
		$Timer.stop()
	
	var slime: Slime = _slime_scene.instantiate()
	slime.target = _player
	add_child(slime)
	_count += 1
	
	# Connect to slime's death/removal signal to decrement counter
	slime.tree_exited.connect(_on_slime_removed)

func _on_slime_removed():
	_count -= 1
	
# Private members
@export var _player: Player
var _count: int = 0 
var _slime_scene: PackedScene= preload("res://entities/enemies/slime/slime.tscn")

# Constants
const SPAWN_TIMER = 2
const MAX_SLIMES = 3
