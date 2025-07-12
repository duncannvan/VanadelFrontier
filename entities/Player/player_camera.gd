extends Camera2D

@export var _random_strength := 5.0
@export var _shake_fade := 10.0

var _shake_strength := 0.0
var rng = RandomNumberGenerator.new()

func shake_camera() -> void:
	_shake_strength = _random_strength


func _process(delta: float) -> void:
	if _shake_strength > 0:
		_shake_strength = lerpf(_shake_strength, 0, _shake_fade * delta)
	
	offset = _random_offset()


func _random_offset():
	return Vector2(rng.randf_range(-_shake_strength, _shake_strength), rng.randf_range(-_shake_strength, _shake_strength))
	
