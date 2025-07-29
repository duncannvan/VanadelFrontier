class_name ToolManager extends Node

signal selected_slot_changed(slot_idx: int)
signal toolbar_modified(tools: Array[ToolResource])
signal tool_used(cooldown, selected_tool_idx)


const NUM_TOOL_SLOTS: int = 5
const NO_TOOL_SELECTED: int = -1
const COMBO_WINDOW_SEC: float = 0.5

@export var _tool_resources: Array[ToolResource] = []

var _selected_tool_idx: int = NO_TOOL_SELECTED
var _blend_point_idx_map: Dictionary[String, int] = {"left": 0, "right": 0, "down": 0, "up": 0}
var _combo_timer: Timer = null

func _ready() -> void:
	_combo_timer = Timer.new()
	add_child(_combo_timer)
	_combo_timer.timeout.connect(_on_combo_timer_expire)


# Public Methods:
# Param slot_postion: 0 indexed slot position for selecting a tool
func set_selected_tool(slot_position: int, player: Player) -> void:
	if slot_position < NUM_TOOL_SLOTS:
		if is_tool_selected():
			_get_selected_tool().reset_lib_idx()
		emit_signal("selected_slot_changed", slot_position)
	
	if slot_position >= _tool_resources.size() or slot_position == _selected_tool_idx or !_tool_resources[slot_position]:
		_selected_tool_idx = NO_TOOL_SELECTED
		return
	
	if is_tool_selected():
		_get_selected_tool().on_switch_out(player)
	_selected_tool_idx = slot_position
	_get_selected_tool().on_switch_in(player)
	set_tool_animation(player._animation_tree)


func use_selected_tool(player: Player) -> void:
	if is_tool_selected() and _get_selected_tool().cooling_down:
		return
	# Save idx here to restore this tool's cool_down bool incase the selected tool idx changes
	var tool_idx: int = _selected_tool_idx
	var cooldown_sec: float = _get_selected_tool().get_cooldown_sec()
	_get_selected_tool().cooling_down = true
	
	# Only update animation if there multiple animation libs in the tool
	if _get_selected_tool().animation_libs.size() > 1:
		set_tool_animation(player._animation_tree, _get_selected_tool().get_lib_idx())
		_combo_timer.start(cooldown_sec + COMBO_WINDOW_SEC)
	emit_signal("tool_used", cooldown_sec, _selected_tool_idx)
	_get_selected_tool().use_tool(player)
	await get_tree().create_timer(cooldown_sec).timeout
	_tool_resources[tool_idx].cooling_down = false
 
	
func is_tool_selected() -> bool:
	return _selected_tool_idx != NO_TOOL_SELECTED
	
	
func get_all_tools() -> Array[ToolResource]:
	return _tool_resources
	

func remove_tool(slot_position: int) -> void:
	if _tool_resources[slot_position]:
		_tool_resources[slot_position] = null
	emit_signal("toolbar_modified", get_all_tools())


func add_new_tool(tool: ToolResource) -> bool:
	if _tool_resources.size() >= NUM_TOOL_SLOTS:
		return false
		
	_tool_resources.append(tool)
	emit_signal("toolbar_modified", get_all_tools())
	return true
	

func swap_tool_slots(tool_idx1: int, tool_idx2: int) -> void:
	if _tool_resources.size() > tool_idx1 and _tool_resources.size() > tool_idx2:	
		var temp: ToolResource = _tool_resources[tool_idx1]
		_tool_resources[tool_idx1] = _tool_resources[tool_idx2]
		_tool_resources[tool_idx2] = temp
		emit_signal("toolbar_modified", get_all_tools())


# The blend space points are mapped to a decimal index based on the order of creation in the animation tree
# Get the blend point position vector to determine the corresponding direction for the blend point
# This must be called once in the client's _ready() if they intend to use tool animations
func set_blend_point_idx_mapping(anim_tree: AnimationTree) -> void:
	var blend_space: AnimationNodeBlendSpace2D = anim_tree.tree_root.get_node("StateMachine").get_node("ToolState")
	for blend_space_idx: int in blend_space.get_blend_point_count():
		var blend_point_pos: Vector2 = blend_space.get_blend_point_position(blend_space_idx)
		var direction: String = _vector_to_direction(blend_point_pos)
		_blend_point_idx_map[direction] = blend_space_idx
	

# Swaps the tool animation
# Param lib_idx: Tools can have multiple animation libraries. The idx is used to determined which library to use. 
#                Defaulted to 0 since most tools will only have 1 library.
func set_tool_animation(anim_tree: AnimationTree, lib_idx: int = 0) -> void:
	var blend_space: AnimationNodeBlendSpace2D = anim_tree.tree_root.get_node("StateMachine").get_node("ToolState")
	var tool_lib_name: String = ""
	
	assert(_get_selected_tool(), "Tool doesn't not equipped")
	assert(lib_idx < _get_selected_tool().animation_libs.size(), "Must add animation library to the tool resource to use with the given idx")
	
	# Get local library name of the tool to reference it in the animation player
	for lib_name: String in anim_tree.get_animation_library_list():
		var lib = anim_tree.get_animation_library(lib_name)
		if lib == _get_selected_tool().animation_libs[lib_idx]:
			tool_lib_name = lib_name + "/"
			break
	
	# Update the blend point animations for each direction
	for anim_name: String in _get_selected_tool().animation_libs[lib_idx].get_animation_list():
		var anim_node := AnimationNodeAnimation.new()
		anim_node.animation = tool_lib_name + anim_name
		# The local tool animations must include the direction strings
		for key: String in _blend_point_idx_map.keys():
			if key in anim_name:
				blend_space.set_blend_point_node(_blend_point_idx_map[key], anim_node)
		
		
# Private Methods:
func _get_selected_tool() -> ToolResource:
	assert(_selected_tool_idx != NO_TOOL_SELECTED,"No tool is selected. Use is_tool_selected() or do a null check in the client")
	return _tool_resources[_selected_tool_idx]


func _vector_to_direction(vec: Vector2) -> String:
	if abs(vec.x) > abs(vec.y):
		return "right" if vec.x > 0 else "left"
	else:
		return "down" if vec.y > 0 else "up"


func _on_combo_timer_expire() -> void:
	if is_tool_selected():
		_get_selected_tool().reset_lib_idx()
