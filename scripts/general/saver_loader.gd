class_name SaverLoader
extends Node
## @brief manages loading and saving of game states

@export var has_saved_game: bool
@export var saved_game : SavedGame
@export var save_file_name: String = "savegame.tres"
var save_path: String

func _ready() -> void:
	save_path =  "user://%s" % save_file_name

func save_game():
	ResourceSaver.save(saved_game, save_path)
	
func load_game():
	if FileAccess.file_exists(save_path):
		saved_game = load(save_path) as SavedGame
	has_saved_game = saved_game.level_started > 0;

func reset_game():
	saved_game = SavedGame.new()
	save_game()

func update_level_started():
	saved_game.level_started += 1;
	save_game()

func update_level_completed():
	saved_game.level_completed += 1;
	save_game()
