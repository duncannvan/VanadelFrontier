class_name Mob extends CombatUnit

enum State {
	MOVING, 
	ATTACKING, 
	KNOCKEDBACK
}

const PLAYER_PATH: NodePath = "../Player"

@export var _death_effect: PackedScene
@export var _body_hitbox: BodyHitbox
@export var _aggro_range: Area2D
@export var _hurt_effects: GPUParticles2D

var current_target: Node2D 
var base_target: Node2D
var _state: State = State.MOVING


func _ready() -> void:
	super()
	_check_nodes()
	
	_sprite.animation = "bounce"
	_sprite.play()
	
	_aggro_range.connect("body_entered", _on_area_entered)
	_aggro_range.connect("body_exited", _on_area_exited)


func _physics_process(delta: float) -> void:
	if not current_target or not entity_data: return
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
	if _body_hitbox:
		_body_hitbox.off()
	
	# Slime death effect
	var _death_effect_instance: GPUParticles2D = _death_effect.instantiate()
	_death_effect_instance.global_position = global_position
	get_parent().add_child(_death_effect_instance)
	_death_effect_instance.emitting = true
	

func _apply_knockback(
	knockback_vector := Vector2.ZERO, 
	knockback_duration: float = 0.0
	) -> void:
		_state = State.KNOCKEDBACK
		await super(knockback_vector, knockback_duration)
		_state = State.MOVING
		

func _on_area_entered(enemy: CombatUnit) -> void:
	modulate = Color.RED
	current_target = enemy


func _on_area_exited(enemy: CombatUnit) -> void:
	modulate = Color.WHITE
	current_target = base_target
