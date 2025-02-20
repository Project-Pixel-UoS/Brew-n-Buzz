extends Button

var target : Control
var button_position : Vector2
var new_position = Vector2(1400,394)
var old_position = Vector2(1477,394)
var been_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_parent()
	button_position = target.position

func drawer_press() -> void:
	if !been_pressed:
		been_pressed = true
		target.position = button_position.lerp(new_position,1)
	else:
		been_pressed = false
		target.position = new_position.lerp(old_position,1)
