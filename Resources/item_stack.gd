class_name ItemStack extends Resource

@export var item: Item
@export var count: int


func _init(item: Item, count: int):
	self.item = item
	self.count = count
