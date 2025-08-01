class_name CraftingTable extends StaticBody2D

signal crafting_menu_update(open: bool)

@onready var area = $Area2D

var player_in_range: bool = false
var is_menu_open = false


func _ready() -> void:
	area.body_entered.connect(_on_area_entered)
	area.body_exited.connect(_on_area_exited)
	
	
func _on_area_entered(player: Player) -> void: 
	player_in_range = true


func _on_area_exited(player: Player) -> void:
	player_in_range = false
	is_menu_open = false
	emit_signal("crafting_menu_update", is_menu_open)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_range:
		is_menu_open = !is_menu_open
		emit_signal("crafting_menu_update", is_menu_open)
