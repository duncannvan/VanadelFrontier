extends Control

@onready var _slot_container: GridContainer = $ColorRect/VBoxContainer/CraftablesContainer
@onready var _craft_button: Button = $ColorRect/VBoxContainer/Button
@onready var slots: Array[Node] = _slot_container.get_children()
var tower_scene = preload("res://Entities/Towers/ArcherTower/archer_tower.tscn")
var tower_silo: Tower

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
			placing_tower = true
			visible = false
			tower_silo = tower_scene.instantiate()
			tower_silo.visible = true
			tower_silo.get_child(4).set_deferred("Disabled", false)
			tower_silo.global_position = get_viewport().get_camera_2d().get_global_mouse_position()
			get_parent().get_parent().add_child(tower_silo)


func _process(delta):
	if placing_tower:
		print(tower_silo.global_position)
		tower_silo.global_position = get_viewport().get_camera_2d().get_global_mouse_position()
		
		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("use_tool") and placing_tower:
		placing_tower = false
