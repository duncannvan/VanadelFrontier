extends Node

signal game_over

func _ready() -> void:
	game_over.connect(_on_game_over)


func _on_game_over() -> void:
	call_deferred("change_to_game_over_scene")


func change_to_game_over_scene():
	get_tree().change_scene_to_file("res://GameOver.tscn")
