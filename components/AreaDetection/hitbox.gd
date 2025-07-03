class_name HitBox extends Area2D

@export var damage: int = 10
@export var knockback_force: int = 200
@export var knockback_duration := 0.2


func _ready() -> void:
	connect("area_entered", _on_area_entered)
	

func _on_area_entered(hurtbox: HurtBox) -> void:
	var target_hit = hurtbox.owner
	var knockback_dir: Vector2 = global_position.direction_to(target_hit.global_position)
	var knockback_vector = knockback_dir * knockback_force
	
	if target_hit.has_method("apply_knockback"):
		target_hit.apply_knockback(knockback_vector, knockback_duration)
		
	if hurtbox.has_health_component():
		hurtbox.get_health_component().take_damage(damage)
	
	

func on() -> void:	
	$CollisionShape2D.set_deferred("disabled", false)


func off() -> void:
	$CollisionShape2D.set_deferred("disabled", true)

	
