extends Node2D

@export var waves: Array[Wave]

var current_wave: int = 0

@onready var _wave_countdown_timer: Timer = $WaveCountdownTimer
@onready var _wave_countdown_timer_ui: Control = $UI/WaveCountdownTimer
@onready var _base_stats_component = $Base/StatsComponents
@onready var _mob_spawner = get_node_or_null("MobSpawner")
@onready var _base_health_ui: TextureProgressBar = null
@onready var _base_health_bar = $UI/BaseHealthBar
@onready var _player = $Player
@onready var _inventory_manager = $Player/InventoryManager
@onready var _nature_spawner: NatureSpawner = $NatureSpawner


func _ready() -> void:
	_wave_countdown_timer.timeout.connect(_start_wave)
	_mob_spawner.wave_cleared.connect(_start_wave_countdown)
	_base_stats_component.died.connect(_on_base_died)
	_base_stats_component.health_changed.connect(_on_health_changed)
	_base_health_bar.initialize(_base_stats_component.get_health())
	_nature_spawner.child_entered_tree.connect(_on_nature_obj_respawned)
	
	for objects: NatureObject in get_tree().get_nodes_in_group("nature_objects"):
		objects.item_dropped.connect(_on_loot_dropped)

	_start_wave_countdown()
	

func _start_wave() -> void:
	_mob_spawner.start_wave(waves[current_wave])
	current_wave += 1


func _start_wave_countdown() -> void:
	if current_wave >= len(waves): 
		return
	_wave_countdown_timer_ui.start_countdown(_wave_countdown_timer)
	_wave_countdown_timer.start()


func _on_base_died() -> void:
	if _mob_spawner:
		_mob_spawner.disable()


func _on_health_changed() -> void:
	_base_health_bar.update(_base_stats_component.get_health())


func _on_loot_dropped(item: ItemResource) -> void:
	_inventory_manager.add_item(item)


func _on_mob_spawned(mob: Mob) -> void:
	mob.loot_dropped.connect(_on_loot_dropped)


func _on_nature_obj_respawned(obj: NatureObject) -> void:
	obj.nature_object_died.connect(_nature_spawner._handle_respawn)
	obj.item_dropped.connect(_on_loot_dropped)
