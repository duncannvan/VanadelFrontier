extends Control

const CRAFT_BUTTON_DELAY: float = 0.1 # Prevents placing down the tower by clicking on the crafting button

@export var tower_resource: TowerResource # TODO: Moving to slot scene

var tower_inst: Tower
var tower_scene: Resource = preload("res://Entities/Towers/ArcherTower/archer_tower.tscn")
var all_menus_closed: bool = true
var is_player_in_range: bool = false
var placing_tower: bool = false

@onready var craft_button: Button = %Button
@onready var _slot_container: GridContainer = %CraftablesContainer
@onready var _craft_recipe_ui: Label = %Label
@onready var _slots: Array[Node] = _slot_container.get_children()


func _ready() -> void:
	for slot: TextureButton in _slots:
		slot.pressed.connect(_on_craftable_pressed.bind(slot.get_index()))
		
	
func _process(_delta: float):
	if placing_tower:
		tower_inst.global_position = get_viewport().get_camera_2d().get_global_mouse_position()
		
# TODO: Move to menu mangager
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("use_tool") and placing_tower:
		placing_tower = false
		tower_inst.get_node("TowerBody").disabled = false

	elif  event.is_action_pressed("interact") and all_menus_closed and is_player_in_range:
		visible = !visible


func _on_craftable_pressed(slot_idx: int):
	for slot: TextureButton in _slots: 
		if slot.get_index() != slot_idx:
			slot.set_pressed(false)


func handle_craft_button_press(can_craft: bool):
	if not can_craft:
		return
	
	for slot in _slots:
		if slot.is_pressed():
			tower_inst = tower_scene.instantiate()
			#tower_inst.global_position = get_viewport().get_camera_2d().get_global_mouse_position()
			tower_inst.get_node("TowerBody").disabled = true
			get_parent().get_parent().add_child(tower_inst)
			await get_tree().create_timer(CRAFT_BUTTON_DELAY).timeout
			placing_tower = true
			visible = false


func update_craft_recipe_ui(num_resources: int):
	_craft_recipe_ui.text = str(num_resources) + "/" + str(tower_resource.craft_recipe.item_stack_count)
