class_name CombatEntityBase extends CharacterBody2D

var health = 100
var speed = 0
var damage = 10
var sprite: AnimatedSprite2D
var hurtbox: Area2D
var hitbox: Area2D

const KNOCKBACK_MAGNITUDE = 200
const KNOCKBACK_TIME = .1 
const TIME_BEFORE_DESPAWN = 2
var is_knockback: bool = false

func _apply_knockback(knockbackDirection: Vector2):
		is_knockback = true
		velocity = knockbackDirection.normalized() * KNOCKBACK_MAGNITUDE

		await get_tree().create_timer(KNOCKBACK_TIME).timeout
		is_knockback = false
		velocity = Vector2.ZERO
		
		#TODO: play knockback animation

func take_damage(damageAmount: int, knockbackDirection: Vector2 = Vector2.ZERO):
	health -= damageAmount
	if health > 0:
		
		if not knockbackDirection.is_normalized(): 
			knockbackDirection = knockbackDirection.normalized()
		_apply_knockback(knockbackDirection)
	else:
		_die()
	print(health)
func _die() -> void:
	#TODO: Play death animation
	speed = 0
	sprite.stop()
	hitbox.monitoring = false
	hurtbox.monitoring = false
	
	# Move camera outside player
	if has_node("Camera2D"):
		var camera = $Camera2D
		camera.get_parent().remove_child(camera)
		get_tree().root.add_child(camera)

	
	await get_tree().create_timer(TIME_BEFORE_DESPAWN).timeout
	self.queue_free()
	

	
