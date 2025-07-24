class_name Player extends CombatUnit

enum State {
	IDLE, 
	RUNNING, 
	ATTACKING, 
	KNOCKEDBACK, 
	DEAD,
}

const COMBO_LIMIT: int = 4
const COMBO_WINDOW_TIME: float = 0.5

var _state: State = State.IDLE
var _last_facing_direction: Vector2 = Vector2.DOWN
var attacking: bool = false
var combo_step: int = 0 :
	set(value):
		combo_step = wrapi(value, 1, COMBO_LIMIT)

@onready var _hitbox: HitBox = $HitBox
@onready var _hurtbox: HurtBox = $HurtBox
@onready var _stats_component: StatsComponents = $StatsComponents
@onready var _player_camera: Camera2D = $PlayerCamera
@onready var _tool_bar: ToolBarComponent = $ToolBarComponent
@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _combat_effects: AnimationPlayer = $CombatEffects
@onready var _combo_timer: Timer = $ComboTimer


func _ready() -> void:
	_hurtbox.hurtbox_entered.connect(_apply_attack_effects)
	_stats_component.died.connect(_die)
	_update_blend_positions(_last_facing_direction)
	
	_combo_timer.timeout.connect(_on_combo_timer_timeout)


func _physics_process(delta: float) -> void:
	match _state:
		State.IDLE:
			_handle_idle()
		State.RUNNING:
			_handle_running()
		State.ATTACKING:
			pass
		State.KNOCKEDBACK:
			move_and_slide()
		State.DEAD:
			pass	


func _set_state(new_state: State) -> void:
	if _state == new_state:
		return
	
	_state = new_state
	
	# Do something after transition to new state
	match _state:
		State.ATTACKING:
			combo_step += 1
			print(combo_step)
			_combo_timer.start(_animation_player.get_animation("slash_down_%d" % combo_step).length + COMBO_WINDOW_TIME)


func end_attack():
	_set_state(State.IDLE)


func _on_combo_timer_timeout() -> void:
	combo_step = 0

#func _handle_attacking() -> void:
	#if Input.is_action_just_pressed("attack"):
		#combo_step += 1
		#print(combo_step)


func _handle_idle() -> void:
	if Input.get_vector("left", "right", "up", "down"):
		_set_state(State.RUNNING)
	elif Input.is_action_just_pressed("attack"):
		_set_state(State.ATTACKING)


func _handle_running():
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction == Vector2.ZERO:
		_set_state(State.IDLE)
	elif Input.is_action_just_pressed("attack"):
		_set_state(State.ATTACKING)
	else:
		_last_facing_direction = direction
		_update_blend_positions(_last_facing_direction)
		
		velocity = direction * _stats_component.get_current_speed()
		move_and_slide()
	
	_walk_handler(direction)
	
	
	if event.is_action_pressed("attack") and not _is_state(State.ATTACKING):
		_attack_handler()
	
	if event.is_action_pressed("use_tool"):
		_tool_bar.get_selected_tool().use_tool()
		
	if event.is_action_pressed("slot1"):
		_tool_bar.set_selected_tool(1)
		
	if event.is_action_pressed("slot2"):
		_tool_bar.set_selected_tool(2)
		
	if event.is_action_pressed("slot3"):
		_tool_bar.set_selected_tool(3)


func apply_damage(damage: int, hitbox_position: Vector2) -> void:
	_combat_effects.play("damaged_effects")
	_stats_component.apply_damage(damage)


func apply_slow(slowed_factor: float, slowed_duration: int) -> void:
	_stats_component.apply_slow(slowed_factor, slowed_duration)


func apply_knockback(knockback_vector := Vector2.ZERO, knockback_duration: float = 0.0) -> void:
	_set_state(State.KNOCKEDBACK)
	velocity = knockback_vector
	await get_tree().create_timer(knockback_duration).timeout
	velocity = Vector2.ZERO
	_set_state(State.IDLE)


func _die() -> void:
	_set_state(State.DEAD)
	queue_free()
	Global.game_over.emit()


func _update_blend_positions(direction: Vector2) -> void:
	_animation_tree.set("parameters/StateMachine/MoveState/RunState/blend_position", direction)
	_animation_tree.set("parameters/StateMachine/MoveState/IdleState/blend_position", direction)
	_animation_tree.set("parameters/StateMachine/AttackState/Slash1/blend_position", direction)
	_animation_tree.set("parameters/StateMachine/AttackState/Slash2/blend_position", direction)
	_animation_tree.set("parameters/StateMachine/AttackState/Slash3/blend_position", direction)


func _apply_attack_effects(hitbox: HitBox) -> void:
	for effect in hitbox.attack_effects:
			effect.apply(self, hitbox.global_position)


#func _add_state(state: State) -> void:
	#_state |= state
#
#
#func _is_state(state: State) -> bool:
	#return _state & state 
#
#
#func _exit_state(state: State) -> void :
	#_state &= ~state


#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#print(anim_name)
