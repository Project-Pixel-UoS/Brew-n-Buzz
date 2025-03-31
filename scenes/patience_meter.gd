extends Node2D

@onready var animationPlayer = %AnimationPlayer
@onready var timer = %Timer
var out_of_patience = false
var emotions = ['happy','ok','angry']
var index = 1

func _ready() -> void:
	timer.wait_time = 5
	timer.start()

func get_out_of_patience():
	return out_of_patience

func _on_timer_timeout() -> void:
	if index > 2:
		print("out of patience")
		out_of_patience = true
		timer.stop()
		# customer will leave
	else:
		animationPlayer.play(emotions[index])
		index+= 1
		timer.start()
