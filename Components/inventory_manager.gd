class_name InventoryManger extends Node

signal refresh_inventory()

const MAX_INVENTORY_SIZE = 10
const MAX_STACKS = 99

var inventory: Array[ItemStack] = [] 


func add_item(item: ItemResource) -> void:
	if inventory.size() >= MAX_INVENTORY_SIZE:
		return 
	
	for stack: ItemStack in inventory:
		if stack.item_resource == item and stack.item_stack_count < MAX_STACKS:
			stack.item_stack_count += 1
			emit_signal("refresh_inventory")
			return
		
	inventory.append(ItemStack.new(item, 1))
	emit_signal("refresh_inventory")


func remove_item(item_stack: ItemStack) -> bool:
	for stack: ItemStack in inventory:
		if stack.item_resource == item_stack.item_resource and stack.item_stack_count >= item_stack.item_stack_count:
			stack.item_stack_count -= item_stack.item_stack_count
			emit_signal("refresh_inventory")
			return true
	return false


func get_count(item: ItemResource) -> int:
	var count = 0
	for stack: ItemStack in inventory:
		if stack.item_resource == item:
			count += stack.item_stack_count
	
	return count

func get_inventory() -> Array[ItemStack]:
	return inventory 
	
	
