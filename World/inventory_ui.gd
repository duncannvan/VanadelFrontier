extends Control

signal popup_visibility_toggled()

@onready var _slot_container: GridContainer = %SlotContainer
@onready var slots: Array[Node] = _slot_container.get_children()
@onready var _player: Player = get_tree().get_first_node_in_group("players") # Player node has to be rendered before UI in the scene tree
@onready var _inventory_manager = _player.get_node("InventoryManager") 


func _ready() -> void:
	_inventory_manager.refresh_inventory.connect(_on_refresh_inventory)


# TODO: Move to ui manager
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		popup_visibility_toggled.emit()
		

func _on_refresh_inventory(inventory: Array[ItemStack]) -> void:
	for slot_idx: int in InventoryManger.MAX_INVENTORY_SIZE:
		if slot_idx < len(inventory):
			slots[slot_idx].get_node("ItemTextureRect").texture = inventory[slot_idx].item_resource.texture
			slots[slot_idx].get_node("Count").text = str(inventory[slot_idx].item_stack_count)
		else:
			slots[slot_idx].get_node("ItemTextureRect").texture = null
			slots[slot_idx].get_node("Count").text = ""
