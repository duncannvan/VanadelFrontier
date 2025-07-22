extends Control

@onready var _health_bar: TextureProgressBar = $HealthBar

func update(health: int) -> void:
	_health_bar.value = health
