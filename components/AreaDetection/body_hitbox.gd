class_name BodyHitbox extends HitBox

const DAMAGE_INTERVAL := 0.5


func _on_area_entered(hurtbox: HurtBox) -> void:
	while has_overlapping_areas():
		super(hurtbox)
		await get_tree().create_timer(DAMAGE_INTERVAL).timeout
