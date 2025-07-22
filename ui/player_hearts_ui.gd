extends Control

@export var _heart_scene: PackedScene = null
@export var _stats_component: StatsComponents = null

@onready var _heart_container: Container = %HeartContainer


func _ready() -> void:
	await _stats_component.ready
	_stats_component.connect("health_changed", _on_health_changed)


func _on_health_changed() -> void:
	for child in _heart_container.get_children():
		child.queue_free()

	for i in range(_stats_component.get_health()):
		var heart = _heart_scene.instantiate()
		_heart_container.add_child(heart)
