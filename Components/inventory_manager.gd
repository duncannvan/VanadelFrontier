class_name InventoryManger extends Node

signal refresh_inventory()

const MAX_INVENTORY_SIZE = 10
const MAX_STACKS = 99

var inventory: Array[ItemStack] = [] 


func add_item(item: Item) -> void:
	if inventory.size() >= MAX_INVENTORY_SIZE:
		return 
	
	for stack: ItemStack in inventory:
		if stack.item == item and stack.count < MAX_STACKS:
			stack.count += 1
			emit_signal("refresh_inventory")
			return
		
	
	inventory.append(ItemStack.new(item, 1))
	emit_signal("refresh_inventory")


func get_inventory() -> Array[ItemStack]:
	return inventory 
	
	
