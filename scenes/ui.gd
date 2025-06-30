extends CanvasLayer

@export var player: CharacterBody2D
@onready var hearts: Container = $Hearts
@export var heart_scene: PackedScene

func _ready() -> void:
	player.health_changed.connect(_on_health_changed)
	_on_health_changed(player._health)
	
func _on_health_changed(health: int) -> void:
	for child in hearts.get_children():
		child.queue_free()

	for i in range(int(health / 10)):
		var heart = heart_scene.instantiate()
		hearts.add_child(heart)

		
