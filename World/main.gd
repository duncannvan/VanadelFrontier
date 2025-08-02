extends Node2D

@onready var _base_stats_component = $Base/StatsComponents
@onready var _mob_spawner = get_node_or_null("MobSpawner")
@onready var _base_health_ui: TextureProgressBar = null
@onready var _base_health_bar = $UI/BaseHealthBar
@onready var _tool_manager = $Player/ToolManager
@onready var _toolbar_ui = $UI/ToolBar
@onready var _player = $Player
@onready var _inventory_manager = $Player/InventoryManager
@onready var _inventory_ui = $UI/Inventory
@onready var _nature_spawner: NatureSpawner = $NatureSpawner
@onready var _crafting_table: CraftingTable = $CraftingTable
@onready var _crafting_ui = $UI/CraftingMenu

func _ready() -> void:
	_base_stats_component.died.connect(_on_base_died)
	_base_stats_component.health_changed.connect(_on_health_changed)
	_tool_manager.selected_slot_changed.connect(_on_selected_slot_changed)
	_tool_manager.toolbar_modified.connect(_on_toolbar_modified)
	_toolbar_ui.tool_slot_clicked.connect(_on_tool_slot_clicked)
	_tool_manager.tool_used.connect(_on_tool_used)
	_inventory_manager.refresh_inventory.connect(_on_refresh_inventory)
	_base_health_bar.initialize(_base_stats_component.get_health())
	_toolbar_ui.refresh_toolbar(_tool_manager.get_all_tools())
	_nature_spawner.child_entered_tree.connect(_on_nature_obj_respawned)
	_mob_spawner.mob_spawned.connect(_on_mob_spawned)
	_crafting_table.crafting_range_status.connect(_on_crafting_menu_update)
	_inventory_ui.inventory_ui_update.connect(_on_inventory_menu_update)
	_crafting_ui.craft_button.pressed.connect(_on_craft_button_pressed)
	
	for objects: NatureObject in get_tree().get_nodes_in_group("nature_objects"):
		objects.item_dropped.connect(_on_loot_dropped)
		

func _on_base_died() -> void:
	if _mob_spawner:
		_mob_spawner.disable()


func _on_health_changed() -> void:
	_base_health_bar.update(_base_stats_component.get_health())


func _on_selected_slot_changed(slot_idx: int) -> void:
	_toolbar_ui.update_selected_tool(slot_idx)


func _on_tool_slot_clicked(slot_idx: int) -> void:
	_player.select_tool(slot_idx)


func _on_toolbar_modified(tools: Array[ToolResource]) -> void:
	_toolbar_ui.refresh_toolbar(tools)


func _on_tool_used(cooldown_sec: float, selected_tool_idx: int) -> void:
	_toolbar_ui.start_cooldown(cooldown_sec, selected_tool_idx)


func _on_refresh_inventory() -> void:
	_inventory_ui.refresh_inventory(_inventory_manager.get_inventory())
	
	var craft_recipe_item: ItemResource = _crafting_ui.tower_resource.craft_recipe.item_resource
	_crafting_ui.update_craft_recipe_ui(_inventory_manager.get_count(craft_recipe_item))

func _on_loot_dropped(item: ItemResource) -> void:
	_inventory_manager.add_item(item)


func _on_mob_spawned(mob: Mob) -> void:
	mob.loot_dropped.connect(_on_loot_dropped)


func _on_nature_obj_respawned(obj: NatureObject) -> void:
	obj.nature_object_died.connect(_nature_spawner._handle_respawn)
	obj.item_dropped.connect(_on_loot_dropped)

# TODO: Menu manager to open on menu at a time
func _on_crafting_menu_update(in_range: bool) -> void:
	if not _inventory_ui.is_visible():
		if not in_range:
			_crafting_ui.set_visible(false)
			_crafting_ui.is_player_in_range = false
		else:
			_crafting_ui.is_player_in_range = in_range


func _on_inventory_menu_update(is_open: bool) -> void:
	if not _crafting_ui.is_visible():
		_crafting_ui.all_menus_closed = !_crafting_ui.all_menus_closed 
		_inventory_ui.set_visible(is_open)


func _on_craft_button_pressed():
	var craft_recipe_item: ItemStack = _crafting_ui.tower_resource.craft_recipe
	_crafting_ui.handle_craft_button_press(_inventory_manager.remove_item(craft_recipe_item))
