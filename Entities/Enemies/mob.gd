class_name Mob extends CombatUnit

enum State {
	USING_TOOL,
	KNOCKEDBACK
}
enum TargetingType {
	BASE, 
	PLAYER,
}

signal loot_dropped(item: ItemResouce)

const PLAYER_PATH: NodePath = "../Player"

@export var _targeting_type: TargetingType = TargetingType.BASE
@export var _death_effect: PackedScene = null
@export var _target: Node2D = null
@export var _loot_drop: ItemResouce = null

var _state: State = State.USING_TOOL

@onready var _nav_agent: NavigationAgent2D = $MobNavigation
@onready var _damaged_animation: AnimationPlayer = $DamagedAnimation
@onready var _hurtbox: HurtBox = $HurtBox
@onready var _stats_component: StatsComponents = $StatsComponents
@onready var _damaged_particles: GPUParticles2D = $DamagedParticles
@onready var _slowed_animation: AnimationPlayer = $SlowedAnimation


func _ready() -> void:
	_hurtbox.hurtbox_entered.connect(_apply_attack_effects)
	_nav_agent.velocity_computed.connect(_on_velocity_computed)
	_stats_component.died.connect(_die)
	_stats_component.slowed_ended.connect(_remove_slow)


func _physics_process(delta: float) -> void:
	if not _target or not _nav_agent: 
		return
	
	_nav_agent.set_target_position(_target.global_position)

	# Exit early if the navigation map hasn't been initialized or updated yet
	if NavigationServer2D.map_get_iteration_id(_nav_agent.get_navigation_map()) == 0:
		return
	# Exit early if the agent has already reached its destination
	if _nav_agent.is_navigation_finished():
		return
	
	var next_path_position: Vector2 = _nav_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * _stats_component.get_current_speed()
	
	if _nav_agent.avoidance_enabled:
		_nav_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	

func _on_velocity_computed(adjusted_velocity: Vector2):
	if not _target: 
		velocity = Vector2.ZERO
	
	if _state != State.KNOCKEDBACK: 
		velocity = adjusted_velocity
	
	move_and_slide()


func apply_slow(slowed_factor: float, slowed_duration: int) -> void:
	_slowed_animation.play("slowed_effects")
	_stats_component.apply_slow(slowed_factor, slowed_duration)


func _remove_slow() -> void:
	_slowed_animation.seek(0.0)
	_slowed_animation.stop()
	

func _emit_damaged_effects(hitbox_position: Vector2):
	if _damaged_particles:
		_damaged_particles.rotation = hitbox_position.direction_to(global_position).angle()

	_damaged_animation.play("damaged_effects")


func _apply_attack_effects(hitbox: HitBox) -> void:
	for effect in hitbox.attack_effects:
		effect.apply(self, hitbox.global_position)


func _die() -> void:
	if _death_effect:
		var _death_effect_instance: Node2D = _death_effect.instantiate()
		_death_effect_instance.global_position = global_position
		get_tree().root.add_child(_death_effect_instance)
	if _loot_drop:
		emit_signal("loot_dropped", _loot_drop)
	queue_free()


func apply_knockback(knockback_vector := Vector2.ZERO, knockback_duration: float = 0.0) -> void:
		_state = State.KNOCKEDBACK
		velocity = knockback_vector
		await get_tree().create_timer(knockback_duration).timeout
		_state = State.USING_TOOL

 
func apply_damage(damage: int, hitbox_position: Vector2) -> void:
		_emit_damaged_effects(hitbox_position)
		_stats_component.apply_damage(damage)


func get_health() -> int: 
	return _stats_component.get_health()


func get_targeting_type() -> TargetingType:
	return _targeting_type


func set_target(target: Node2D) -> void:
	_target = target
