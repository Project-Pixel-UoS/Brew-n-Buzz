class_name Menu
extends Control
## @brief controls how the menu is tweened

@export var start_position: MenuManager.Position = MenuManager.Position.UP
@export var is_active: bool
var out_position: Vector2

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	out_position = MenuManager.get_start_position(start_position, size)
	if not is_active:
		position = out_position
