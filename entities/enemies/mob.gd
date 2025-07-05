class_name Mob extends CombatUnit

enum State {
	ATTACKING,
	KNOCKEDBACK
}

const PLAYER_PATH: NodePath = "../Player"

@export var _death_effect: PackedScene
@export var _hurt_effects: GPUParticles2D

var _state: State 
var current_target: Node2D 
var base_target: Node2D

@onready var _health_component: HealthComponent = $HealthComponent
@onready var _aggro_range: Area2D = get_node_or_null("AggroRange")


func _init() -> void:
	set_collision_layer(4)


func _ready() -> void:
	super()
	_check_nodes()
	
	var animations = _sprite.sprite_frames.get_animation_names()
	if animations.size() > 0:
		_sprite.animation = animations[0]
		_sprite.play()
	
	if _aggro_range:
		_aggro_range.connect("body_entered", _on_area_entered)
		_aggro_range.connect("body_exited", _on_area_exited)
	_health_component.health_changed.connect(_on_health_changed)


func _physics_process(delta: float) -> void:
	if not current_target: return
	
	var direction : Vector2 = (current_target.global_position - global_position).normalized()
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
		

func _on_area_entered(enemy: CombatUnit) -> void:
	modulate = Color.RED
	current_target = enemy


func _on_area_exited(enemy: CombatUnit) -> void:
	modulate = Color.WHITE
	current_target = base_target


func _on_health_changed(old_health: int, new_health: int) -> void:
	if new_health < old_health:
		_emit_hurt_effects()

	if new_health < 0:
		_die()


func get_health() -> int: 
	return _health_component.get_health()
