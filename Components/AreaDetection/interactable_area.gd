class_name InteractableArea extends Area2D

@export var action_name: String = "interact"


func _ready() -> void:
	body_entered.connect(_on_area_entered)
	body_exited.connect(_on_area_exited)
	
	collision_mask = 2
	
func _on_area_entered(player: Player) -> void: 
	player.get_node("InteractionManager").register_area(self)


func _on_area_exited(player: Player) -> void:
	player.get_node("InteractionManager").unregister_area(self)
	#if _crafting_menu.visible:
		#_crafting_menu.popup_visibility_toggled.emit()


var interact = func interact() -> void:
	pass


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("interact"):
		#pass
