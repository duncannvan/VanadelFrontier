extends HitBox

var speed: float = 180  # Pixels per second
var velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	connect("area_entered", _on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += velocity * delta * speed

func _set_v(v):
	velocity = v  

func _on_area_entered(hurtbox: HurtBox):
	super._on_area_entered(hurtbox)
	queue_free()
