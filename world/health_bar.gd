class_name health_bar extends TextureProgressBar

@export var health_component: HealthComponent


func _ready() -> void:
	health_component.connect("health_changed", _on_health_changed)


func _on_health_changed(old_health: int, new_health: int) -> void:
	value = new_health
