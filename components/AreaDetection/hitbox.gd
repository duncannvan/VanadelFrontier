class_name HitBox extends Area2D

@export var _attack_effects: Array[AttackEffect]

func _ready() -> void:
	if owner is Player:
		collision_layer = 0x10
		collision_mask = 0x20
	elif owner is Mob:
		collision_layer = 0x40
		collision_mask = 0x8
		
	connect("area_entered", _on_area_entered)


func _on_area_entered(hurtbox: HurtBox) -> void:
	hurtbox.receive_hit(self, _attack_effects)


func on() -> void:	
	$CollisionShape2D.set_deferred("disabled", false)


func off() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
