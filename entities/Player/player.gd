class_name Player extends CombatEntityBase

signal health_changed(health: int)

# Constructor
func _init() -> void:
	var data: Dictionary = {
							"health" = 100,
							"speed" = 100,
							"damage" = 50,
							"knockback_mag" = 200,
							}
	super._init(data)
	
# Handled when node enters the scence tree
func _ready() -> void:
	_set_nodes($AnimatedSprite2D, $Hitbox, $Hurtbox)
	# Signals
	assert(_hitbox)
	_hitbox.area_entered.connect(_on_area_entered)

# Comabat entitiy detected in hitbox
func _on_area_entered(area: Area2D) -> void:
	var mob = area.get_parent()
	assert(mob)
	var direction: Vector2 = (mob.position - self.position).normalized()
	if direction == Vector2.ZERO:
		direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
	mob.take_damage(damage, direction)

# Turns on hitbox
func _input(event: InputEvent) -> void:
	assert(_hitbox and _hurtbox)
	if event.is_action_pressed("attack") and not _get_state(States.ATTACKING):
		_set_state(States.ATTACKING)
		_hitbox.monitoring = true
		_hitbox.visible = true
		await get_tree().create_timer(.2).timeout
		_hitbox.monitoring = false
		_hitbox.visible = false
		_clear_state(States.ATTACKING)
		
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
		_set_state(States.WALKING)
		_clear_state(States.IDLE)
	else:
		_sprite.stop()
		_set_state(States.IDLE)
		_clear_state(States.WALKING)

			  
func _physics_process(delta) -> void:
	if not is_knockback:
		_get_input()
	move_and_slide()

# Blink invincibility frames
func _blink_invincibility() -> void:
	assert(_sprite)
	while _get_state(States.INVINCIBLE):
		_sprite.modulate.a = 0.5  
		await get_tree().create_timer(BLINK_TIME).timeout

		_sprite.modulate.a = 1 
		await get_tree().create_timer(BLINK_TIME).timeout

# Invincibility handler
func _give_invincibility() -> void:
	_set_state(States.INVINCIBLE)
	_blink_invincibility()
	await get_tree().create_timer(INVINCIBILITY_TIME).timeout
	_clear_state(States.INVINCIBLE)

# Damage taken handler
func _upon_hit(damageAmount: int, knockbackDirection: Vector2) -> void:
	if not _get_state(States.INVINCIBLE):
		_give_invincibility()
		super.take_damage(damageAmount, knockbackDirection)	
		
		# Update GUI
		health_changed.emit(health)

func _set_state(state: States) -> void:
	_state |= state
	
func _get_state(state: States) -> bool:
	return _state & state 
	
func _clear_state(state: States) -> void:
	_state &= ~state
	
enum States {IDLE = 0x0000, WALKING = 0x0001, ATTACKING = 0x0010, KNOCKEDBACK = 0x0100, INVINCIBLE = 0x1000}

# Private members	
var _state: States = States.IDLE

# Constants
const INVINCIBILITY_TIME = 1
const NUM_HEALTH_PER_HEART = 10

#TODO: Turn off attacking and move when dead
