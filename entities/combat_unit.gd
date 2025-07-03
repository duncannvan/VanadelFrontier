class_name CombatUnit extends CharacterBody2D

const BLINK_TIME : float = 0.1 
const TIME_BEFORE_DESPAWN : int = 3

var _speed: int

@export var _sprite: AnimatedSprite2D
@export var _hurtbox: HurtBox
@export var entity_data: EntityStats


func _ready() -> void:
	if not entity_data:
		push_error("EntityStats is not assigned!")
		return
	
	_init_data()


func _init_data() -> void:
	_speed = entity_data.speed
	

func _check_nodes():
	assert(_sprite, "%s missing sprite" % self)
	assert(_hurtbox, "%s missing hurtbox" % self)


func _emit_hurt_effects(color := Color.WHITE) -> void:
	_sprite.modulate = Color(10,10,10,10)
	await get_tree().create_timer(BLINK_TIME).timeout
	_sprite.modulate = Color(1, 1, 1)
	await get_tree().create_timer(BLINK_TIME).timeout


func apply_knockback(
	knockback_vector := Vector2.ZERO, 
	knockback_duration: float = 0.0
	) -> void:
	velocity = knockback_vector
	await get_tree().create_timer(knockback_duration).timeout
	velocity = Vector2.ZERO


func take_damage() -> void:
	_emit_hurt_effects()


# Override in child
func _on_death() -> void: 
	pass


func _die() -> void:
	_on_death()
	_speed = 0
	_sprite.stop()
	
	_hurtbox.off()
	
	queue_free()
