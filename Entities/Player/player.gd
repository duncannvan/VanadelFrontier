class_name Player extends CombatUnit

enum States {
	MOVE,
	TOOL,
	KNOCKBACK,
	DEAD
}

@export var _tool_manager: ToolManager

var _states: Dictionary[String, States] =  {
	"MoveState": States.MOVE,
	"ToolState": States.TOOL,
	"KnockbackState": States.KNOCKBACK,
	"DeadState": States.DEAD
	}
var _last_facing_direction: Vector2 = Vector2.DOWN

@onready var _hitbox: HitBox = $HitBox
@onready var _hurtbox: HurtBox = $HurtBox
@onready var _stats_component: StatsComponents = $StatsComponents
@onready var _player_camera: Camera2D = $PlayerCamera
@onready var _playback_states: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")
@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _combat_effects: AnimationPlayer = $CombatEffects

func _ready() -> void:
	add_to_group("player")
	_hurtbox.hurtbox_entered.connect(_apply_attack_effects)
	_stats_component.died.connect(_die)
	_update_blend_positions(_last_facing_direction)
	_tool_manager.set_blend_point_idx_mapping(_animation_tree)
	_tool_manager.tool_used.connect(_on_tool_used)
	
func _physics_process(delta: float) -> void:
	var state_string: String = _playback_states.get_current_node()
	if not _states.has(state_string): 
		return
	
	match _states[state_string]:
		States.MOVE:
			_handle_movement()
		States.TOOL:
			pass
		States.KNOCKBACK:
			move_and_slide()
			pass
		States.DEAD:
			pass
	
	
func _set_state(new_state: States) -> void:
	var state_string: String = _get_state_string(new_state)
	if state_string == _playback_states.get_current_node():
		return
		
	_playback_states.travel(state_string)


func _on_tool_used(cooldown: float, selected_tool_idx: int):
	_set_state(States.TOOL)
	
	
func _handle_movement():
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		_last_facing_direction = direction
		_update_blend_positions(_last_facing_direction)
		
	if Input.is_action_just_pressed("use_tool") and !get_viewport().gui_get_hovered_control():
		if _tool_manager.is_tool_selected():
			_tool_manager.use_selected_tool(_animation_tree)
			
	velocity = direction * _stats_component.get_current_speed()
	move_and_slide()
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if(event.is_action_pressed("tool_slot_nums")):
			select_tool(event.keycode - KEY_1)
			
			
func apply_damage(damage: int, hitbox_position: Vector2) -> void:
	_combat_effects.play("damaged_effects")
	_stats_component.apply_damage(damage)


func apply_slow(slowed_factor: float, slowed_duration: int) -> void:
	_stats_component.apply_slow(slowed_factor, slowed_duration)


func apply_knockback(knockback_vector := Vector2.ZERO, knockback_duration: float = 0.0) -> void:
	_set_state(States.KNOCKBACK)
	
	# Have to wait to travel before setting velocity else it would be overwritten by move function
	const KNOCKEDBACK_TIMEOUT_SEC: float = 3.0
	var elapsed_sec: float = 0.0
	while _playback_states.get_current_node() != _get_state_string(States.KNOCKBACK):
		if elapsed_sec > KNOCKEDBACK_TIMEOUT_SEC:
			assert(false, "Knockback timer timedout")
		elapsed_sec += get_process_delta_time()
		await get_tree().process_frame
	
	velocity = knockback_vector
	await get_tree().create_timer(knockback_duration).timeout
	velocity = Vector2.ZERO
	_set_state(States.MOVE)


func select_tool(slot_idx: int):
	_tool_manager.set_selected_tool(slot_idx, _animation_tree)


func _die() -> void:
	_set_state(States.DEAD)
	queue_free()
	Global.game_over.emit()


func _update_blend_positions(direction: Vector2) -> void:
	_animation_tree.set("parameters/StateMachine/MoveState/Idle/blend_position", direction)
	_animation_tree.set("parameters/StateMachine/MoveState/Running/blend_position", direction)
	_animation_tree.set("parameters/StateMachine/ToolState/blend_position", direction)
	_animation_tree.set("parameters/StateMachine/KnockbackState/blend_position", direction)


func _apply_attack_effects(hitbox: HitBox) -> void:
	for effect in hitbox.attack_effects:
			effect.apply(self, hitbox.global_position)
			

func _get_state_string(state: States) -> String:
	for key: String in _states.keys():
		if _states[key] == state:
			return key
	assert("State enum not found in string mappings _states")
	return ""
	
