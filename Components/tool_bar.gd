class_name ToolBarComponent extends Node

const NUM_TOOL_SLOTS: int = 5

@export var _tool_resources: Array[BaseToolResource] = []

var _selected_tool_idx: int = 0
var _blend_point_idx_map: Dictionary[String, int] = {"left": 0, "right": 0, "down": 0, "up": 0} 


func set_selected_tool(slot_position: int, anim_tree: AnimationTree) -> void:
	if(slot_position > _tool_resources.size()):
		return
		
	_selected_tool_idx = slot_position - 1
	set_tool_animation(anim_tree)
	

func get_selected_tool() -> BaseToolResource:
	return _tool_resources[_selected_tool_idx]

	
func get_all_tools() -> Array[BaseToolResource]:
	return _tool_resources


func add_new_tool(tool: BaseToolResource) -> bool:
	if _tool_resources.size() >= NUM_TOOL_SLOTS:
		return false
		
	_tool_resources.append(tool)
	return true


func swap_tool_slots(tool_idx1: int, tool_idx2: int) -> void:
	if(_tool_resources.size() < tool_idx1 and _tool_resources.size() < tool_idx2):	
		var temp: BaseToolResource = _tool_resources[tool_idx1]
		_tool_resources[tool_idx1] = _tool_resources[tool_idx2]
		_tool_resources[tool_idx2] = temp
		
func set_tool_animation(anim_tree: AnimationTree, lib_idx: int = 0) -> void:
	
	var blend_space: AnimationNodeBlendSpace2D = anim_tree.tree_root.get_node("StateMachine").get_node("UseTool")
	var tool_lib_name: String = ""
	
	if lib_idx > get_selected_tool().animation_libs.size() - 1:
		push_warning("Must add library to the tool resource to use with the given idx")
		return
	
	# The blend space points are mapped to a decimal index based on the order of creation in the animation tree
	# Get the blend point position vector to determine the corresponding direction for the blend point
	for blend_space_idx: int in blend_space.get_blend_point_count():
		var blend_point_pos: Vector2 = blend_space.get_blend_point_position(blend_space_idx)
		var dir_str: String = _vector_to_direction(blend_point_pos)
		_blend_point_idx_map[dir_str] = blend_space_idx
	
	# Get local library name of the tool to reference it in the animation player
	for lib_name: String in anim_tree.get_animation_library_list():
		var lib = anim_tree.get_animation_library(lib_name)
		if lib == get_selected_tool().animation_libs[lib_idx]:
			tool_lib_name = lib_name + "/"
			break
	
	# Update the blend point animations for each directiona
	for anim_name: String in get_selected_tool().animation_libs[lib_idx].get_animation_list():
		var anim_node := AnimationNodeAnimation.new()
		anim_node.animation = tool_lib_name + anim_name
		# The local tool animations must include the direction strings
		for key in _blend_point_idx_map.keys():
			if key in anim_name:
				blend_space.set_blend_point_node(_blend_point_idx_map[key], anim_node)

func _vector_to_direction(vec: Vector2) -> String:
	if abs(vec.x) > abs(vec.y):
		return "right" if vec.x > 0 else "left"
	else:
		return "down" if vec.y > 0 else "up"
