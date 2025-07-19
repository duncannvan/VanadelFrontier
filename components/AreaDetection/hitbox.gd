class_name HitBox extends Area2D

signal hitbox_entered(hurtbox: HurtBox)

@export var attack_effects: Array[AttackEffect]

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	connect("area_entered", _on_area_entered)


func _on_area_entered(hurtbox: HurtBox) -> void:
	if hurtbox.get_invincible(): 
		return

	hurtbox.hurtbox_entered.emit(self)


func set_hitbox_enable(state: bool) -> void:
	collision_shape_2d.set_deferred("disabled", !state)
