# patience_meter.gd
extends Node2D

signal customer_angry

@onready var animationPlayer = %AnimationPlayer
@onready var timer = %Timer

var emotions = ['happy', 'ok', 'angry']
var index = 1
var out_of_patience = false
var parent_manager: Node = null

func start_meter(manager: Node):
	parent_manager = manager
	index = 1
	out_of_patience = false
	animationPlayer.play(emotions[0])
	timer.wait_time = 5  # Adjust timing as needed
	timer.start()

func _on_timer_timeout() -> void:
	if index > 2:
		out_of_patience = true
		animationPlayer.play("angry")
		timer.stop()
		emit_signal("customer_angry")
	else:
		animationPlayer.play(emotions[index])
		index += 1
		timer.start()
