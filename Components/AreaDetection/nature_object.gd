class_name NatureObject extends Area2D

@export var dropped_item: ItemResource = null

func _ready() -> void:
	connect("area_entered", _on_area_entered)


func _on_area_entered(havest_tool: HarvestingToolResource) -> void:
	havest_tool.harvest_tool_entered.emit(self)
