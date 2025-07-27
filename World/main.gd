extends Node2D

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
	_tool_manager.connect("selected_slot_changed", _on_selected_slot_changed)
	_tool_manager.connect("toolbar_modified", _on_toolbar_modified)
	_toolbar_ui.connect("tool_slot_clicked", _on_tool_slot_clicked)
	
	_base_health_bar.initialize(_base_stats_component.get_health())
	
	# Wait one frame to ensure that the ToolBar UI has been fully processed.
	# Without this, values like `.position` may still be at their default state (Vector2(0, 0))
	await get_tree().process_frame
	_toolbar_ui.refresh_toolbar(_tool_manager.get_all_tools())


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
