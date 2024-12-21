extends Node
@onready var timer: Timer = %Timer

func _process(delta: float) -> void:
	if timer.out_of_time():
		print_debug("out of time")
