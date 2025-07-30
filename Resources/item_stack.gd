class_name ItemStack extends Resource

var item_resouce: ItemResource
var item_stack_count: int


func _init(item: ItemResource, count: int):
	item_resouce = item
	item_stack_count = count
