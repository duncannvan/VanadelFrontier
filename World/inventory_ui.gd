extends Control

signal inventory_ui_update(is_open: bool) # TODO: Remove once UI manager in place
@onready var _slot_container: GridContainer = %SlotContainer
@onready var slots: Array[Node] = _slot_container.get_children()

# TODO: Move to ui manager
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		emit_signal("inventory_ui_update", !visible)


func refresh_inventory(inventory: Array[ItemStack]) -> void:
	
	for slot_idx: int in InventoryManger.MAX_INVENTORY_SIZE:
		if slot_idx < len(inventory):
			slots[slot_idx].get_node("ItemTextureRect").texture = inventory[slot_idx].item_resource.texture
			slots[slot_idx].get_node("Count").text = str(inventory[slot_idx].item_stack_count)
		else:
			slots[slot_idx].get_node("ItemTextureRect").texture = null
			slots[slot_idx].get_node("Count").text = ""
