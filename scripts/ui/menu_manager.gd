class_name MenuManager
extends CanvasLayer
## @brief transitions a group of child menu objects

@export var transition_type: Tween.TransitionType = Tween.TRANS_CUBIC
@export var ease_type: Tween.EaseType = Tween.EASE_IN_OUT
@export var duration: float = 0.8


enum Position {UP, RIGHT, DOWN, LEFT}

func _ready() -> void:
	SignalBus.connect("load_level", _on_level_loading)

func _on_level_loading(_level):
	print("loading level")
	self.visible = false

func _on_menu_button_pressed(menu_name: String) -> void:
	assert(menu_name, "menu_name is not set")
	for menu: Menu in self.get_children():
		#if menu.name != menu_name and menu.position == menu.out_position:
			#continue
		transition(menu, menu.name == menu_name)


func transition(menu: Menu, going_in: bool = true):
	var end_position: Vector2 = Vector2()
	var out_position: Vector2 = menu.out_position
	var tween: Tween = get_tree().create_tween()
	
	if going_in:
		tween.tween_property(menu, "position", out_position, 0)
	else:
		end_position = out_position
	
	tween.tween_property(menu, "position", end_position, duration).set_ease(
			ease_type).set_trans(transition_type)


static func get_start_position(position: Position, size: Vector2):
	var start_position: Vector2 = Vector2()

	match position:
		Position.UP:
			start_position.y = -size.y
		Position.DOWN:
			start_position.y = size.y
		Position.LEFT:
			start_position.x = -size.x
		Position.RIGHT:
			start_position.x = size.x

	return start_position
