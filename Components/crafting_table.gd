class_name CraftingTable extends StaticBody2D


@export var _crafting_menu: Control 

@onready var interactable_area: InteractableArea = $InteractableArea

func _ready() -> void:
	interactable_area.interact = _on_interact

# TODO: Needs base class Interactable with abstract interact function to inherit from
func _on_interact():
	_crafting_menu.popup_visibility_toggled.emit()
	
