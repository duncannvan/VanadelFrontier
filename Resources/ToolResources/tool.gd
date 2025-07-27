class_name ToolResource extends Resource

@export var name: String = ""
@export var texture: Texture2D = null:
	get():
		assert(texture, "Attempt to retrieve null")
		return texture
@export var texture_positions_adj: Vector2 = Vector2.ZERO
@export var cooldown_sec: float = 0 # Time between uses
@export var animation_libs: Array[AnimationLibrary] = []


#Virtual
func use_tool() -> void:
	push_error("virtual method, use_tool(), must be implemented")
