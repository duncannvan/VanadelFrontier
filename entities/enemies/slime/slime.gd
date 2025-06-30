class_name Slime extends CombatEntityBase

# Constructor
func _init() -> void:
	var data: Dictionary = {
							"health" = 100,
							"speed" = 50,
							"damage" = 10,
							"knockback_mag" = 200,
							}
	super._init(data)
	
# Called when the node enters the scene tree for the first time
func _ready() -> void:		
	_player = get_node(PLAYER_PATH)
	_init_nodes($AnimatedSprite2D, $Hurtbox, $Hitbox, $HurtEffects)
	
	_sprite.animation = "bounce"
	_sprite.play()
	
	# Signals
	_hitbox.area_entered.connect(_area_entered)
	_hitbox.area_exited.connect(_area_exited)
	
func _area_exited(area: Area2D) -> void:
	_state = States.MOVING
	
func _area_entered(area: Area2D) -> void:
	var playerArea2D: CharacterBody2D = area.get_parent()
	_state = States.ATTACKING
	while _state == States.ATTACKING:
		playerArea2D._upon_hit(_damage, velocity.normalized())
		await get_tree().create_timer(DAMAGE_INTERVAL).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _player: return
	
	var direction : Vector2 = (_player.position - position).normalized()
	
	if not is_knockback:
		velocity = direction * _speed
	
	move_and_slide()

enum States {MOVING, ATTACKING}
var _state: States = States.MOVING
# Forward declaration. Character needs to exist before finding position
var _player: Player 

# Constants
const DAMAGE_INTERVAL = 0.5
const PLAYER_PATH: NodePath = "../Player"

	
