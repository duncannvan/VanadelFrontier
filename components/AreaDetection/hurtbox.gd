class_name HurtBox extends Area2D

signal hurt(hitbox)

@export var is_invincible: bool = false :
	set(value):
		is_invincible = value
		for child in get_children():
			if child is not CollisionShape2D: continue
			child.set_deferred("disabled", is_invincible)

#func receive_hit(hitbox: HitBox, attack_effects: Array[AttackEffect]):
	#if is_invincible: return
	#for effect in attack_effects:
		#var args = effect.get_method_argument_count("apply")
		#
		#if effect is KnockbackEffect:
			#effect.apply_knockback(owner, hitbox.global_position)
		#else:
			#effect.apply(owner)
