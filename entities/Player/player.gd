class_name Player extends CombatUnit

signal update_health_ui(health: int)

enum State {
	IDLE = 0x1, 
	WALKING = 0x2, 
	ATTACKING = 0x4, 
	KNOCKEDBACK = 0x8, 
	DEAD = 0x10
}

const NUM_HEALTH_PER_HEART: int = 10

@export var _invincibility_time: float = 1.0

var _state: State = State.IDLE

@onready var _hitbox: HitBox = $HitBox
@onready var _health_component: HealthComponent = $HealthComponent
@onready var _hurtbox: HurtBox = $HurtBox
@onready var _damaged_effects_animation: AnimationPlayer = $DamagedEffectsAnimation
@onready var _invincibility_effects_animation: AnimationPlayer = $InvincibilityEffectsAnimation
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _speed_component: SpeedComponent = $SpeedComponent


func _init() -> void:
	set_collision_layer(2)
	

func _ready() -> void:
	_hurtbox.hurt.connect(_apply_attack_effects)
	_health_component.connect("died", _die)
	

func _physics_process(delta) -> void:
	move_and_slide()


# Called when there is an input event
func _input(event: InputEvent) -> void:
	if _is_state(State.DEAD) or _is_state(State.KNOCKEDBACK): return
	assert(_hitbox)
	
	var direction = Input.get_vector("left", "right", "up", "down")
	_walk_handler(direction)
	
	if event.is_action_pressed("attack") and not _is_state(State.ATTACKING):
		_attack_handler()


func apply_damage(damage: int, hitbox_position: Vector2) -> void:
	_damaged_effects_animation.play("damaged_effects")
	_health_component.apply_damage(damage)
	_give_invincibility()


func _give_invincibility() -> void:
	_hurtbox.is_invincible = true
	_invincibility_effects_animation.play("invincibility_effects")
	await get_tree().create_timer(_invincibility_time).timeout
	_hurtbox.is_invincible = false
	_invincibility_effects_animation.seek(0.0) 
	_invincibility_effects_animation.stop()


func apply_slow(slow_percentage: float, slow_duration: int) -> void:
	_speed_component.apply_slow(slow_percentage, slow_duration)


func apply_knockback(knockback_vector := Vector2.ZERO, knockback_duration: float = 0.0) -> void:
	_sprite.stop()
	_add_state(State.KNOCKEDBACK)
	velocity = knockback_vector
	await get_tree().create_timer(knockback_duration).timeout
	velocity = Vector2.ZERO
	_exit_state(State.KNOCKEDBACK)


func _die() -> void:
	_add_state(State.DEAD)	
	queue_free()
	Global.game_over.emit()


func _walk_handler(direction: Vector2) -> void:
	velocity = direction * _speed_component.speed 
	
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


func _apply_attack_effects(hitbox: HitBox) -> void:
	for effect in hitbox.attack_effects:
			effect.apply(self, hitbox.global_position)
	

func _add_state(state: State) -> void:
	_state |= state


func _is_state(state: State) -> bool:
	return _state & state 


func _exit_state(state: State) -> void :
	_state &= ~state
	

func get_max_health() -> int: 
	return _health_component.get_max_health()
	
