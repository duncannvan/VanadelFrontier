extends Control

@onready var _slot_container: GridContainer = $ColorRect/VBoxContainer/CraftablesContainer
@onready var _craft_button: Button = $ColorRect/VBoxContainer/Button
@onready var slots: Array[Node] = _slot_container.get_children()
var tower_scene: Resource = preload("res://Entities/Towers/ArcherTower/archer_tower.tscn")
var tower_inst: Tower

var placing_tower: bool = false


func _ready() -> void:
	for slot: TextureButton in slots:
		slot.pressed.connect(_on_craftable_pressed.bind(slot.get_index()))
		
	_craft_button.pressed.connect(_on_craft_button_pressed)
		

func _on_craftable_pressed(slot_idx: int):
	for slot: TextureButton in slots: 
		if slot.get_index() != slot_idx:
			slot.set_pressed(false)


func _on_craft_button_pressed():
	for slot in slots:
		if slot.is_pressed():
			visible = false
			tower_inst = tower_scene.instantiate()
			tower_inst.global_position = get_viewport().get_camera_2d().get_global_mouse_position()
			tower_inst.get_node("TowerBody").disabled = true
			get_parent().get_parent().add_child(tower_inst)
			await get_tree().create_timer(0.1).timeout
			placing_tower = true


func _process(delta):
	if placing_tower:
		tower_inst.global_position = get_viewport().get_camera_2d().get_global_mouse_position()
		
		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("use_tool") and placing_tower:
		placing_tower = false
		tower_inst.get_node("TowerBody").disabled = false
