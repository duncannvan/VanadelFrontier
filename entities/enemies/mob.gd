class_name Mob extends CombatUnit

enum State {
	ATTACKING,
	KNOCKEDBACK
}

enum TargetingType {
	BASE, 
	PLAYER,
}

const PLAYER_PATH: NodePath = "../Player"

@export var _targeting_type: TargetingType
@export var _death_effect: PackedScene
@export var _hurt_effects: GPUParticles2D

var _state: State 
#@export var _target: Node2D
var _target: Node2D

@onready var _health_component: HealthComponent = $HealthComponent
@onready var _nav_agent: NavigationAgent2D = $MobNavigation


func _init() -> void:
	set_collision_layer(4)


func _ready() -> void:
	super()
	_check_nodes()
				
	var animations = _sprite.sprite_frames.get_animation_names()
	if animations.size() > 0:
		_sprite.animation = animations[0]
		_sprite.play()
	
	_health_component.health_changed.connect(_on_health_changed)
	_nav_agent.velocity_computed.connect(Callable(_on_velocity_computed))


func _physics_process(delta: float) -> void:
	if not _target or not _nav_agent: return

	_nav_agent.target_position = _target.global_position

	if NavigationServer2D.map_get_iteration_id(_nav_agent.get_navigation_map()) == 0:
		return
	if _nav_agent.is_navigation_finished():
		return
	
	var next_path_position: Vector2 = _nav_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * _speed
	if _nav_agent.avoidance_enabled:
		_nav_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	

func _on_velocity_computed(safe_velocity: Vector2):
	if _state != State.KNOCKEDBACK: 
		velocity = safe_velocity
		
	move_and_slide()


func _emit_hurt_effects(color := Color.WHITE):
	if _hurt_effects:
		$HurtEffects.restart()
		$HurtEffects.emitting = true
	super()


func _on_death():
	# Slime death effect
	if _death_effect:
		var _death_effect_instance: GPUParticles2D = _death_effect.instantiate()
		_death_effect_instance.global_position = global_position
		get_parent().add_child(_death_effect_instance)
		_death_effect_instance.emitting = true
	

func apply_knockback(knockback_vector := Vector2.ZERO, knockback_duration: float = 0.0) -> void:
		_state = State.KNOCKEDBACK
		velocity = knockback_vector
		await get_tree().create_timer(knockback_duration).timeout
		velocity = Vector2.ZERO
		_state = State.ATTACKING

func _on_health_changed(old_health: int, new_health: int) -> void:
	if new_health < old_health:
		_emit_hurt_effects()

	if new_health < 0:
		_die()


func get_health() -> int: 
	return _health_component.get_health()


func get_targeting_type() -> TargetingType:
	return _targeting_type


func set_target(target: Node2D) -> void:
	_target = target
