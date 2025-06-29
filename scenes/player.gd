extends CombatEntityBase

const INVINCIBILITY_TIME = 1

@export var is_invincible = false

const HEARTS_CONTAINER_PATH = '../Player/Hearts'
var hearts_container: Container
var heart_scene: Resource = preload('res://scenes/heart.tscn')

func _initialize_hearts() -> void:
	hearts_container = get_node(HEARTS_CONTAINER_PATH)
	for i in range(10):
		var heart = heart_scene.instantiate()
		hearts_container.add_child(heart)

func _ready() -> void:
	# Constructor
	speed = 100
	damage = 50
	sprite = $AnimatedSprite2D
	hitbox = $Hitbox
	hurtbox = $Hurtbox
	
	_initialize_hearts()
	
	# Signals
	hitbox.area_entered.connect(_on_area_entered)
	
# if mob found in hitbox
func _on_area_entered(area: Area2D) -> void:
	var mob = area.get_parent()
	mob.take_damage(damage, (mob.position - self.position).normalized())
	
func remove_heart() -> void:
	if hearts_container.get_child_count() > 0:
		hearts_container.get_child(-1).queue_free()

# Turns on hitbox
var attacking: bool = false
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and not attacking:
		attacking = true
		hitbox.monitoring = true
		hitbox.visible = true
		await get_tree().create_timer(.2).timeout
		hitbox.monitoring = false
		hitbox.visible = false
		attacking = false
		

func _get_input() -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed 
	
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

func take_damage(damageAmount: int, knockbackDirection: Vector2 = Vector2.ZERO) -> void:
	if not is_invincible:
		_blink_damage()
		_give_invincibility()
		remove_heart()
		super.take_damage(damageAmount, knockbackDirection)	

	
