class_name CraftingTable extends StaticBody2D

signal crafting_in_range(in_range: bool)

@onready var area = $Area2D

var player_in_range: bool = false


func _ready() -> void:
	area.body_entered.connect(_on_area_entered)
	area.body_exited.connect(_on_area_exited)
	
	
func _on_area_entered(player: Player) -> void: 
	player_in_range = true
	emit_signal("crafting_in_range", player_in_range)


func _on_area_exited(player: Player) -> void:
	player_in_range = false
	emit_signal("crafting_in_range", player_in_range)
