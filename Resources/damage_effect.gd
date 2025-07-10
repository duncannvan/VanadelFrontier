class_name DamageEffect extends AttackEffect

@export var _damage: int = 1

func apply(target: CombatUnit):
	if target.get_node_or_null("HealthComponent"):
		target.apply_damage(_damage)
	else:
		push_warning("Attempting to damage entity without healh component")
	
