class_name Slime extends CombatUnit

enum State {
	MOVING, 
	ATTACKING, 
	KNOCKEDBACK
}

const PLAYER_PATH: NodePath = "../Player"

@export var slime_death_effect: PackedScene

var current_target: Node2D 
var base_target: Node2D
var _state: State = State.MOVING

@onready var _aggro_range = $AggroRange

# Constructor
#func _init() -> void:
	#var data: Dictionary = {
		#"max_health" = 100,
		#"speed" = 50,
		#}
	#super._init(data)


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


func _hurt_effects(color := Color.WHITE):
	$HurtEffects.restart()
	$HurtEffects.emitting = true
	super._hurt_effects()


func _on_death():
	#$AggroRange.off()
	$BodyHitBox.off()
	
	# Slime death effect
	var slime_death_effect_instance: GPUParticles2D = slime_death_effect.instantiate()
	slime_death_effect_instance.global_position = global_position
	get_parent().add_child(slime_death_effect_instance)
	slime_death_effect_instance.emitting = true
	

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
