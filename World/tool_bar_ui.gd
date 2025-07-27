extends Control

signal tool_slot_clicked(slot_idx: int)

var _slot_idx: int = ToolManager.NO_TOOL_SELECTED
var toolbar: Array[TextureButton] = []

@onready var toolbar_ui = $HBoxContainer


func _ready() -> void:
	for slot in toolbar_ui.get_children():
		if slot is TextureButton:
			toolbar.append(slot)
			slot.pressed.connect(_on_button_pressed.bind(slot.get_index()))


func update_selected_tool(slot_idx: int) -> void:
	for slot in toolbar:
		if slot.get_index() == slot_idx:# This may be moved to the individual tool resource if tool sizes varies significantly
			slot.set_pressed_no_signal(!slot.is_pressed())
		else:
			slot.set_pressed_no_signal(false)


func refresh_toolbar(tools: Array[ToolResource]) -> void:
	# This may be moved to the individual tool resource if tool sizes varies significantly
	# For now, chose a value that looks good on the screen
	const TEXTURE_SCALE: float = 0.55
	
	for slot in toolbar:
		if slot.get_index() < tools.size() and tools[slot.get_index()]:
			var overlay: TextureRect = TextureRect.new()
			overlay.texture = tools[slot.get_index()].texture
			overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
			overlay.stretch_mode = TextureRect.STRETCH_KEEP
			overlay.scale = Vector2(TEXTURE_SCALE, TEXTURE_SCALE)
			overlay.position = slot.position + tools[slot.get_index()].texture_positions_adj
			add_child(overlay)


func _on_button_pressed(slot_idx: int) -> void:
	# Want software to handle updating button state so reverse state change via clicking
	toolbar[slot_idx].set_pressed_no_signal(!toolbar[slot_idx].is_pressed())
	tool_slot_clicked.emit(slot_idx)
