class_name Player extends CombatUnit

enum States {
	MOVE,
	TOOL,
	KNOCKBACK,
	DEAD
}

var _states: Dictionary[String, States] =  {
	"MoveState": States.MOVE,
	"ToolState": States.TOOL,
	"KnockbackState": States.KNOCKBACK,
	"DeadState": States.DEAD
	}
var knockback_velocity: Vector2 = Vector2.ZERO
var _last_facing_direction: Vector2 = Vector2.DOWN
var interactable_item: StaticBody2D = null # Gets set whenever player enters range for interactable itme

@onready var _hurtbox: Hurtbox = $Hurtbox
@onready var _stats_component: StatsComponents = $StatsComponents
@onready var _player_camera: Camera2D = $PlayerCamera
@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _playback_states: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _combat_effects: AnimationPlayer = $CombatEffects
@onready var _tool_manager: ToolManager = $ToolManager
@onready var _inventory_manager: InventoryManger = $InventoryManager
@onready var hitbox: Hitbox = $ToolPivot/Hitbox


func _ready() -> void:
	add_to_group("players")
	_hurtbox.hurtbox_entered.connect(_apply_attack_effects)
	_stats_component.died.connect(_die)
	_update_blend_positions(_last_facing_direction)
	_tool_manager.set_blend_point_idx_mapping(_animation_tree)
	_tool_manager.tool_used.connect(_on_tool_used)
	


func _unhandled_input(event: InputEvent) -> void:
	var current_state: States = _get_state_enum(_playback_states.get_current_node())
	
	match current_state:
		States.MOVE:
			if event.is_action_pressed("use_tool"):
				if _tool_manager.is_tool_selected():
					_tool_manager.use_selected_tool(self)
	
	if event.is_action_pressed("interact") and interactable_item:
		interactable_item.interact()
		
		
func _physics_process(delta: float) -> void:
	var current_state: States = _get_state_enum(_playback_states.get_current_node())

	match current_state:
		States.MOVE:
			_handle_movement()
		States.TOOL:
			pass
		States.KNOCKBACK:
			velocity = knockback_velocity
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
	knockback_velocity = knockback_vector
	await get_tree().create_timer(knockback_duration).timeout
	_set_state(States.MOVE)


func select_tool(slot_idx: int):
	_tool_manager.set_selected_tool(slot_idx, self)


func _die() -> void:
	_set_state(States.DEAD)
	queue_free()
	Global.game_over.emit()


func _update_blend_positions(direction: Vector2) -> void:
	_animation_tree.set("parameters/StateMachine/MoveState/Idle/blend_position", direction)
	_animation_tree.set("parameters/StateMachine/MoveState/Running/blend_position", direction)
	_animation_tree.set("parameters/StateMachine/ToolState/blend_position", direction)
	_animation_tree.set("parameters/StateMachine/KnockbackState/blend_position", direction)


func _apply_attack_effects(hitbox: Hitbox) -> void:
	for effect in hitbox.attack_effects:
			effect.apply(self, hitbox.global_position)
			

func _get_state_string(state: States) -> String:
	for key: String in _states.keys():
		if _states[key] == state:
			return key
	assert("State enum not found in string mappings _states")
	return ""
	

func _get_state_enum(state: String) -> States:
	if not state: # For when physics process calls function before anim tree is initialized
		return States.MOVE
		
	if not _states.has(state): 
		assert("State enum not found in string mappings _states")

	return _states[state]
