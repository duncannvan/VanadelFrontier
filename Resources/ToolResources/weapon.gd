class_name WeaponResource extends ToolResource

@export var _damage: int
@export var _knockback_mag: float

func USING_TOOL() -> void:
	push_error("virtual method, USING_TOOL, must be implemented")
