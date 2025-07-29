extends Control


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Inventory"):
		visible = !visible

func refresh_inventory(inventory: Dictionary[Item, int]) -> void:
	#TODO: Refresh inventory, if new item add item texture else increment count for existing item
	pass
