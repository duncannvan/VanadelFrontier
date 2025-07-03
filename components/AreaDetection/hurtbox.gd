class_name HurtBox extends Area2D

@export var _health_component: HealthComponent


#func _ready() -> void:
	#connect("area_entered", _on_area_entered)
#
#
#func _on_area_entered(hitbox: HitBox):
	#if _health_component:		
		#_health_component.take_damage(hitbox.damage)


func off() -> void:
	get_node("CollisionShape2D").set_deferred("disabled", true)


func has_health_component() -> bool:
	return !!_health_component


func get_health_component() -> HealthComponent:
	return _health_component
