class_name ToolBarComponent extends Node

const NUM_TOOL_SLOTS: int = 5

@export var _tool_resources: Array[BaseToolResource] = []

var _selected_tool_idx: int = 0


func set_selected_tool(slot_position: int) -> void:
	if(slot_position > _tool_resources.size()):
		return
		
	_selected_tool_idx = slot_position - 1


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
