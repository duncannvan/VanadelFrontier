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
		
func _blink_damage(interval: float = 0.1) -> void:
	sprite.modulate = Color(10,10,10,10)
	await get_tree().create_timer(interval).timeout

	sprite.modulate = Color(1, 1, 1) 
	await get_tree().create_timer(interval).timeout

func take_damage(damageAmount: int, knockbackDirection: Vector2 = Vector2.ZERO):
	health -= damageAmount
	if health <= 0:
		_die()
	
	if not knockbackDirection.is_normalized(): 
		knockbackDirection = knockbackDirection.normalized()
	_apply_knockback(knockbackDirection)
	_blink_damage()

func _die() -> void:
	#TODO: Play death animation
	speed = 0
	sprite.stop()
	hitbox.monitoring = false
	hurtbox.set_deferred("monitorable", false)
	
	await get_tree().create_timer(TIME_BEFORE_DESPAWN).timeout
	# Move camera outside player
	if has_node("Camera2D"):
		var camera: Camera2D = $Camera2D
		var camera_pos = camera.global_position  # Save global position

		camera.get_parent().remove_child(camera)
		get_tree().root.add_child(camera)

		camera.global_position = camera_pos  # Reapply it after reparenting
	self.queue_free()
	

	
