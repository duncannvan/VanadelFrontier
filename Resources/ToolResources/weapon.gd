class_name WeaponResource extends ToolResource

@export var _damage: int = 0
@export var _knockback_mag: float = 0.0


#func use_tool() -> void:
	#push_error("virtual method, use_tool(), must be implemented")
