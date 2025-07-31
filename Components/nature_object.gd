class_name NatureObject extends StaticBody2D

signal item_dropped(item: ItemResource)

@export var nature_item: ItemResource = null

@onready var _hurtbox: HurtBox = $HurtBox
@onready var _stats_component: StatsComponents = $StatsComponents


func _ready() -> void:
	add_to_group("nature_objects")
	_hurtbox.hurtbox_entered.connect(_on_area_entered)
	_stats_component.died.connect(_die)

func _on_area_entered(hitbox: HitBox) -> void:
	for effect in hitbox.attack_effects:
		effect.apply(self, hitbox.global_position)
		
	if nature_item:
		emit_signal("item_dropped", nature_item)


func apply_damage(damage: int, hitbox_position: Vector2) -> void:
	_stats_component.apply_damage(damage)


func _die() -> void:
	queue_free()
