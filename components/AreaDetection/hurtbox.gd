class_name HurtBox extends Area2D

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
		

func off() -> void:
	get_node("CollisionShape2D").set_deferred("disabled", true)
	
	
func on() -> void:
	get_node("CollisionShape2D").set_deferred("disabled", false)
	
	
