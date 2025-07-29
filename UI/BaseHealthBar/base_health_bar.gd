extends Control

@onready var _health_bar: TextureProgressBar = %HealthBar

func initialize(health: int) -> void:
	_health_bar.max_value = health
	_health_bar.value = health

func update(health: int) -> void:
	_health_bar.value = health
