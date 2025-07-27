class_name MeleeWeaponResource extends WeaponResource

const COMBO_LIMIT: int = 3
var combo_step: int = 0:
	set(value):
		combo_step = wrapi(value, 0, COMBO_LIMIT)
		
#Override
func use_tool() -> void:
	combo_step += 1
	pass
	
func get_cooldown_sec() -> float:
	var first_idx_key = animation_libs[combo_step].get_animation_list()[0]
	print(combo_step)
	if combo_step >= animation_libs.size() - 1:
		return animation_libs[combo_step].get_animation(first_idx_key).length + cooldown_sec
		
	return animation_libs[combo_step].get_animation(first_idx_key).length


func get_lib_idx() -> int:
	return combo_step


func reset_lib_idx() -> void:
	combo_step = 0
