class_name ItemStack extends Resource

@export var item_resource: ItemResource
@export var item_stack_count: int


func _init(item: ItemResource = null, count: int = 0):
	item_resource = item
	item_stack_count = count
