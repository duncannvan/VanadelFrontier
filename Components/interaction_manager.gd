class_name InteractionManager extends Node2D


@onready var _player = owner
@onready var label: Label = $Label

var can_interact: bool = true
var active_areas: Array[InteractableArea] = []


func _process(delta: float) -> void:
	if len(active_areas) > 0 and can_interact:
		active_areas.sort_custom(_sort_distance_to_player)
		label.global_position = active_areas[0].global_position
		label.global_position.x -= label.size.x / 2
		label.global_position.y -= 26
		label.show()
	else:
		label.hide()


func _unhandled_input(event: InputEvent) -> void:
	if len(active_areas) < 1: 
		return
	if event.is_action_pressed("interact"):
		active_areas[0].interact.call()
		
		
func _sort_distance_to_player(area1: InteractableArea, area2: InteractableArea) -> bool:
	var area1_to_player: float = area1.global_position.distance_to(_player.global_position)
	var area2_to_player: float = area2.global_position.distance_to(_player.global_position)
	return area1_to_player < area2_to_player


func register_area(area: InteractableArea) -> void:
	active_areas.push_back(area)


func unregister_area(area: InteractableArea) -> void:
	active_areas.erase(area)
