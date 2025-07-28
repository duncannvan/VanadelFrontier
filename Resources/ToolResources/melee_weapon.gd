class_name MeleeWeaponResource extends WeaponResource

@export var weapon_pivot: PackedScene = null

const COMBO_LIMIT: int = 3
var _pivot_node_path: NodePath = ""
var _combo_step: int = 0:
	set(value):
		_combo_step = wrapi(value, 0, COMBO_LIMIT)
		
#Override
func use_tool(player: Player) -> void:
	_combo_step += 1
	pass
	
func get_cooldown_sec() -> float:
	var first_idx_key = animation_libs[_combo_step].get_animation_list()[0]
	if _combo_step >= animation_libs.size() - 1:
		return animation_libs[_combo_step].get_animation(first_idx_key).length + cooldown_sec
		
	return animation_libs[_combo_step].get_animation(first_idx_key).length


func get_lib_idx() -> int:
	return _combo_step


func reset_lib_idx() -> void:
	_combo_step = 0


func on_switch_in(player: Player) -> void:
	var pivot: Marker2D = weapon_pivot.instantiate()
	pivot.global_position = player.global_position
	player.add_child(pivot)
	_pivot_node_path = pivot.get_path()

func on_switch_out(player: Player) -> void:
	var pivot: Marker2D = player.get_node(_pivot_node_path)
	pivot.queue_free()
