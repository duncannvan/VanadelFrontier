extends Control

@onready var _slot_container: GridContainer = %SlotContainer
@onready var slots: Array[Node] = _slot_container.get_children()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		visible = !visible


func refresh_inventory(inventory: Array[ItemStack]) -> void:
	for slot_idx: int in len(inventory):
		slots[slot_idx].get_node("ItemTextureRect").texture = inventory[slot_idx].item.texture
		slots[slot_idx].get_node("Count").text = str(inventory[slot_idx].count)
