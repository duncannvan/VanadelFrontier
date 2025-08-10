class_name CraftingTable extends StaticBody2D

@export var _crafting_menu: Control 

@onready var interactable_area: InteractableArea = $InteractableArea

func _ready() -> void:
	interactable_area.interact = _on_interact
	interactable_area.body_exited.connect(_on_area_exited)


func _on_interact():
	_crafting_menu.popup_visibility_toggled.emit()
	await _crafting_menu.closed
	
func  _on_area_exited(player: Player) -> void:
	if _crafting_menu.visible:
		_crafting_menu.popup_visibility_toggled.emit()
