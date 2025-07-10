class_name HurtBox extends Area2D

signal hurt(hitbox)

@export var is_invincible: bool = false :
	set(value):
		is_invincible = value
		for child in get_children():
			if child is not CollisionShape2D: continue
			child.set_deferred("disabled", is_invincible)
