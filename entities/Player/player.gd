class_name Player extends CombatUnit

signal update_health_ui(health: int)

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

@onready var _hitbox: HitBox =$HitBox
@onready var _health_component: HealthComponent = $HealthComponent


func _ready() -> void:
	_health_component.connect("health_changed", _on_health_changed)
	_health_component.connect("died", _die)
	super()
 

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


func take_damage() -> void:
	_give_invincibility()
	super()


func apply_knockback(knockback_vector := Vector2.ZERO, knockback_duration: float = 0.0) -> void:
	# TODO: play knockback animation 
	if _is_state(State.KNOCKEDBACK) or _is_state(State.INVINCIBLE): return
	_sprite.stop()
	_add_state(State.KNOCKEDBACK)
	await super(knockback_vector, knockback_duration)
	_exit_state(State.KNOCKEDBACK)


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
	_health_component.give_invincibility()
	await get_tree().create_timer(invincibility_time).timeout
	_exit_state(State.INVINCIBLE)
	_health_component.disable_invincibility()


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


# TODO: Move into weapon/attack node

func _attack_handler() -> void:
	_add_state(State.ATTACKING)
	_hitbox.on()
	_hitbox.get_node("HitEffects").visible = true 
	await get_tree().create_timer(.1).timeout
	_hitbox.get_node("HitEffects").visible = false
	_hitbox.off()
	await get_tree().create_timer(.3).timeout # Scuffed attack cooldown
	_exit_state(State.ATTACKING)
	

func _add_state(state: State) -> void:
	_state |= state


func _is_state(state: State) -> bool:
	return _state & state 


func _exit_state(state: State) -> void :
	_state &= ~state


func _on_health_changed(old_health: int, new_health: int) -> void:
	if new_health < old_health:
		take_damage()

	update_health_ui.emit(new_health) # updates gui
	

func get_max_health() -> int: 
	return _health_component.get_max_health()
