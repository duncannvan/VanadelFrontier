class_name BaseToolResource extends Resource

enum AnimationDirection
{
	UP,
	DOWN,
	LEFT,
	RIGHT
}
@export var name: String
@export var texture: Texture2D
@export var cooldown_sec: float # Time between uses
@export var animation_libs: Array[AnimationLibrary]
@export var dict: Dictionary[AnimationDirection, Animation]

#Virtual
func use_tool() -> void:
	push_error("virtual method, use_tool, must be implemented")
