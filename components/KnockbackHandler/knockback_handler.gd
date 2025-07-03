class_name KnockbackHandler extends Node

@export var _character: CharacterBody2D

var _is_knockedback: bool 

func apply_knockback(vector: Vector2, duration: float) -> void:
	if not _character: return

	_is_knockedback = true
	_character.velocity = vector
	await get_tree().create_timer(duration).timeout
	_character.velocity = Vector2.ZERO
	_is_knockedback = false
