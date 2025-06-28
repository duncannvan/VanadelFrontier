extends CharacterBody2D

const SPEED = 100
const INVINCIBILITY_TIME = 1
const KNOCKBACK_MAGNITUDE = 200
const KNOCKBACK_TIME = .1 

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var attack_hitbox: Area2D

@export var health = 100
@export var is_invincible = false
var knockback: Vector2 = Vector2.ZERO
var is_knockback: bool = false

const HEARTS_CONTAINER_PATH = '../Player/Hearts'
var hearts_container: Container
var heart_scene: Resource = preload('res://scenes/heart.tscn')

func _initialize_hearts() -> void:
	hearts_container = get_node(HEARTS_CONTAINER_PATH)
	for i in range(10):
		var heart = heart_scene.instantiate()
		hearts_container.add_child(heart)

func _ready() -> void:
	_initialize_hearts()
	
	attack_hitbox = $AttackHitbox
	# Signals
	attack_hitbox.body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	body.take_damage(10, body.position - self.position)
	
func remove_heart() -> void:
	if hearts_container.get_child_count() > 0:
		hearts_container.get_child(-1).queue_free()

var attacking: bool = false
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and not attacking:
		attacking = true
		attack_hitbox.monitoring = true
		attack_hitbox.visible = true
		await get_tree().create_timer(.2).timeout
		attack_hitbox.monitoring = false
		attack_hitbox.visible = false
		attacking = false
		

func _get_input() -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED 
	
	if direction != Vector2.ZERO:
		if abs(direction.x) >= abs(direction.y):
			sprite.animation = "right" if direction.x > 0 else "left"
		else:
			sprite.animation = "down" if direction.y > 0 else "up"
		sprite.play()
	else:
		sprite.stop()
			  
func _physics_process(delta) -> void:
	if not is_knockback:
		_get_input()
	
	move_and_slide()
	
func _blink_damage(interval: float = 0.1) -> void:
	sprite.modulate = Color(1, 0, 0) 
	await get_tree().create_timer(interval).timeout

	sprite.modulate = Color(1, 1, 1) 
	await get_tree().create_timer(interval).timeout

func _blink_invincibility(interval: float = 0.1):
	while is_invincible:
		sprite.modulate.a = 0.5  
		await get_tree().create_timer(interval).timeout

		sprite.modulate.a = 1 
		await get_tree().create_timer(interval).timeout

func _give_invincibility() -> void:
	is_invincible = true
	_blink_invincibility()
	await get_tree().create_timer(INVINCIBILITY_TIME).timeout
	is_invincible = false

func _apply_knockback(knockback: Vector2):
		is_knockback = true
		velocity = knockback.normalized() * KNOCKBACK_MAGNITUDE

		await get_tree().create_timer(KNOCKBACK_TIME).timeout
		is_knockback = false
		velocity = Vector2.ZERO
		
		#TODO: play knockback animation
		sprite.stop()
		
func take_damage(amount: int, knockback: Vector2) -> void:
	if not is_invincible:
		health -= amount
		remove_heart()
		_blink_damage()
		_give_invincibility()
		_apply_knockback(knockback)
		

	
