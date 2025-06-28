extends CharacterBody2D

const SPEED = 10 
const DAMAGE = 10
const DAMAGE_INTERVAL = 0.5
const PLAYER_PATH: NodePath = "../Player"

# Forward declaration. Character needs to exist before finding position
var player: CharacterBody2D 
var slimeInPlayer: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	sprite.animation = "bounce"
	sprite.play()
	
	player = get_node(PLAYER_PATH)
	
	var area2d : Area2D = $Area2D
	
	# Signals
	area2d.body_entered.connect(_body_entered)
	area2d.body_exited.connect(_body_exited)
	
func _body_exited(body: Node2D) -> void:
	slimeInPlayer = false
func _body_entered(body: Node2D) -> void:
	slimeInPlayer = true
	while slimeInPlayer:
		body.take_damage(10, velocity)
		await get_tree().create_timer(DAMAGE_INTERVAL).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player: return
	
	var direction : Vector2 = (player.position - position).normalized()
	
	if not is_knockback:
		velocity = direction * SPEED
	
	move_and_slide()

var is_knockback: bool = false
const KNOCKBACK_MAGNITUDE = 300
const KNOCKBACK_TIME = 0.1
var health = 100
func _apply_knockback(knockback: Vector2):
		is_knockback = true
		velocity = knockback.normalized() * KNOCKBACK_MAGNITUDE

		await get_tree().create_timer(KNOCKBACK_TIME).timeout
		is_knockback = false
		velocity = Vector2.ZERO
		
		#TODO: play knockback animation
		
func take_damage(amount: int, knockback: Vector2) -> void:
	health -= amount
	_apply_knockback(knockback)
	
	
