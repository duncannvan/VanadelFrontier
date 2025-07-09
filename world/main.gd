extends Node2D

# temp
@onready var base_health_component = $Base/HealthComponent
@onready var mob_spawner = get_node_or_null("MobSpawner")
@onready var base_health_ui: TextureProgressBar
@onready var base_health_bar = $UI/BaseHealthBar/%HealthBar

func _ready() -> void: 
	#_on_health_changed(0, base_health_component.get_max_health()) # init health bar
	
	base_health_component.connect("died", _on_base_died)
	base_health_component.connect("health_changed", _on_health_changed)


func _on_base_died() -> void:
	if mob_spawner:
		mob_spawner.disable()


func _on_health_changed() -> void:
	base_health_bar.update(base_health_component.get_health())
