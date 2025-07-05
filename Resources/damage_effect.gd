class_name DamageEffect extends AttackEffect

@export var _damage: int = 10

func apply(target: CombatUnit, hitbox_position: Vector2 = Vector2.ZERO):
	target.get_node("HealthComponent").take_damage(_damage)
	
