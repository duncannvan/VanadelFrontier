class_name RangedWeaponResource extends WeaponResource

@export var projectile_scene: PackedScene = null:
	get():
		assert(projectile_scene, "Attempt to retrieve null")
		return projectile_scene


#Override
func use_tool(player: Player) -> void:
	var mouse_pos: Vector2 = player.get_viewport().get_camera_2d().get_global_mouse_position()
	var projectile: Projectile = projectile_scene.instantiate()
	var projectile_dir: Vector2 = player.global_position.direction_to(mouse_pos)
	projectile.global_position = player.global_position
	projectile.rotation = projectile_dir.angle()
	projectile.set_velocity(projectile_dir)
	projectile.set_attack_effects(_atk_effects)
	player.get_parent().add_child(projectile)
