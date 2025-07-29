extends Control

@onready var _slot_container: GridContainer = %SlotContainer
@onready var slots: Array[Node] = _slot_container.get_children()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Inventory"):
		visible = !visible


func refresh_inventory(inventory: Array[ItemStack]) -> void:
	var i: int = 0
	for stack in inventory:
		slots[i].get_node("ItemTextureRect").texture = stack.item.texture
		slots[i].get_node("Count").text = str(stack.count)
		i += 1
