class_name RangedWeaponResource extends WeaponResource

@export var projectile_scene: PackedScene = null:
	get():
		assert(projectile_scene, "Attempt to retrieve null")
		return projectile_scene
	
@export var projectile_speed: float = 0.0
@export var max_range: float = 0.0

#Override
func use_tool() -> void:
	#TODO:Implement
	print("Using Ranged")
	pass
	
