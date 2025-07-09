class_name HurtBox extends Area2D

const PLAYER_HURTBOX_LAYER = 0x8
const PLAYER_HURTBOX_MASK = 0x40
const MOB_HURTBOX_LAYER = 0x20
const MOB_HURTBOX_MASK = 0x10

@export var is_invincible: bool = false 
#:
	#set(value):
		#is_invincible = value
		#for child in get_children():
			#if child is not CollisionShape2D: continue
			#child.set_deferred("disabled", is_invincible)


func _ready() -> void:
	if owner is Player:
		collision_layer = PLAYER_HURTBOX_LAYER
		collision_mask = PLAYER_HURTBOX_MASK
	elif owner is Mob:
		collision_layer = MOB_HURTBOX_LAYER
		collision_mask = MOB_HURTBOX_MASK


func receive_hit(hitbox: HitBox, attack_effects: Array[AttackEffect]):
	if is_invincible: return
	for effect in attack_effects:
		var args = effect.get_method_argument_count("apply")
		
		if effect is KnockbackEffect:
			effect.apply_knockback(owner, hitbox.global_position)
		else:
			effect.apply(owner)


func off() -> void:
	get_node("CollisionShape2D").set_deferred("disabled", true)
	
	
func on() -> void:
	get_node("CollisionShape2D").set_deferred("disabled", false)
	
	
