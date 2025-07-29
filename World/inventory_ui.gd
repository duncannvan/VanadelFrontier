extends Control

@onready var _slot_container: GridContainer = %SlotContainer
@onready var slots: Array[Node] = _slot_container.get_children()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Inventory"):
		visible = !visible


func refresh_inventory(inventory: Dictionary[Item, int]) -> void:
	var i := 0
	for item in inventory:
		var amount = inventory[item]
		slots[i].get_node("ItemTextureRect").texture = item.texture
		slots[i].get_node("Count").text = str(inventory[item])
		i += 1
