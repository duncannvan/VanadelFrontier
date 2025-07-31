class_name CraftingTable extends StaticBody2D

signal crafting_menu_update(open: bool)
@onready var area = $Area2D
var player_in_range: bool = false
var is_menu_open = false

func _ready() -> void:
	area.area_entered.connect(_on_area_entered)
	area.area_exited.connect(_on_area_exited)
	
	
func _on_area_entered(body: Node) -> void: 
	#TODO: Confirm body param is a Player
	player_in_range = true


func _on_area_exited(body: Node) -> void:
	#TODO: Confirm body param is a Player
	player_in_range = false
	is_menu_open = false
	emit_signal("crafting_menu_update", is_menu_open)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_range:
		is_menu_open = !is_menu_open
		emit_signal("crafting_menu_update", is_menu_open)
