class_name Player extends CombatUnit

signal health_changed(health: int)

enum State {
	IDLE = 0x1, 
	WALKING = 0x2, 
	ATTACKING = 0x4, 
	KNOCKEDBACK = 0x8, 
	INVINCIBLE = 0x10, 
	DEAD = 0x20
}

const NUM_HEALTH_PER_HEART: int = 10

@export var invincibility_time: float = 1.0

var _state: State = State.IDLE
var facing_direction := Vector2.DOWN

@onready var _hitbox = $HitBox

 
func _physics_process(delta) -> void:
	#if not _is_state(State.KNOCKEDBACK):
		#_get_input()
		
	move_and_slide()


# Called when there is an input event
func _input(event: InputEvent) -> void:
	if _is_state(State.DEAD) or _is_state(State.KNOCKEDBACK): return
	assert(_hitbox)
	
	var direction = Input.get_vector("left", "right", "up", "down")
	_walk_handler(direction)
	
	if event.is_action_pressed("attack") and not _is_state(State.ATTACKING):
		_attack_handler()


func _on_damage_taken() -> bool:
	if _is_state(State.DEAD) or _is_state(State.INVINCIBLE):
		return false
		
	_give_invincibility()
	health_changed.emit(_health) # updates gui
	return true
	
func take_damage(
	damage: int,
	knockback_vector: Vector2 = Vector2.ZERO,
	knockback_duration: float = 0.0
) -> void:
	if _is_state(State.DEAD) or _is_state(State.INVINCIBLE): return
	_give_invincibility()
	super(damage, knockback_vector, knockback_duration)

	health_changed.emit(_health) # updates gui


func _apply_knockback(
	knockback_vector := Vector2.ZERO, 
	knockback_duration: float = 0.0
	) -> void:
	# TODO: play knockback animation
	_sprite.stop()
	_add_state(State.KNOCKEDBACK)
	await super(knockback_vector, knockback_duration)
	_exit_state(State.KNOCKEDBACK)


#
#func _get_input() -> void:
	#if _is_state(State.DEAD): return
	#
	#assert(_sprite)
	#var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	#velocity = direction * speed 
	#
	#if direction != Vector2.ZERO:
		#if abs(direction.x) >= abs(direction.y):
			#_sprite.animation = "right" if direction.x > 0 else "left"
		#else:
			#_sprite.animation = "down" if direction.y > 0 else "up"
		#_sprite.play()
		#_add_state(State.WALKING)
		#_exit_state(State.IDLE)
	#else:
		#_sprite.stop()
		#_add_state(State.IDLE)
		#_exit_state(State.WALKING)


func on_death() -> void:
	_add_state(State.DEAD)	
	

# Blink invincibility frames
func _blink_invincibility() -> void:
	assert(_sprite)
	while _is_state(State.INVINCIBLE):
		_sprite.modulate.a = 0.5  
		await get_tree().create_timer(BLINK_TIME).timeout

		_sprite.modulate.a = 1 
		await get_tree().create_timer(BLINK_TIME).timeout


func _give_invincibility() -> void:
	_add_state(State.INVINCIBLE)
	_blink_invincibility()
	await get_tree().create_timer(invincibility_time).timeout
	_exit_state(State.INVINCIBLE)


func _walk_handler(direction: Vector2) -> void:
	if direction: facing_direction = direction
	velocity = direction * _speed 
	
	if direction != Vector2.ZERO:
		if abs(direction.x) >= abs(direction.y):
			_sprite.animation = "right" if direction.x > 0 else "left"
		else:
			_sprite.animation = "down" if direction.y > 0 else "up"
		_sprite.play()
		_add_state(State.WALKING)
		_exit_state(State.IDLE)
	else:
		_sprite.stop()
		_add_state(State.IDLE)
		_exit_state(State.WALKING)


func _attack_handler() -> void:
	_add_state(State.ATTACKING)
	_hitbox.on()
	_hitbox.get_node("HitEffects").visible = true #TODO: Move into weapon script
	await get_tree().create_timer(.2).timeout
	_hitbox.get_node("HitEffects").visible = false
	_hitbox.off()
	_exit_state(State.ATTACKING)
	

func _add_state(state: State) -> void:
	_state |= state


func _is_state(state: State) -> bool:
	return _state & state 


func _exit_state(state: State) -> void :
	_state &= ~state
