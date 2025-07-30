class_name ItemStack extends Resource

var item_resource: ItemResource
var item_stack_count: int


func _init(item: ItemResource, count: int):
	item_resource = item
	item_stack_count = count
