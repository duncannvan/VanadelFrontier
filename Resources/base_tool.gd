class_name BaseToolResource extends Resource

@export var name: String
@export var texture: Texture2D
@export var cooldown: float # Time between uses

#Virtual
func use_tool() -> void:
	push_error("virtual method, use_tool, must be implemented")
	
