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
var _target: Node2D 

@onready var _health_component: HealthComponent = $HealthComponent


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


func _physics_process(delta: float) -> void:
	if not _target: return
	
	var direction : Vector2 = (_target.global_position - global_position).normalized()
	if _state != State.KNOCKEDBACK:
		velocity = direction * _speed
	
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
