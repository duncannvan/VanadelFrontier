class_name StatsComponents extends Node

enum ComponentKey{HEALTH, SPEED}

@export var _stats: StatsSheet = null
var _speed_component: SpeedComponent = null
var _health_component: HealthComponent = null
var _components_lookup_table: Dictionary[ComponentKey, Node]


func _ready() -> void:
	assert(_stats, "Must assign a stats resouce to the stats component")
	
	_health_component = HealthComponent.new(_stats._full_health) if (_stats._full_health != StatsSheet.UNINITIALIZED) else null
	_speed_component = SpeedComponent.new(_stats._speed) if (_stats._speed != StatsSheet.UNINITIALIZED) else null

	_components_lookup_table = {ComponentKey.HEALTH: _health_component, ComponentKey.SPEED: _speed_component}
	
	for key in _components_lookup_table:
		add_child(_components_lookup_table[key])
		await _components_lookup_table[key]
		
		
func get_component(key: ComponentKey):
	if !_components_lookup_table[key]:
		push_error("Attempt to access null component")
		return
		
	return _components_lookup_table[key]
