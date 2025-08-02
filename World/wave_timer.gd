extends Control

var timer: Timer

@onready var _label: Label = $Label


func _process(delta: float) -> void:
	if not timer: return
	_label.text = "%d Seconds before the next wave" % timer.time_left
	if timer.time_left <= 0.0:
		timer = null
		visible = false
	

func start_countdown(wave_countdown_timer: Timer):
	visible = true
	timer = wave_countdown_timer
