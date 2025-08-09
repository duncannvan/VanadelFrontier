class_name CraftingTable extends StaticBody2D
@onready var _crafting_range = $Area2D

@export var _crafting_menu: Control # TODO: Better way to access UI or UI Functions

func _ready() -> void:
	_crafting_range.body_entered.connect(_on_area_entered)
	_crafting_range.body_exited.connect(_on_area_exited)
	
	
func _on_area_entered(player: Player) -> void: 
	player.interactable_item = self


func _on_area_exited(player: Player) -> void:
	player.interactable_item = null
	if _crafting_menu.visible:
		_crafting_menu.popup_visibility_toggled.emit()


# TODO: Needs abstract base class Interactable with interact function
func interact():
	_crafting_menu.popup_visibility_toggled.emit()
	
