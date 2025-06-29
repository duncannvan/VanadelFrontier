extends Node2D

var slimes = []
var slime_scene: PackedScene= preload("res://scenes/slime.tscn")
const SPAWN_TIMER = 2
const MAX_SLIMES = 10

func _spawn_slimes() -> void:
	while len(slimes) <= MAX_SLIMES:
		var slime = slime_scene.instantiate()
		
		add_child(slime)
		await get_tree().create_timer(SPAWN_TIMER).timeout
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_slimes()
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
