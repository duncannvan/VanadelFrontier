class_name ItemStack extends Resource

var item_resouce: ItemResouce
var item_stack_count: int


func _init(item: ItemResouce, count: int):
	item_resouce = item
	item_stack_count = count
