class_name MobSpawner extends Node2D

signal wave_cleared

var mobs_in_wave: Array[PackedScene]

@export var _base: Node2D = null
@export var _player: Player = null


func start_wave(wave: Wave):
	mobs_in_wave = wave.mobs
	for i in len(mobs_in_wave):
		var mob_instance = mobs_in_wave.pop_front().instantiate()
		mob_instance.global_position = global_position
		mob_instance.target = _base
		mob_instance.tree_exited.connect(_on_mob_died)
		
		get_tree().root.add_child(mob_instance)
		
		await get_tree().create_timer(wave.spawn_interval).timeout


func _on_mob_died() -> void:
	if get_tree().get_node_count_in_group("mobs") == 0 and mobs_in_wave.is_empty():
		wave_cleared.emit()
