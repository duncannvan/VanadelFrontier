class_name health_bar extends TextureProgressBar

func update(old_health: int, new_health: int) -> void:
	value = new_health
