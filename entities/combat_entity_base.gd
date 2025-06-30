class_name CombatEntityBase extends CharacterBody2D

#Constructor
func _init(entityInfo: Dictionary) -> void:	
	#Set member variables and defaults
	_health 	   = entityInfo.get("health", 100)
	_speed 		   = entityInfo.get("speed", 100)
	knockback_force = entityInfo.get("knockback_force", 200)
	
func _init_nodes(sprite: AnimatedSprite2D, hurtbox: HurtBox, hitbox: HitBox, hurt_effects: GPUParticles2D = null):
	assert(sprite and hurtbox and hitbox)
	_sprite = sprite
	_hurtbox = hurtbox
	_hitbox = hitbox
	_hurt_effects = hurt_effects

# Blink the entity to represent damage taken
func _blink_hurt() -> void:
	assert(_sprite)
	_sprite.modulate = Color(10,10,10,10)
	await get_tree().create_timer(BLINK_TIME).timeout
	_sprite.modulate = Color(1, 1, 1) 
	await get_tree().create_timer(BLINK_TIME).timeout
	
	# Apply knockback vector to this entity for n seconds 
func apply_knockback(knockbackDirection: Vector2 = Vector2.ZERO) -> void:
#		# knockback opposite of facing direction
		if not knockbackDirection:
			knockbackDirection = -Vector2.RIGHT.rotated(rotation) 
		
		velocity = knockbackDirection.normalized() * knockback_force
		await get_tree().create_timer(KNOCKBACK_DURATION).timeout
		velocity = Vector2.ZERO
		#TODO: play knockback animation
		
# Damage handler 
func take_damage(damageAmount: int, knockback_dir: Vector2 = Vector2.ZERO) -> void:
	if _hurt_effects:
		_hurt_effects.restart()
		_hurt_effects.emitting = true

	_blink_hurt()
	
	_health -= damageAmount
	if _health <= 0: 
		die()
	
# Death handler
func die() -> void:
	assert(_sprite and _hitbox and _hurtbox)
	#TODO: Play death animation
	_speed = 0
	_sprite.stop()
	
	_hurtbox.off()
	_hitbox.off() # turn off body hitbox for mobs
	
	await get_tree().create_timer(TIME_BEFORE_DESPAWN).timeout
	self.queue_free()
	
# Private members
var _health: int
var _speed: int
var _damage: int
var knockback_force: int
var _sprite: AnimatedSprite2D
var _hurtbox: Area2D
var _hitbox: Area2D
var _hurt_effects: GPUParticles2D

# Constants
const BLINK_TIME : float = .1 
const KNOCKBACK_DURATION: float = .1
const TIME_BEFORE_DESPAWN : int = 3
