class_name TowerProjectile extends Projectile

var _target: CombatUnit = null

@export var _atk_effects: Array[AttackEffect] = [] #TODO: This should be a tower resource that contains the effects

func _ready() -> void:
	super._ready()
	set_attack_effects(_atk_effects)

	
func _physics_process(delta: float) -> void:
	if not _target: 
		queue_free()
		return

	look_at(_target.global_position)
	global_position += global_position.direction_to(_target.global_position) * _speed * delta


func set_target(target: CombatUnit) -> void:
	_target = target
