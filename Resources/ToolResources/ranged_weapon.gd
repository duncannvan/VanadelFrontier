class_name RangedWeaponResource extends WeaponResource

@export var projectile_scene: PackedScene = null:
	get():
		assert(projectile_scene, "Attempt to retrieve null")
		return projectile_scene
	
@export var projectile_speed: float = 0.0
@export var max_range: float = 0.0


#Override
func use_tool() -> void:
	pass
	

func create_projectile(position: Vector2, mouse_pos: Vector2) -> HitBox:
	var projectile_dir: Vector2 = position.direction_to(mouse_pos)
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.global_position = position
	projectile.rotation = projectile_dir.angle()
	projectile.set_velocity(projectile_dir)
	return projectile
