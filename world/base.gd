extends Node2D


@onready var mob_detector = $MobDetector
@onready var health_component = $HealthComponent


func _ready() -> void:
	mob_detector.connect("body_entered", _on_body_entered)
	health_component.connect("died", _on_died)
	

func _on_body_entered(body: Mob) -> void:
	var remaining_health: int = body.get_health()
	health_component.take_damage(remaining_health)
	
	if body:
		body.queue_free()


func _on_died() -> void:
	call_deferred("change_to_game_over_scene")


func change_to_game_over_scene():
	get_tree().change_scene_to_file("res://GameOver.tscn")
