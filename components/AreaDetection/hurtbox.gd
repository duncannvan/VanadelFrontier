class_name HurtBox extends Area2D

func _ready() -> void:
	connect("area_entered", _on_area_entered)
	
	
func _on_area_entered(hitbox: HitBox):
	var knockback_dir: Vector2 = (owner.position - hitbox.get_parent().position).normalized()
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage, knockback_dir)


func off() -> void:
	self.get_node("CollisionShape2D").set_deferred("disabled", true)
