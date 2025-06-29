extends CombatEntityBase

const DAMAGE_INTERVAL = 0.5
const PLAYER_PATH: NodePath = "../Player"

# Forward declaration. Character needs to exist before finding position
var player: CharacterBody2D 
var slimeInPlayer: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Constructor
	speed = 50
	damage = 10
	sprite = $AnimatedSprite2D
	hitbox = $Hitbox
	hurtbox = $Hurtbox
	
	sprite.animation = "bounce"
	sprite.play()
	
	player = get_node(PLAYER_PATH)
	
	# Signals
	hitbox.area_entered.connect(_area_entered)
	hitbox.area_exited.connect(_area_exited)
	
func _area_exited(area: Area2D) -> void:
	slimeInPlayer = false
func _area_entered(area: Area2D) -> void:
	player = area.get_parent()
	slimeInPlayer = true
	while slimeInPlayer:
		player.take_damage(damage, velocity.normalized())
		await get_tree().create_timer(DAMAGE_INTERVAL).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player: return
	
	var direction : Vector2 = (player.position - position).normalized()
	
	if not is_knockback:
		velocity = direction * speed
	
	move_and_slide()


	
