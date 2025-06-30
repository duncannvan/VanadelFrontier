class_name Slime extends CombatEntityBase

# Constructor
func _init() -> void:
	var data: Dictionary = {
							"health" = 100,
							"speed" = 50,
							"damage" = 10,
							"knockback_force" = 200,
							}
	super._init(data)
	
# Called when the node enters the scene tree for the first time
func _ready() -> void:		
	_init_nodes($AnimatedSprite2D, $HurtBox, $HitBox, $HurtEffects)
	
	_sprite.animation = "bounce"
	_sprite.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not target: return
	
	var direction : Vector2 = (target.position - position).normalized()
	
	if _state != States.KNOCKEDBACK:
		velocity = direction * _speed
	
	move_and_slide()
	
func take_damage(damageAmount: int, knockback_dir: Vector2 = Vector2.ZERO) -> void:
	apply_knockback(knockback_dir)
	super.take_damage(damageAmount, knockback_dir)
	
func apply_knockback(knockbackDirection: Vector2 = Vector2.ZERO) -> void:
	_state = States.KNOCKEDBACK
	await super.apply_knockback(knockbackDirection)
	_state = States.MOVING


enum States {MOVING, ATTACKING, KNOCKEDBACK}
var _state: States = States.MOVING

# Constants
const DAMAGE_INTERVAL = 0.5
const PLAYER_PATH: NodePath = "../Player"

# Public members
var target: Node2D = null

	
