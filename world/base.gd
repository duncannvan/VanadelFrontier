extends Node2D


@onready var mob_detector = $MobDetector
@onready var health_component = $HealthComponent


func _ready() -> void:
	mob_detector.connect("body_entered", _on_body_entered)
	

func _on_body_entered(body: Mob) -> void:
	var remaining_health: int = body.get_health()
	health_component.take_damage(remaining_health)
	
	if body:
		body.queue_free()
