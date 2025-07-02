class_name HurtBox extends Area2D

func _ready() -> void:
	connect("area_entered", _on_area_entered)
	
	
func _on_area_entered(hitbox: HitBox):
	var knockback_dir: Vector2 = (owner.global_position - hitbox.get_parent().global_position).normalized()
	var knockback_vector = knockback_dir * hitbox.knockback_force
	
	
	if owner.has_method("take_damage"):
		owner.take_damage(
			hitbox.damage, 
			knockback_vector,
			hitbox.knockback_duration
			)


func off() -> void:
	get_node("CollisionShape2D").set_deferred("disabled", true)
