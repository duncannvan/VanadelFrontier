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
@export var _target: Node2D

var _state: State 

@onready var _health_component: HealthComponent = $HealthComponent
@onready var _nav_agent: NavigationAgent2D = $MobNavigation
@onready var effects_animation_player: AnimationPlayer = $EffectsAnimationPlayer
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _hurtbox: HurtBox = $HurtBox
@onready var _speed_component: SpeedComponent = $SpeedComponent


func _ready() -> void:
	_check_nodes()

	#_health_component.health_changed.connect(_on_health_changed)
	_health_component.connect("died", _die)
	_hurtbox.hurt.connect(_apply_attack_effects)
	_nav_agent.velocity_computed.connect(_on_velocity_computed)


func _physics_process(delta: float) -> void:
	if not _target or not _nav_agent: return
	
	_nav_agent.target_position = _target.global_position

	if NavigationServer2D.map_get_iteration_id(_nav_agent.get_navigation_map()) == 0:
		return
	if _nav_agent.is_navigation_finished():
		return
	
	var next_path_position: Vector2 = _nav_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * _speed_component.speed
	if _nav_agent.avoidance_enabled:
		_nav_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	

func _on_velocity_computed(safe_velocity: Vector2):
	if not _target: 
		velocity = Vector2.ZERO
	
	if _state != State.KNOCKEDBACK: 
		velocity = safe_velocity
	
	move_and_slide()


func _emit_hurt_effects():
	if _hurt_effects:
		$HurtEffects.restart()
		$HurtEffects.emitting = true
	effects_animation_player.play("hitflash")


func _apply_attack_effects(hitbox: HitBox) -> void:
	for effect in hitbox.attack_effects:
		if effect is KnockbackEffect:
			effect.apply_knockback(self, hitbox.global_position)
		else:
			effect.apply(self)
			

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
		_state = State.ATTACKING

 
func apply_damage(damage: int) -> void:
		_emit_hurt_effects()
		_health_component.apply_damage(damage)

func get_health() -> int: 
	return _health_component.get_health()


func get_targeting_type() -> TargetingType:
	return _targeting_type


func set_target(target: Node2D) -> void:
	_target = target
