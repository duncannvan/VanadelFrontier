## Make sure to set mask to hitbox layer
class_name HurtBox extends Area2D

@export var _health_component: HealthComponent
#@export var invincibility_time: float = 0.5


func _enter_tree() -> void:
	if owner is Player:
		collision_layer = 0x8
		collision_mask = 0x40
	elif owner is Mob:
		collision_layer = 0X20
		collision_mask = 0x10


func receive_hit(hitbox: HitBox, attack_effects: Array[AttackEffect]):
	for effect in attack_effects:
		var args = effect.get_method_argument_count("apply")
		
		effect.apply(owner, hitbox.global_position)
		
	# I-frames
	#off()
	#if owner.has_method("give_invincibility"):
		#owner.give_invincibility()
	#await get_tree().create_timer(invincibility_time).timeout
	#if owner.has_method("disable_invincibility"):
		#owner.disable_invincibility()
	#on()


func off() -> void:
	get_node("CollisionShape2D").set_deferred("disabled", true)
	
	
func on() -> void:
	get_node("CollisionShape2D").set_deferred("disabled", false)
	
	
