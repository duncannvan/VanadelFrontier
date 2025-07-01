class_name CombatEntityBase extends CharacterBody2D

const BLINK_TIME : float = 0.1 
const KNOCKBACK_DURATION: float = 0.1
const TIME_BEFORE_DESPAWN : int = 3

var _health: int
var _speed: int
var _damage: int
var _knockback_force: int
var _sprite: AnimatedSprite2D
var _hurtbox: Area2D
var _hitbox: Area2D


# Constructor
func _init(entityInfo: Dictionary) -> void:	
	# Set member variables and defaults
	_health 	   = entityInfo.get("health", 100)
	_speed 		   = entityInfo.get("speed", 100)
	_knockback_force = entityInfo.get("knockback_force", 200)
	
	
func _init_nodes(sprite: AnimatedSprite2D, hurtbox: HurtBox):
	assert(sprite and hurtbox)
	_sprite = sprite
	_hurtbox = hurtbox


func _hurt_effects(color := Color.WHITE) -> void:
	assert(_sprite)
	_sprite.modulate = Color(10,10,10,10)
	await get_tree().create_timer(BLINK_TIME).timeout
	_sprite.modulate = Color(1, 1, 1) 
	await get_tree().create_timer(BLINK_TIME).timeout
	

func _apply_knockback(knockbackDirection := Vector2.ZERO) -> void:
#		# Knockback opposite of facing direction
		if not knockbackDirection:
			knockbackDirection = -Vector2.RIGHT.rotated(rotation) 
		
		velocity = knockbackDirection.normalized() * _knockback_force
		await get_tree().create_timer(KNOCKBACK_DURATION).timeout
		velocity = Vector2.ZERO
		# TODO: play knockback animation
		

func take_damage(damageAmount: int, knockback_dir := Vector2.ZERO) -> void:
	_hurt_effects()
	
	_health -= damageAmount
	if _health <= 0: 
		_die()


# Override in child 
func _on_death(): 
	pass
	
	
func _die() -> void:
	_on_death()
	assert(_sprite and _hurtbox)
	_speed = 0
	_sprite.stop()
	
	_hurtbox.off()
	
	queue_free()
	
