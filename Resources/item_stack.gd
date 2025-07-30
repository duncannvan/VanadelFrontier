class_name ItemStack extends Resource

var item_resouce: ItemResouce
var num_item_stack: int


func _init(item: ItemResouce, count: int):
	item_resouce = item
	num_item_stack = count
