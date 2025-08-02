class_name CraftingTable extends StaticBody2D

signal crafting_range_status(in_range: bool)

@onready var _crafting_range = $Area2D

var player_in_range: bool = false


func _ready() -> void:
	_crafting_range.body_entered.connect(_on_area_entered)
	_crafting_range.body_exited.connect(_on_area_exited)
	
	
func _on_area_entered(player: Player) -> void: 
	player_in_range = true
	emit_signal("crafting_range_status", player_in_range)


func _on_area_exited(player: Player) -> void:
	player_in_range = false
	emit_signal("crafting_range_status", player_in_range)
