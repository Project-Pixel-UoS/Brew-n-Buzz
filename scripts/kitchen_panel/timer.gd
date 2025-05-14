extends Timer
@onready var timer: Timer = %Timer
@onready var time_remaining: RichTextLabel = %TimeRemaining

var game_time_scale = 0.5 #Every real second is two in-game
var round_time_hours = 1 #How many hours is a shift from 12pm
var game_time_seconds = 600 #round_time_hours * 60
var finished = false

func out_of_time():
	return finished
	
func _ready() -> void:
	timer.wait_time = 1/float(game_time_scale)
	time_remaining.text= "[center]12:00"
	timer.start()

func _format_time()-> String:
	var times = time_remaining.text.split(":")
	
	if "59" in times[1]:
		times[1] = "00"
		times[0] = str(int(times[0]) + 1)
	else:
		if int(times[1]) < 9:
			times[1] = "0" + str(int(times[1]) + 1)
		else:
			times[1] = str(int(times[1]) + 1)
	return "[center]" + times[0] + ":" + times[1]

func _on_timeout() -> void:
	game_time_seconds -= 1
	if game_time_seconds == 0:
		timer.stop()
		time_remaining.text = _format_time()
		finished = true
	else:
		time_remaining.text = _format_time()
		timer.start()
