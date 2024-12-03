extends TextureButton
## @brief Initialises a level button with the correct data

@export var level_number: int
@export var level_filename: String = "level_%d.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#level_filename = level_filename % level_number
	$Label.text = "level %d" % level_number
	name = "LevelButton%d" % level_number
	level_filename = "scenes/level_%d.tscn" % level_number


## @brief Loads levelscne
func _on_pressed() -> void:
	get_tree().change_scene_to_file(level_filename)
