class_name StatsComponents extends Node

enum ComponentKey{HEALTH, SPEED}

@export var _stats: StatsSheet = null
var _speed_component: SpeedComponent = null
var _health_component: HealthComponent = null
var _components_lookup_table: Dictionary
var _is_ready: bool = false

func _ready() -> void:
	assert(_stats, "Must assign a stats resouce to the stats component")
	_speed_component = SpeedComponent.new(_stats._speed)
	add_child(_speed_component)
	_health_component = HealthComponent.new(_stats._full_health)
	add_child(_health_component)
	_components_lookup_table = {ComponentKey.HEALTH: _health_component, ComponentKey.SPEED: _speed_component}
	_is_ready = true

func get_component(key: ComponentKey):
	return _components_lookup_table[key]

func is_ready() -> bool:
	return _is_ready
