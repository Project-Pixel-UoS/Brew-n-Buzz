## @brief Allows a button to be pressed that will extend/retract the tea drawer
extends TextureButton

@onready var pullOutButton = %DrawerButton
var new_position
var old_position
var been_pressed = false
var children = []

func _ready() -> void:
	children = get_child(0).get_children()
	for i in children:
		i.visible = false
		i.set_respawn_position()
	old_position = pullOutButton.position
	new_position = Vector2(old_position.x - get_child(0).size.x, old_position.y)

func drawer_press() -> void:
	children = get_child(0).get_children()
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
