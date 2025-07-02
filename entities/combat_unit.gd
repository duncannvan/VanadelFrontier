class_name CombatUnit extends CharacterBody2D

const BLINK_TIME : float = 0.1 
#const KNOCKBACK_DURATION: float = 0.1
const TIME_BEFORE_DESPAWN : int = 3

@export var health: int = 100
@export var speed: int = 100
#@export var knockback_force: int = 200

var _sprite: AnimatedSprite2D
var _hurtbox: Area2D


# Constructor
#func _init(entityInfo: Dictionary) -> void:	
	## Set member variables and defaults
	#_health = entityInfo.get("health", 100)
	#_speed = entityInfo.get("speed", 100)
	#_knockback_force = entityInfo.get("knockback_force", 200)


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


func _apply_knockback(
	knockback_vector := Vector2.ZERO, 
	knockback_duration: float = 0.0
	) -> void:
	velocity = knockback_vector
	await get_tree().create_timer(knockback_duration).timeout
	velocity = Vector2.ZERO


func take_damage(
	damage: int,
	knockback_vector: Vector2 = Vector2.ZERO,
	knockback_duration: float = 0.0
) -> void:
	_hurt_effects()
	health -= damage
	
	_apply_knockback(knockback_vector, knockback_duration)

	if health <= 0: 
		_die()


# Override in child
func _on_death(): 
	pass


func _die() -> void:
	_on_death()
	assert(_sprite and _hurtbox)
	speed = 0
	_sprite.stop()
	
	_hurtbox.off()
	
	queue_free()
