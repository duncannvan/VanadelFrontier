class_name ToolResource extends Resource

@export var name: String
@export var texture: Texture2D
@export var cooldown_sec: float # Time between uses
@export var animation_libs: Array[AnimationLibrary]

#Virtual
func USING_TOOL() -> void:
	push_error("virtual method, USING_TOOL, must be implemented")
