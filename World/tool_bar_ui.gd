extends Control

signal tool_slot_clicked(slot_idx: int)

var _slot_idx: int = ToolManager.NO_TOOL_SELECTED
var toolbar: Array[TextureButton] = []

@onready var toolbar_ui = %ToolSlotsContainer
@onready var _player: Player = get_tree().get_first_node_in_group("players") # Player node has to be rendered before UI in the scene tree
@onready var _tool_manager = _player.get_node("ToolManager") 

func _ready() -> void:
	for slot in toolbar_ui.get_children():
		if slot is TextureButton:
			toolbar.append(slot)
			slot.pressed.connect(_on_button_pressed.bind(slot.get_index()))
	
	_refresh_toolbar(_tool_manager.get_all_tools())
	
	_tool_manager.selected_slot_changed.connect(_on_selected_slot_changed)
	_tool_manager.toolbar_modified.connect(_refresh_toolbar)
	_tool_manager.tool_used.connect(_on_tool_used)



func _on_selected_slot_changed(slot_idx: int) -> void:
	for slot in toolbar:
		if slot.get_index() == slot_idx:# This may be moved to the individual tool resource if tool sizes varies significantly
			slot.set_pressed_no_signal(!slot.is_pressed())
		else:
			slot.set_pressed_no_signal(false)


func _refresh_toolbar(tools: Array[ToolResource]) -> void:
	for slot in toolbar:
		if slot.get_index() < tools.size() and tools[slot.get_index()]:

			var slot_texture_rect = slot.get_node("%ItemTextureRect")
			slot_texture_rect.texture = tools[slot.get_index()].texture


func _on_button_pressed(slot_idx: int) -> void:
	# Want software to handle updating button state so reverse state change done by clicking
	toolbar[slot_idx].set_pressed_no_signal(!toolbar[slot_idx].is_pressed())
	_player.select_tool(slot_idx)


func _on_tool_used(cooldown_sec: float, selected_tool_idx: int):
	var tween: Tween = get_tree().create_tween()
	
	var slot: TextureButton = toolbar[selected_tool_idx]
	var cooldown_ui: ColorRect = slot.get_node("%CooldownUI")
	cooldown_ui.size.y = slot.size.y
	tween.tween_property(cooldown_ui, "size:y", 0.0, cooldown_sec)
