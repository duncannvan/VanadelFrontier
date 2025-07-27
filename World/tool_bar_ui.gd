extends Control

signal tool_slot_clicked(slot_idx: int)

var _slot_idx: int = ToolManager.NO_TOOL_SELECTED
var toolbar: Array[TextureButton] = []

@onready var toolbar_ui = %ToolSlotsContainer


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
	for slot in toolbar:
		if slot.get_index() < tools.size() and tools[slot.get_index()]:

			var slot_texture_rect = slot.get_node("%ItemTextureRect")
			slot_texture_rect.texture = tools[slot.get_index()].texture


func _on_button_pressed(slot_idx: int) -> void:
	# Want software to handle updating button state so reverse state change done by clicking
	toolbar[slot_idx].set_pressed_no_signal(!toolbar[slot_idx].is_pressed())
	tool_slot_clicked.emit(slot_idx)


func start_cooldown(cooldown_sec: float, selected_tool_idx: int):
	var tween: Tween = get_tree().create_tween()
	
	var slot: TextureButton = toolbar[selected_tool_idx]
	var cooldown_ui: ColorRect = slot.get_node("%CooldownUI")
	cooldown_ui.size.y = slot.size.y
	tween.tween_property(cooldown_ui, "size:y", 0.0, cooldown_sec)
