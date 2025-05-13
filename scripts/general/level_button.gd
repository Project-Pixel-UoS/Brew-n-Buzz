extends TextureButton
## @brief Initialises a level button with the correct data

@export var level_number: int
@export var level_filename: String = "level_%d.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_filename = level_filename % level_number
	name = "LevelButton%d" % level_number
	level_filename = "scenes/levels/level_%d.tscn" % level_number
	self.texture_normal = load("res://assets/images/menu/level icons/level_%d_icon.png" % level_number)
	self.custom_minimum_size = Vector2(192,192)
## @brief Loads levelscne
func _on_pressed() -> void:
	get_tree().change_scene_to_file(level_filename)
