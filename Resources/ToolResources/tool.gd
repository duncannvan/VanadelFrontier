class_name ToolResource extends Resource

@export var name: String = ""
@export var texture: Texture2D = null:
	get():
		assert(texture, "Attempt to retrieve null")
		return texture
@export var cooldown_sec: float = 0 # Time between uses
@export var animation_libs: Array[AnimationLibrary] = []
@export var _atk_effects: Array[AttackEffect] = []

var cooling_down: bool = false

#Virtual
func use_tool(player: Player) -> void:
	push_error("virtual method, use_tool(), must be implemented")
	

func on_switch_in(player: Player) -> void:
	player._hitbox.set_attack_effects(_atk_effects)
	

func on_switch_out(player: Player) -> void:
	pass


func get_cooldown_sec() -> float:
	return cooldown_sec


func get_lib_idx() -> int:
	return 0


func reset_lib_idx() -> void:
	pass
