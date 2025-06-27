extends CharacterBody2D

@export var speed = 200
@onready var sprite = $AnimatedSprite2D

func get_input():
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	if direction != Vector2.ZERO:
		if abs(direction.x) >= abs(direction.y):
			sprite.animation = "right" if direction.x > 0 else "left"
		else:
			sprite.animation = "down" if direction.y > 0 else "up"
		sprite.play()
	else:
		sprite.stop()
		
func _physics_process(delta):
	get_input()
	move_and_slide()
