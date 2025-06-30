class_name HitBox extends Area2D

@export var damage = 10
@export var body_hitbox: bool = false

func _ready() -> void:
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)

var player_in_body_hitbox: bool = false
const DAMAGE_INTERVAL = .5
func _on_area_entered(hurtbox: HurtBox) -> void:
	if body_hitbox:
		var player: CharacterBody2D = hurtbox.get_parent()
		player_in_body_hitbox = true
		while player_in_body_hitbox:
			player.take_damage(damage)
			await get_tree().create_timer(DAMAGE_INTERVAL).timeout

func _on_area_exited(hurtbox: HurtBox) -> void:
	player_in_body_hitbox = false

func on() -> void:
	self.get_node("CollisionShape2D").set_deferred("disabled", false)
	#self.get_node("HitEffects").visible = true
	
func off() -> void:
	self.get_node("CollisionShape2D").set_deferred("disabled", true)
	#self.get_node("HitEffects").visible = false
