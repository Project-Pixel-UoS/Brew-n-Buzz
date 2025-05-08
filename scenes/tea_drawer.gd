## @brief Allows a button to be pressed that will extend/retract the tea drawer
extends TextureButton

@onready var pullOutButton = %DrawerButton
var new_position
var old_position
var been_pressed = false
var children = []
@onready var milkJug = %MilkJug

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
		milkJug.get_node('Area2D').input_pickable = false
		var tween = get_tree().create_tween()
		tween.tween_property(pullOutButton, "position", new_position, 0.2).set_ease(Tween.EASE_OUT)
		await tween.finished
	else:
		been_pressed = false
		var tween = get_tree().create_tween()
		tween.tween_property(pullOutButton, "position", old_position, 0.2).set_ease(Tween.EASE_OUT)
		await tween.finished
		for i in children:
			i.visible = false
		milkJug.get_node('Area2D').input_pickable = true
