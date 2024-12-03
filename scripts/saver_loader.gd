class_name SaverLoader
extends Node
## @brief manages loading and saving of game states

@export var has_saved_game: bool
@export var saved_game : SavedGame

func save_game():
	ResourceSaver.save(saved_game, "user://savegame.tres")
	
func load_game():
	saved_game = load("user://savegame.tres") as SavedGame
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
