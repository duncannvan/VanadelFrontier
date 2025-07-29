class_name InventoryManger extends Node

signal refresh_inventory()

const MAX_INVENTORY_SIZE = 10

var inventory: Dictionary[Item, int] = {}


func add_item(item: Item) -> void:
	if inventory.size() >= MAX_INVENTORY_SIZE:
		return 
		
	if inventory.has(item):
		inventory[item] += 1
	else:
		inventory[item] = 1
		
	emit_signal("refresh_inventory")


func get_inventory() -> Dictionary[Item, int]:
	return inventory 
	
