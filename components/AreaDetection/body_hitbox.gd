class_name BodyHitbox extends HitBox

const DAMAGE_INTERVAL := 0.5


func _enter_tree() -> void:
	if owner is Player:
		collision_layer = 0x10
		collision_mask = 0x20
	elif owner is Mob:
		collision_layer = 0X40
		collision_mask = 0x8


func _on_area_entered(hurtbox: HurtBox) -> void:
	while has_overlapping_areas():
		super(hurtbox)
		await get_tree().create_timer(DAMAGE_INTERVAL).timeout
