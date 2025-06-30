extends Control

func _ready() -> void:
	_player.health_changed.connect(_on_health_changed)
	_on_health_changed(_player._health)
	
func _on_health_changed(health: int) -> void:
	for child in _heart_container.get_children():
		child.queue_free()

	for i in range(int(health / 10)):
		var heart = _heart_scene.instantiate()
		_heart_container.add_child(heart)

# Private members
@export var _player: Player
@onready var _heart_container: Container = $HeartContainer
@export var _heart_scene: PackedScene
		
