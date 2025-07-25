class_name ToolBarComponent extends Node

const NUM_TOOL_SLOTS: int = 5

@export var _tool_resources: Array[BaseToolResource] = []

var _selected_tool_idx: int = 0
var count = 0;

func set_selected_tool(slot_position: int, blend_space: AnimationNodeBlendSpace2D) -> void:
	if(slot_position > _tool_resources.size()):
		return
		
	_selected_tool_idx = slot_position - 1

	for anim_name in get_selected_tool().animation_libs[count].get_animation_list():
		var anim_node := AnimationNodeAnimation.new()
		anim_node.animation = "basic_melee_slash_" +str(count + 1)+"/"+anim_name
		print("basic_melee_slash_" +str(count)+"/"+anim_name)
		if "left" in anim_name:			
			blend_space.set_blend_point_node(0, anim_node)
		elif "right" in anim_name:			
			blend_space.set_blend_point_node(1, anim_node)
		elif "down" in anim_name:			
			blend_space.set_blend_point_node(2, anim_node)
		elif "up" in anim_name:			
			blend_space.set_blend_point_node(3, anim_node)
	

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
