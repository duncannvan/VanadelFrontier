class_name Projectile extends Hitbox

# TODO: Tower Component should take in a tower resource with speed data and pass it here
@export var _speed: float = 0
var _velocity: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	global_position += _velocity * delta * _speed


func _on_area_entered(hurtbox: Hurtbox) -> void:
	super._on_area_entered(hurtbox)
	queue_free()


func set_velocity(velocity: Vector2)-> void:
	_velocity = velocity
