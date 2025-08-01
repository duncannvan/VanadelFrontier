class_name InventoryManger extends Node

signal refresh_inventory()

const MAX_INVENTORY_SIZE = 10
const MAX_STACKS = 2

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
	var total_item_count: int = 0
	var num_left_to_remove: int = item_stack.item_stack_count
	var stacks_to_remove: Array[ItemStack] = []
	
	# Get total counts of the item in inventory
	for stack: ItemStack in inventory:
		if stack.item_resource == item_stack.item_resource:
			total_item_count += stack.item_stack_count
	
	# Not enough in inventory to remove
	if item_stack.item_stack_count > total_item_count:
		return false
	
	# Remove items in inventory
	for stack: ItemStack in inventory:
		if stack.item_resource == item_stack.item_resource:
			if stack.item_stack_count > num_left_to_remove:
				stack.item_stack_count -= num_left_to_remove
				break;
			else:
				num_left_to_remove -= stack.item_stack_count
				stack.item_stack_count = 0
				stacks_to_remove.append(stack)
	
	# Remove item stacks
	for i in len(stacks_to_remove):
		inventory.erase(stacks_to_remove[i])
			
	emit_signal("refresh_inventory")
	return true


func get_count(item: ItemResource) -> int:
	var count = 0
	for stack: ItemStack in inventory:
		if stack.item_resource == item:
			count += stack.item_stack_count
	
	return count

func get_inventory() -> Array[ItemStack]:
	return inventory 
	
	
