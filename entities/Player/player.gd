class_name Player extends CombatEntityBase

# Constructor
func _init() -> void:
	var data: Dictionary = {
							"health" = 30,
							"speed" = 100,
							"knockback_force" = 200,
							}
	super._init(data)
	
# Handled when node enters the scence tree
func _ready() -> void:
	_init_nodes($AnimatedSprite2D, $HurtBox, $HitBox)

func _input(event: InputEvent) -> void:
	if _is_state(States.DEAD): return
	assert(_hitbox and _hurtbox)
	if event.is_action_pressed("attack") and not _is_state(States.ATTACKING):
		_add_state(States.ATTACKING)
		_hitbox.on()
		_hitbox.get_node("HitEffects").visible = true #TODO: Move into weapon script
		await get_tree().create_timer(.2).timeout
		_hitbox.get_node("HitEffects").visible = false
		_hitbox.off()
		_exit_state(States.ATTACKING)
		
# Get direction vector according to the input keys
func _get_input() -> void:
	if _is_state(States.DEAD): return
	
	assert(_sprite)
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = direction * _speed 
	
	if direction != Vector2.ZERO:
		if abs(direction.x) >= abs(direction.y):
			_sprite.animation = "right" if direction.x > 0 else "left"
		else:
			_sprite.animation = "down" if direction.y > 0 else "up"
		_sprite.play()
		_add_state(States.WALKING)
		_exit_state(States.IDLE)
	else:
		_sprite.stop()
		_add_state(States.IDLE)
		_exit_state(States.WALKING)
			  
func _physics_process(delta) -> void:
	if not _is_state(States.KNOCKEDBACK):
		_get_input()
		
	move_and_slide()

# Blink invincibility frames
func _blink_invincibility() -> void:
	assert(_sprite)
	while _is_state(States.INVINCIBLE):
		_sprite.modulate.a = 0.5  
		await get_tree().create_timer(BLINK_TIME).timeout

		_sprite.modulate.a = 1 
		await get_tree().create_timer(BLINK_TIME).timeout

# Invincibility handler
func _give_invincibility() -> void:
	_add_state(States.INVINCIBLE)
	_blink_invincibility()
	await get_tree().create_timer(INVINCIBILITY_TIME).timeout
	_exit_state(States.INVINCIBLE)

# Damage taken handler
func take_damage(damageAmount: int, knockback_dir: Vector2 = Vector2.ZERO) -> void:
	if not _is_state(States.DEAD) and not _is_state(States.INVINCIBLE):
		apply_knockback(knockback_dir)
		_give_invincibility()

		super.take_damage(damageAmount)	
		
		health_changed.emit(_health) # updates gui
		
func apply_knockback(knockbackDirection: Vector2 = Vector2.ZERO) -> void:
	_add_state(States.KNOCKEDBACK)
	await super.apply_knockback(knockbackDirection)
	_exit_state(States.KNOCKEDBACK)

func die() -> void:
	_add_state(States.DEAD)
	super.die()
	
func _add_state(state: States) -> void:
	_state |= state

func _is_state(state: States) -> bool:
	return _state & state 
	
func _exit_state(state: States) -> void :
	_state &= ~state
	
enum States {IDLE = 0x1, WALKING = 0x2, ATTACKING = 0x4, KNOCKEDBACK = 0x8, INVINCIBLE = 0x10, DEAD = 0x20}
	
# Private variables	
var _state: States = States.IDLE

# Constants
const INVINCIBILITY_TIME = 1
const NUM_HEALTH_PER_HEART = 10
signal health_changed(health: int)
