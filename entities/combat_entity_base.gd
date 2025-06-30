class_name CombatEntityBase extends CharacterBody2D

#Constructor
func _init(entityInfo: Dictionary) -> void:	
	#Set member variables and defaults
	_health 	   = entityInfo.get("health", 100)
	_speed 		   = entityInfo.get("speed", 100)
	_damage 	   = entityInfo.get("damage", 50)
	_knockback_mag = entityInfo.get("knockback_mag", 200)
	
func _set_nodes(sprite: AnimatedSprite2D, hurtbox: Area2D, hitbox: Area2D):
	assert(sprite and hurtbox and hitbox)
	_sprite = sprite
	_hurtbox = hurtbox
	_hitbox = hitbox

# Apply knockback vector to entity for n seconds
func _apply_knockback(knockbackDirection: Vector2) -> void:
		is_knockback = true
		if not knockbackDirection:
			knockbackDirection = -Vector2.RIGHT.rotated(rotation) 
			
		print(knockbackDirection)
		velocity = knockbackDirection.normalized() * _knockback_mag
		await get_tree().create_timer(BLINK_TIME).timeout
		velocity = Vector2.ZERO
		is_knockback = false
		#TODO: play knockback animation

# Blink the entity to represent damage taken
func _blink_hurt() -> void:
	assert(_sprite)
	_sprite.modulate = Color(10,10,10,10)
	await get_tree().create_timer(BLINK_TIME).timeout
	_sprite.modulate = Color(1, 1, 1) 
	await get_tree().create_timer(BLINK_TIME).timeout
	
# Damage handler 
func _upon_hit(damageAmount: int, knockbackDirection: Vector2) -> void:
	_health -= damageAmount
	if _health <= 0: 
		_die()
	_apply_knockback(knockbackDirection)
	_blink_hurt()
	
# Death handler
func _die() -> void:
	assert(_sprite and _hitbox and _hurtbox)
	#TODO: Play death animation
	_speed = 0
	_sprite.stop()
	_hitbox.monitoring = false
	_hurtbox.set_deferred("monitorable", false) #Cannot update physic componement mid processing so wait until frame is complete to update
	
	if _sprite.sprite_frames.has_animation("dead"):
		_sprite.play("dead")
	
	await get_tree().create_timer(TIME_BEFORE_DESPAWN).timeout
	
	self.queue_free()
	
# Private members
var _health: int
var _speed: int
var _damage: int
var _knockback_mag: int
var _sprite: AnimatedSprite2D
var _hurtbox: Area2D
var _hitbox: Area2D
var is_knockback = false
# Constants
const BLINK_TIME : float = .1 
const TIME_BEFORE_DESPAWN : int = 2
