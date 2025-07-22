extends Control

@export var _heart_scene: PackedScene = null
@export var _stats_component: StatsComponents = null

@onready var _hearts_container: Container = $HeartsContainer

func _ready() -> void:
	_stats_component.connect("health_changed", _on_health_changed)
	
	# Initializes hearts
	for i in range(_stats_component.get_health()):
		var heart = _heart_scene.instantiate()
		_hearts_container.add_child(heart)
	
	# Centers horizontally over player depending on width
	await get_tree().process_frame
	_hearts_container.position.x -= (_hearts_container.get_rect().size.x / 2)


func _on_health_changed() -> void:
	for child in _hearts_container.get_children():
		child.queue_free()

	for i in range(_stats_component.get_health()):
		var heart = _heart_scene.instantiate()
		_hearts_container.add_child(heart)
