extends CanvasLayer

@onready var retry_button = $RetryButton

func _ready() -> void:
	retry_button.connect("button_down", _on_button_down)
	

func _on_button_down() -> void:
	get_tree().change_scene_to_file("res://World/main.tscn")
	
	
