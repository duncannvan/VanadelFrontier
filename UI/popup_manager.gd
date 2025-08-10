extends Control

var _current_popup: Control = null


func _ready() -> void:
	for popup in get_children():
		popup.popup_visibility_toggled.connect(_on_popup_visibility_toggled.bind(popup))


func _on_popup_visibility_toggled(popup: Control):
	if popup != _current_popup and _current_popup != null:
		return
	
	popup.visible = !popup.visible
	
	if popup.visible:
		_current_popup = popup
	else:
		_current_popup = null
