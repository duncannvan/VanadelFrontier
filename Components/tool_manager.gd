class_name ToolManager extends Node

signal selected_slot_changed(slot_idx: int)
signal toolbar_modified(tools: Array[ToolResource])

const NUM_TOOL_SLOTS: int = 5
const NO_TOOL_SELECTED: int = -1

@export var _tool_resources: Array[ToolResource] = []

var _selected_tool_idx: int = NO_TOOL_SELECTED
var _blend_point_idx_map: Dictionary[String, int] = {"left": 0, "right": 0, "down": 0, "up": 0} 


# Public Methods:
# Param slot_postion: 0 indexed slot position for selecting a tool
func set_selected_tool(slot_position: int, anim_tree: AnimationTree) -> void:
	if slot_position < NUM_TOOL_SLOTS:
		emit_signal("selected_slot_changed", slot_position)
	
	if slot_position >= _tool_resources.size() or slot_position == _selected_tool_idx or !_tool_resources[slot_position]:
		_selected_tool_idx = NO_TOOL_SELECTED
		return
		
	_selected_tool_idx = slot_position
	set_tool_animation(anim_tree)


func get_selected_tool() -> ToolResource:
	assert(_selected_tool_idx != NO_TOOL_SELECTED,"No tool is selected. Use is_tool_selected() or do a null check in the client")
	return _tool_resources[_selected_tool_idx]


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
	var blend_space: AnimationNodeBlendSpace2D = anim_tree.tree_root.get_node("StateMachine").get_node("UseTool")
	for blend_space_idx: int in blend_space.get_blend_point_count():
		var blend_point_pos: Vector2 = blend_space.get_blend_point_position(blend_space_idx)
		var direction: String = _vector_to_direction(blend_point_pos)
		_blend_point_idx_map[direction] = blend_space_idx
	
	
# Swaps the tool animation
# Param lib_idx: Tools can have multiple animation libraries. The idx is used to determined which library to use. 
#                Defaulted to 0 since most tools will only have 1 library.
func set_tool_animation(anim_tree: AnimationTree, lib_idx: int = 0) -> void:
	var blend_space: AnimationNodeBlendSpace2D = anim_tree.tree_root.get_node("StateMachine").get_node("UseTool")
	var tool_lib_name: String = ""
	
	assert(get_selected_tool(), "Tool doesn't not equipped")
	assert(lib_idx < get_selected_tool().animation_libs.size(), "Must add animation library to the tool resource to use with the given idx")
	
	# Get local library name of the tool to reference it in the animation player
	for lib_name: String in anim_tree.get_animation_library_list():
		var lib = anim_tree.get_animation_library(lib_name)
		if lib == get_selected_tool().animation_libs[lib_idx]:
			tool_lib_name = lib_name + "/"
			break
	
	# Update the blend point animations for each direction
	for anim_name: String in get_selected_tool().animation_libs[lib_idx].get_animation_list():
		var anim_node := AnimationNodeAnimation.new()
		anim_node.animation = tool_lib_name + anim_name
		# The local tool animations must include the direction strings
		for key: String in _blend_point_idx_map.keys():
			if key in anim_name:
				blend_space.set_blend_point_node(_blend_point_idx_map[key], anim_node)
		
		
# Private Methods:
func _vector_to_direction(vec: Vector2) -> String:
	if abs(vec.x) > abs(vec.y):
		return "right" if vec.x > 0 else "left"
	else:
		return "down" if vec.y > 0 else "up"
