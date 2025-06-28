extends CharacterBody2D

const SPEED = 10 
const DAMAGE = 10
const PLAYER_PATH: NodePath = "../Player"

# Forward declaration. Character needs to exist before finding position
var player : CharacterBody2D 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite: AnimatedSprite2D = $AnimatedSprite2D
	sprite.animation = "bounce"
	sprite.play()
	
	player = get_node(PLAYER_PATH)
	
	var area2d : Area2D = $Area2D
	area2d.body_entered.connect(_body_entered)
	

func _body_entered(body: Node2D) -> void:
	body.take_damage(DAMAGE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player: return
	
	var direction : Vector2 = (player.position - position).normalized()
	
	velocity = direction * SPEED
	move_and_slide()
	
