class_name Item extends Resource

@export var name: String = ""
@export var texture: Texture2D = null:
	get():
		assert(texture, "Attempt to retrieve null")
		return texture
 
