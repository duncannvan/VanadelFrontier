class_name BodyHitbox extends HitBox

const DAMAGE_INTERVAL: float = 0.5


func _ready() -> void:
	connect("area_entered", _on_area_entered)


func _on_area_entered(hurtbox: HurtBox) -> void:
	pass
	# DOT if player stays in body hitbox
	var player: CharacterBody2D = hurtbox.get_parent()
	var knockback_direction = -player.facing_direction 
	var knockback_vector = knockback_direction * knockback_force
	
	while has_overlapping_areas():
		player.take_damage(
			damage, 
			knockback_vector,
			knockback_duration
			)
		await get_tree().create_timer(DAMAGE_INTERVAL).timeout
