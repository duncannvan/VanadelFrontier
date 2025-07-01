class_name BodyHitbox extends HitBox

var player_in_body_hitbox: bool = false


func _ready() -> void:
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)


func _on_area_entered(hurtbox: HurtBox) -> void:
	# DOT if player stays in body hitbox
	if body_hitbox:
		var player: CharacterBody2D = hurtbox.get_parent()
		player_in_body_hitbox = true
		while player_in_body_hitbox:
			player.take_damage(damage)
			await get_tree().create_timer(DAMAGE_INTERVAL).timeout


func _on_area_exited(hurtbox: HurtBox) -> void:
	player_in_body_hitbox = false
