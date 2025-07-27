extends Control

signal toolbar_button_pressed(slot_idx: int)

var _slot_idx: int = ToolManager.NO_TOOL_SELECTED
var slots: Array[TextureButton] = []

@onready var toolbar_ui = $HBoxContainer

func _ready() -> void:
	for slot in toolbar_ui.get_children():
		if slot is TextureButton:
			slots.append(slot)
			slot.pressed.connect(_on_button_pressed.bind(slot.get_index()))


func update_selected_tool(slot_idx: int) -> void:
	for slot in slots:	
		if slot.get_index() == slot_idx:
			slot.set_pressed_no_signal(!slot.is_pressed())
		else:
			slot.set_pressed_no_signal(false)


func refresh_toolbar(tools: Array[ToolResource]) -> void:
	for slot in slots:
		if slot.get_index() < tools.size() and tools[slot.get_index()]:
			var overlay: TextureRect = TextureRect.new()
			add_child(overlay)
			overlay.texture = tools[slot.get_index()].texture
			overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
			overlay.stretch_mode = TextureRect.STRETCH_KEEP
			# TODO: No hard coded position. Maybe each tool resource should be configured TextureRect
			print(slot.position)
			overlay.scale = Vector2(0.55,0.55)
			overlay.position = slot.position + tools[slot.get_index()].texture_positions_adj

			

func _on_button_pressed(slot_idx: int) -> void:
	# Clicking on slot ui will change the ui texture. Set false to prevent this. Want software to update texture
	slots[slot_idx].set_pressed_no_signal(false)
	toolbar_button_pressed.emit(slot_idx)
