class_name CombatUnit extends CharacterBody2D

const BLINK_TIME : float = 0.1 
#const KNOCKBACK_DURATION: float = 0.1
const TIME_BEFORE_DESPAWN : int = 3

var _max_health: int
var _speed: int
var _health: int 

@export var _sprite: AnimatedSprite2D
@export var _hurtbox: Area2D
@export var entity_data: EntityStats


func _ready() -> void:
	print("spawning")
	if not entity_data:
		push_error("EntityStats is not assigned!")
		return
	
	_init_data()


func _init_data() -> void:
	_max_health = entity_data.max_health
	_speed = entity_data.speed
	_health = _max_health
	print(self, _speed)
	
	
# Constructor
#func _init(entityInfo: Dictionary) -> void:	
	## Set member variables and defaults
	#_max_health = entityInfo.get("max_health", 100)
	#_speed = entityInfo.get("speed", 100)
	#_health = _max_health


func _check_nodes():
	assert(_sprite, "%s missing sprite" % self)
	assert(_hurtbox, "%s missing hurtbox" % self)


func _hurt_effects(color := Color.WHITE) -> void:
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
	_health -= damage
	
	_apply_knockback(knockback_vector, knockback_duration)

	if _health <= 0: 
		_die()


# Override in child
func _on_death() -> void: 
	pass


func _die() -> void:
	_on_death()
	_speed = 0
	_sprite.stop()
	
	_hurtbox.off()
	
	queue_free()


func get_max_health() -> int:
	return _max_health
