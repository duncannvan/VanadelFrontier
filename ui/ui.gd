extends Control

@export var _player: Player
@export var _heart_scene: PackedScene

@onready var _heart_container: Container = $MarginContainer/HeartContainer

func _ready() -> void:
	_player.health_changed.connect(_on_health_changed)
	_on_health_changed(_player.health)


func _on_health_changed(health: int) -> void:
	for child in _heart_container.get_children():
		child.queue_free()

	for i in range(int(health / 10)):
		var heart = _heart_scene.instantiate()
		_heart_container.add_child(heart)
