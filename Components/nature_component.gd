class_name NatureObject extends StaticBody2D

signal item_dropped(item: ItemResource)
@export var nature_item: ItemResource = null
@onready var hurt_box: HurtBox = $HurtBox
@onready var stats_component: StatsComponents = $StatsComponents


func _ready() -> void:
	add_to_group("nature_objects")
	hurt_box.hurtbox_entered.connect(_on_area_entered)
	

func _on_area_entered(hitbox: HitBox) -> void:
	hitbox.attack_effects
	if nature_item:
		emit_signal("item_dropped", nature_item)
