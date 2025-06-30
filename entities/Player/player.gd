class_name Player extends CombatEntityBase

# Constructor
func _init() -> void:
	var data: Dictionary = {
							"health" = 30,
							"speed" = 100,
							"damage" = 50,
							"knockback_force" = 200,
							}
	super._init(data)
	
# Handled when node enters the scence tree
func _ready() -> void:
	_init_nodes($AnimatedSprite2D, $Hurtbox, $Hitbox)
	# Signals
	assert(_hitbox)
	_hitbox.area_entered.connect(_on_area_entered)

# Combat entity detected in hitbox
func _on_area_entered(enemy_hurtbox: HurtBox) -> void:
	var mob = enemy_hurtbox.get_parent()
	assert(mob)
	var direction: Vector2 = (mob.position - self.position).normalized()
	if direction == Vector2.ZERO:
		direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
	mob.take_damage(_damage)
	mob.apply_knockback(direction)

# Turns on hitbox
func _input(event: InputEvent) -> void:
	assert(_hitbox and _hurtbox)
	if event.is_action_pressed("attack") and not _is_state(States.ATTACKING):
		_add_state(States.ATTACKING)
		_hitbox.on()
		await get_tree().create_timer(.2).timeout
		_hitbox.off()
		_exit_state(States.ATTACKING)
		
# Get direction vector according to the input keys
func _get_input() -> void:
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
func take_damage(damageAmount: int) -> void:
	if not _is_state(States.INVINCIBLE):
		_give_invincibility()
		
		super.take_damage(damageAmount)	
		
		health_changed.emit(_health) # updates gui
		
func apply_knockback(knockbackDirection: Vector2 = Vector2.ZERO) -> void:
		_add_state(States.KNOCKEDBACK)
		await super.apply_knockback(knockbackDirection)
		_exit_state(States.KNOCKEDBACK)

func _add_state(state: States) -> void:
	_state |= state

func _is_state(state: States) -> bool:
	return _state & state 
	
func _exit_state(state: States) -> void :
	_state &= ~state
	
enum States {IDLE = 0x1, WALKING = 0x2, ATTACKING = 0x4, KNOCKEDBACK = 0x8, INVINCIBLE = 0x10}
	
# Private members	
var _state: States = States.IDLE

# Constants
const INVINCIBILITY_TIME = 1
const NUM_HEALTH_PER_HEART = 10
signal health_changed(health: int)

#TODO: Turn off attacking and move when dead
