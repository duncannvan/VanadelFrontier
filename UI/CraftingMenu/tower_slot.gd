class_name TowerSlot extends TextureButton

@onready var _item_texture_rect: TextureRect = %ItemTextureRect

@export var tower_scene: PackedScene
@export var tower_slot_texture: Texture2D

func _ready() -> void:
	_item_texture_rect.texture = tower_slot_texture
