extends Node2D

# temp
@onready var _base_stats_component = $Base/StatsComponents
@onready var _mob_spawner = get_node_or_null("MobSpawner")
@onready var _base_health_ui: TextureProgressBar = null
@onready var _base_health_bar = $UI/BaseHealthBar
@onready var _tool_manager = $ToolManager
@onready var _toolbar_ui = $UI/ToolBar
@onready var _player = $Player

func _ready() -> void: 	
	_base_stats_component.connect("died", _on_base_died)
	_base_stats_component.connect("health_changed", _on_health_changed)
	_tool_manager.connect("tool_changed", _on_tool_changed)
	_tool_manager.connect("toolbar_updated", _on_toolbar_updated)
	_toolbar_ui.connect("toolbar_button_pressed", _on_toolbar_button_pressed)
	
	_base_health_bar.initialize(_base_stats_component.get_health())
	
	await get_tree().create_timer(.1).timeout # Some reason we have to wait else the slot position is uninitalized
	_toolbar_ui.refresh_toolbar(_tool_manager.get_all_tools())

func _on_base_died() -> void:
	if _mob_spawner:
		_mob_spawner.disable()


func _on_health_changed() -> void:
	_base_health_bar.update(_base_stats_component.get_health())


func _on_tool_changed(slot_idx: int) -> void:
	_toolbar_ui.update_selected_tool(slot_idx)


func _on_toolbar_button_pressed(slot_idx: int) -> void:
	_player.select_tool(slot_idx)


func _on_toolbar_updated(tools: Array[ToolResource]) -> void:
	_toolbar_ui.refresh_toolbar(tools)
