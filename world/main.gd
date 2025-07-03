extends Node2D

# temp
@onready var base_health_component = $Base/HealthComponent
@onready var mob_spawner = $MobSpawner

func _ready() -> void: 
	base_health_component.connect("died", _on_base_died)



func _on_base_died() -> void:
	print("GAME OVER")
	mob_spawner.disable()
