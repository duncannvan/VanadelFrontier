extends Control

signal popup_visibility_toggled()

const CRAFT_BUTTON_DELAY: float = 0.1 # Prevents placing down the tower by clicking on the crafting button

@export var tower_resource: TowerResource # TODO: Moving to slot scene

var tower_inst: Tower
var tower_scene: Resource = preload("res://Entities/Towers/ArcherTower/archer_tower.tscn")
var is_player_in_range: bool = false
var placing_tower: bool = false

@onready var _slot_container: GridContainer = %CraftablesContainer
@onready var _craft_recipe_ui: Label = %Label
@onready var _slots: Array[Node] = _slot_container.get_children()
@onready var _player: Player = get_tree().get_first_node_in_group("players") # Player node has to be rendered before UI in the scene tree
@onready var _inventory_manager: InventoryManger = _player.get_node("InventoryManager")
@onready var _craft_button: Button = %CraftButton


func _ready() -> void:
	for slot: TextureButton in _slots:
		slot.pressed.connect(_on_craftable_pressed.bind(slot.get_index()))
	_inventory_manager.refresh_inventory.connect(_on_refresh_inventory)
	_craft_button.pressed.connect(_on_craft_button_pressed)

	
func _process(_delta: float) -> void:
	if placing_tower:
		tower_inst.global_position = get_viewport().get_camera_2d().get_global_mouse_position()
		
		
# TODO: Move to menu mangager
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_tool") and placing_tower:
		placing_tower = false
		tower_inst.get_node("TowerBody").disabled = false
		get_viewport().set_input_as_handled()


func _on_craftable_pressed(slot_idx: int) -> void:
	for slot: TextureButton in _slots: 
		if slot.get_index() != slot_idx:
			slot.set_pressed(false)


func handle_craft_button_press() -> void:
	for slot: TextureButton in _slots:
		if slot.is_pressed():
			tower_inst = tower_scene.instantiate()
			tower_inst.get_node("TowerBody").disabled = true
			get_tree().root.add_child(tower_inst)
			await get_tree().create_timer(CRAFT_BUTTON_DELAY).timeout
			placing_tower = true
			visible = false


func _on_refresh_inventory(inventory: Array[ItemStack]) -> void:
	_craft_recipe_ui.text = str(_inventory_manager.get_count(tower_resource.craft_recipe.item_resource)) + "/" + str(tower_resource.craft_recipe.item_stack_count)


func _on_craft_button_pressed() -> void:
	var craft_recipe_item: ItemStack = tower_resource.craft_recipe
	if _inventory_manager.remove_item(craft_recipe_item):
		handle_craft_button_press()
