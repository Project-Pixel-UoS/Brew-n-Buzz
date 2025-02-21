## @brief Allows a button to be pressed that will extend/retract the tea drawer
extends Button

@onready var pullOutButton = %DrawerButton
var new_position = Vector2(1380,341)
var old_position = Vector2(0,0)
var been_pressed = false
var children = []

func _ready() -> void:
	children = get_children()
	for i in children:
		i.visible = false
	old_position = pullOutButton.position
	new_position = Vector2(old_position.x - 511.996, old_position.y)

func drawer_press() -> void:
	if !been_pressed:
		been_pressed = true
		for i in children:
			i.visible = true
		pullOutButton.position = old_position.lerp(new_position,1)
	else:
		been_pressed = false
		pullOutButton.position = new_position.lerp(old_position,1)
		for i in children:
			i.visible = false
