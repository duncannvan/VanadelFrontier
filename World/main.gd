extends Node2D

# temp
@onready var _base_stats_component = $Base/StatsComponents
@onready var _mob_spawner = get_node_or_null("MobSpawner")
@onready var _base_health_ui: TextureProgressBar = null
@onready var _base_health_bar = $UI/BaseHealthBar

func _ready() -> void: 	
	_base_stats_component.connect("died", _on_base_died)
	_base_stats_component.connect("health_changed", _on_health_changed)


func _on_base_died() -> void:
	if _mob_spawner:
		_mob_spawner.disable()


func _on_health_changed() -> void:
	_base_health_bar.update(_base_stats_component.get_health())
