class_name SaverLoader
extends Node
## @brief manages loading and saving of game states

@export var has_saved_game: bool
@export var SavedGame : saved_game
@export var save_file_name: String = "save_file.tres"
var save_path: String

func _ready() -> void:
	save_path =  "res://resources/save_files/%s" % save_file_name

func save_game():
	ResourceSaver.save(saved_game, save_path)
	
func load_game():
	if FileAccess.file_exists(save_path):
		var res = ResourceLoader.load(save_path)
		if res and res is saved_game:
			SavedGame = res
		else:
			SavedGame =  saved_game.new()  # fallback to a new save
	else:
		SavedGame =  saved_game.new()  # no file, start fresh

func reset_game():
	SavedGame =  saved_game.new()
	save_game()


func update_level_completed():
	SavedGame.level_completed += 1;
	save_game()
