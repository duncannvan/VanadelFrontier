extends Control

@export var _heart_scene: PackedScene


@onready var _heart_container: Container = %HeartContainer
@export var _health_component: HealthComponent

func _ready() -> void:
	_health_component.connect("health_changed", _on_health_changed)
	_on_health_changed(0, _health_component.get_max_health())

func _on_health_changed(old_health: int, new_health: int) -> void:
	for child in _heart_container.get_children():
		child.queue_free()

	for i in range(int(new_health / 10)):
		var heart = _heart_scene.instantiate()
		_heart_container.add_child(heart)
