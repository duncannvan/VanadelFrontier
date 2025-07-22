class_name Projectile extends HitBox

const MAX_SPEED: int = 200
const MIN_SPEED: int = 1

@export_range(MIN_SPEED, MAX_SPEED) var _speed: int = MIN_SPEED

var _target: CombatUnit = null


func _ready() -> void:
	connect("area_entered", _on_area_entered)


func _physics_process(delta: float):
	if not _target: 
		queue_free()
		return

	look_at(_target.global_position)
	global_position += global_position.direction_to(_target.global_position) * _speed * delta


func _on_area_entered(hurtbox: HurtBox):
	super._on_area_entered(hurtbox)
	queue_free()


func set_target(target: CombatUnit):
	_target = target
	
