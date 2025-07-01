class_name Slime extends CombatEntityBase

enum States {
	MOVING, 
	ATTACKING, 
	KNOCKEDBACK
	}

const DAMAGE_INTERVAL: float = 0.5
const PLAYER_PATH: NodePath = "../Player"

@export var slime_death_effect: PackedScene

var current_target: Node2D
var base_target: Node2D 
var _state: States = States.MOVING

# Constructor
func _init() -> void:
	var data: Dictionary = {
		"health" = 100,
		"speed" = 50,
		"damage" = 10,
		"knockback_force" = 200,
		}
	super._init(data)
	
	
func _ready() -> void:
	_init_nodes($AnimatedSprite2D, $HurtBox)
	
	_sprite.animation = "bounce"
	_sprite.play()


func _process(delta: float) -> void:
	if not current_target: return
	
	var direction : Vector2 = (current_target.position - position).normalized()
	
	if _state != States.KNOCKEDBACK:
		velocity = direction * _speed
	
	move_and_slide()
	
	
func _hurt_effects(color := Color.WHITE):
	$HurtEffects.restart()
	$HurtEffects.emitting = true
	super._hurt_effects()
	
	
func _on_death():
	$AggroRange.off()
	$BodyHitBox.off()
	
	# Slime death effect
	var slime_death_effect_instance: GPUParticles2D = slime_death_effect.instantiate()
	slime_death_effect_instance.global_position = global_position
	get_parent().add_child(slime_death_effect_instance)
	slime_death_effect_instance.emitting = true
	
	
func take_damage(damageAmount: int, knockback_dir := Vector2.ZERO) -> void:
	_apply_knockback(knockback_dir)
	super.take_damage(damageAmount, knockback_dir)
	
	
func _apply_knockback(knockbackDirection := Vector2.ZERO) -> void:
	_state = States.KNOCKEDBACK
	await super._apply_knockback(knockbackDirection)
	_state = States.MOVING




	
