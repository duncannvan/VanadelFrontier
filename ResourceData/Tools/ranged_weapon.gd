class_name RangedWeapon extends Node2D

@export var _weapon_data: RangedWeaponResource
#@export var _weapon_node: Player = null

var _is_cooldown = false

func try_fire(direction: Vector2):
	if _is_cooldown or !_weapon_data:
		return

	_is_cooldown = true
	fire(direction)
	await get_tree().create_timer(_weapon_data.cooldown).timeout
	_is_cooldown = false

func fire(direction: Vector2):
	var projectile = _weapon_data.projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.velo
	#get_parent().add_child(projectile)
