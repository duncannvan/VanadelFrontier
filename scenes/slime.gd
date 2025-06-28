extends CharacterBody2D

@export var speed = 10.0
@export var player_path = "../Player" 
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite = $AnimatedSprite2D
	sprite.animation = "bounce"
	sprite.play()
	
	player = get_node(player_path)
	
	var area2d = $Area2D
	area2d.body_entered.connect(_body_entered)
	
func _body_entered(body) -> void:
	print("Collision with:", body.name)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player: return
	
	var direction = (player.position - position).normalized()
	velocity = direction * speed
	move_and_slide()
	
