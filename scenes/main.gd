extends Node2D

func _spawn_slimes() -> void:
	while len(_slimes) <= MAX_SLIMES:
		var slime = _slime_scene.instantiate()
		slime.target = _player
		add_child(slime)
		await get_tree().create_timer(SPAWN_TIMER).timeout
		
func _ready() -> void:
	_spawn_slimes()

# Private members
@export var _player: Player
var _slimes = []
var _slime_scene: PackedScene= preload("res://entities/enemies/slime/slime.tscn")

# Constants
const SPAWN_TIMER = 2
const MAX_SLIMES = 10
