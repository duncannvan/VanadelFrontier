extends Node2D

# temp
@onready var _base_stats_component = $Base/StatsComponents
@onready var _mob_spawner = get_node_or_null("MobSpawner")
@onready var _base_health_ui: TextureProgressBar = null
@onready var _base_health_bar = $UI/BaseHealthBar/%HealthBar

func _ready() -> void: 	
	#await _base_stats_component.stats_components_ready
	_base_stats_component.get_component(StatsComponents.ComponentKey.HEALTH).connect("died", _on_base_died)
	_base_stats_component.get_component(StatsComponents.ComponentKey.HEALTH).connect("health_changed", _on_health_changed)


func _on_base_died() -> void:
	if _mob_spawner:
		_mob_spawner.disable()


func _on_health_changed() -> void:
	_base_health_bar.update(_base_stats_component.get_component(StatsComponents.ComponentKey.HEALTH).get_health())
