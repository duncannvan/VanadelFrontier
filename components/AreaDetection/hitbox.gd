class_name HitBox extends Area2D

# Create a signal for when the hitbox hits a hurtbox
signal hit_hurtbox(hurtbox)

@export var attack_effects: Array[AttackEffect]

func _ready() -> void:
	connect("area_entered", _on_area_entered)


func _on_area_entered(hurtbox: HurtBox) -> void:
	if hurtbox.is_invincible: return
	# Signal out that we hit a hurtbox (this is useful for destroying projectiles when they hit something)
	hit_hurtbox.emit(hurtbox)
	
	hurtbox.hurt.emit(self)


func on() -> void:	
	$CollisionShape2D.set_deferred("disabled", false)


func off() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
