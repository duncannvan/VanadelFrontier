class_name Player extends CombatUnit

enum State {
	IDLE, 
	RUNNING, 
	USING_TOOL, 
	KNOCKEDBACK, 
	DEAD,
}

const COMBO_LIMIT: int = 4
const COMBO_WINDOW_TIME: float = 0.5

@export var _tool_manager: ToolManager

var _state: State = State.IDLE
var _last_facing_direction: Vector2 = Vector2.DOWN
var USING_TOOL: bool = false
var combo_step: int = 0 :
	set(value):
		combo_step = wrapi(value, 1, COMBO_LIMIT)

@onready var _hitbox: HitBox = $HitBox
@onready var _hurtbox: HurtBox = $HurtBox
@onready var _stats_component: StatsComponents = $StatsComponents
@onready var _player_camera: Camera2D = $PlayerCamera
@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _combat_effects: AnimationPlayer = $CombatEffects
@onready var _combo_timer: Timer = $ComboTimer


func _ready() -> void:
	_hurtbox.hurtbox_entered.connect(_apply_attack_effects)
	_stats_component.died.connect(_die)
	_update_blend_positions(_last_facing_direction)
	_combo_timer.timeout.connect(_on_combo_timer_timeout)
	_tool_manager.set_blend_point_idx_mapping(_animation_tree)
	

func _physics_process(delta: float) -> void:
	match _state:
		State.IDLE:
			_handle_idle()
		State.RUNNING:
			_handle_running()
		State.USING_TOOL:
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
		State.USING_TOOL:
			if _tool_manager.is_tool_selected() and _tool_manager.get_selected_tool() is MeleeWeaponResource:
				combo_step += 1
				_tool_manager.set_tool_animation(_animation_tree, combo_step - 1)
				var blend_space: AnimationNodeBlendSpace2D = _animation_tree.tree_root.get_node("StateMachine").get_node("UseTool")
				var anim = blend_space.get_blend_point_node(0).animation #Get random swing direction animation. Idx 0 is currently mapped to left
				_combo_timer.start(_animation_player.get_animation(anim).length + COMBO_WINDOW_TIME)
			else:
				combo_step = 0


func end_attack():
	_set_state(State.IDLE)


func _on_combo_timer_timeout() -> void:
	combo_step = 0


func _handle_idle() -> void:
	if Input.get_vector("left", "right", "up", "down"):
		_set_state(State.RUNNING)
	elif Input.is_action_just_pressed("use_tool") and !get_viewport().gui_get_hovered_control():
		if _tool_manager.is_tool_selected():
			_set_state(State.USING_TOOL)
			_tool_manager.get_selected_tool().use_tool()


func _handle_running():
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction == Vector2.ZERO:
		_set_state(State.IDLE)
	elif Input.is_action_just_pressed("use_tool") and !get_viewport().gui_get_hovered_control():
		if _tool_manager.is_tool_selected():
			_set_state(State.USING_TOOL)
			_tool_manager.get_selected_tool().use_tool()
	else:
		_last_facing_direction = direction
		_update_blend_positions(_last_facing_direction)
		
		velocity = direction * _stats_component.get_current_speed()
		move_and_slide()
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if(event.is_action_pressed("tool_slot_nums")):
			_tool_manager.set_selected_tool(event.keycode - KEY_1, _animation_tree)
			
			
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

func select_tool(slot_idx: int):
	_tool_manager.set_selected_tool(slot_idx, _animation_tree)

func _die() -> void:
	_set_state(State.DEAD)
	queue_free()
	Global.game_over.emit()


func _update_blend_positions(direction: Vector2) -> void:
	_animation_tree.set("parameters/StateMachine/Run/blend_position", direction)
	_animation_tree.set("parameters/StateMachine/Idle/blend_position", direction)
	_animation_tree.set("parameters/StateMachine/UseTool/blend_position", direction)


func _apply_attack_effects(hitbox: HitBox) -> void:
	for effect in hitbox.attack_effects:
			effect.apply(self, hitbox.global_position)
