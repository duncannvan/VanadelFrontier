extends Node2D

@onready var mob_detector = $MobDetector
@onready var _stats_component = $StatsComponents


func _ready() -> void:
	mob_detector.connect("body_entered", _on_body_entered)
	_stats_component.connect("died", _on_died)
	

func _on_body_entered(body: Mob) -> void:
	var remaining_health: int = body.get_health()
	_stats_component.apply_damage(remaining_health)
	
	if body:
		body.queue_free()


func _on_died() -> void:
	Global.game_over.emit()
