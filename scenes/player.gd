extends CharacterBody2D

const SPEED = 100
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var health = 100

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
	_get_input()
	move_and_slide()
	
func _blink_red(blinks: int = 3, interval: float = 0.1) -> void:
	for i in blinks:
		modulate = Color(1, 0, 0)  # Red
		await get_tree().create_timer(interval).timeout

		modulate = Color(1, 1, 1)  # Normal
		await get_tree().create_timer(interval).timeout
	
func take_damage(amount) -> void:
	health -= amount
	
	_blink_red()
	
