class_name NatureObject extends StaticBody2D

signal item_dropped(item: ItemResource)
signal nature_object_died(obj: NatureObject)

@export var nature_item: ItemResource = null

@onready var _hurtbox: Hurtbox = $Hurtbox
@onready var _stats_component: StatsComponents = $StatsComponents
@onready var _damaged_effects: AnimationPlayer = $DamagedEffects


func _ready() -> void:
	add_to_group("nature_objects")
	_hurtbox.hurtbox_entered.connect(_on_area_entered)
	_stats_component.died.connect(_die)


func create_scene() -> NatureObject:
	assert(false, "Must be implemented by children")
	return null
	
	
func _on_area_entered(hitbox: Hitbox) -> void:
	for effect in hitbox.attack_effects:
		effect.apply(self, hitbox.global_position)
		
	if nature_item:
		emit_signal("item_dropped", nature_item)
	
	if _damaged_effects:
		_damaged_effects.play("damaged")


func apply_damage(damage: int, hitbox_position: Vector2) -> void:
	_stats_component.apply_damage(damage)


func _die() -> void:
	emit_signal("nature_object_died", self)
