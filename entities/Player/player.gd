extends CombatEntityBase

const INVINCIBILITY_TIME = 1

@export var is_invincible = false

signal health_changed(health: int)

#TODO: Turn off attacking and move when dead

func _ready() -> void:
	# Constructor
	speed = 100
	damage = 50
	sprite = $AnimatedSprite2D
	hitbox = $Hitbox
	hurtbox = $Hurtbox
	health = 30
	
	# Signals
	hitbox.area_entered.connect(_on_area_entered)
	
# if mob found in hitbox
func _on_area_entered(area: Area2D) -> void:
	var mob = area.get_parent()
	var direction: Vector2 = (mob.position - self.position).normalized()
	if direction == Vector2.ZERO:
		direction = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
	mob.take_damage(damage, direction)

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
		_give_invincibility()
		super.take_damage(damageAmount, knockbackDirection)	
		
		# Update GUI
		health_changed.emit(health)

	
